#!/usr/bin/env bash
# Aplica os cortes aprovados de um cortes.json (gerado pelo marcar-cortes.py) num vídeo ou áudio.
# Corta imagem e som juntos, com microfades no áudio em cada emenda para evitar estalos,
# e roda o diagnosticar.sh na saída.
#
# Uso: aplicar-cortes.sh <arquivo> <cortes.json> --aprovado [--fade <ms>] [--saida <arquivo>]
#   --aprovado  obrigatório: confirma que o usuário revisou e aprovou os cortes.
#               Sem ele, o script só lista os cortes e não grava nada.
#   --fade      duração de cada microfade em ms (padrão: 10). Use 20 a 40 ms se ainda houver estalos.
#   --saida     padrão: <nome>_limpo.mp4 para vídeo e <nome>_limpo.wav para áudio.
#
# Cortes com "aplicar": false são ignorados. O vídeo é recodificado em H.264 (CRF 18) e o áudio
# em AAC 320 kbps, 48 kHz, porque cortar fora dos quadros-chave exige recodificar.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_comum.sh
source "$DIR/../_comum.sh"

uso() { echo "Uso: $(basename "$0") <arquivo> <cortes.json> --aprovado [--fade <ms>] [--saida <arquivo>]" >&2; exit 2; }

[ $# -ge 2 ] || uso
entrada="$1"
cortes_json="$2"
shift 2
aprovado=0
fade_ms=10
saida=""
while [ $# -gt 0 ]; do
  case "$1" in
    --aprovado) aprovado=1 ;;
    --fade) [ $# -ge 2 ] || uso; fade_ms="$2"; shift ;;
    --saida) [ $# -ge 2 ] || uso; saida="$2"; shift ;;
    *) uso ;;
  esac
  shift
done

checar_dependencias
checar_arquivo_audio "$entrada"
[ -f "$cortes_json" ] || { echo "Erro: arquivo de cortes não encontrado: $cortes_json" >&2; exit 2; }
case "$fade_ms" in ''|*[!0-9]*) echo "Erro: --fade precisa ser um número inteiro de ms." >&2; exit 2 ;; esac

video=0
tem_video "$entrada" && video=1
if [ -z "$saida" ]; then
  base="${entrada%.*}"
  if [ "$video" = 1 ]; then saida="${base}_limpo.mp4"; else saida="${base}_limpo.wav"; fi
fi
if [ "$saida" -ef "$entrada" ] 2>/dev/null || [ "$saida" = "$entrada" ]; then
  echo "Erro: a saída não pode ser o próprio arquivo de entrada." >&2
  exit 2
fi

duracao="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$entrada" | tr -d '\r')"
fps="1"
if [ "$video" = 1 ]; then
  fps="$(ffprobe -v error -select_streams v:0 -show_entries stream=avg_frame_rate -of csv=p=0 "$entrada" | tr -d '\r' \
    | awk '{ split($0, a, "/"); if (a[2] > 0 && a[1] > 0) printf "%.6f", a[1] / a[2]; else print 30 }')"
fi

# Lê os cortes do JSON: cada objeto com "inicio" e "fim" vira uma linha "inicio fim id".
# Objetos com "aplicar": false são ignorados. Não depende da formatação nem da ordem dos campos.
cortes="$(tr -d '\r' < "$cortes_json" | awk 'BEGIN { RS = "}" }
  function num(campo,   m) {
    if (match($0, "\"" campo "\"[ \t\n]*:[ \t\n]*-?[0-9]+(\\.[0-9]+)?")) {
      m = substr($0, RSTART, RLENGTH); sub(/^[^:]*:[ \t\n]*/, "", m); return m
    }
    return ""
  }
  {
    i = num("inicio"); f = num("fim")
    if (i == "" || f == "") next
    if ($0 ~ /"aplicar"[ \t\n]*:[ \t\n]*false/) next
    id = num("id"); if (id == "") id = "?"
    print i, f, id
  }' | sort -g -k1,1)"

if [ -z "$cortes" ]; then
  echo "Nenhum corte para aplicar em $cortes_json (todos removidos ou com \"aplicar\": false)."
  exit 0
fi

# Valida, junta cortes sobrepostos e calcula os trechos mantidos, alinhados aos quadros do vídeo
# (para a imagem e o som cortarem no mesmo ponto e não perderem sincronia).
trechos="$(printf '%s\n' "$cortes" | awk -v dur="$duracao" -v fps="$fps" -v video="$video" '
  function grade(t) { return video ? int(t * fps + 0.5) / fps : t }
  {
    i = $1 + 0; f = $2 + 0
    if (f <= i) { printf "Erro: o corte %s tem fim (%s) antes do início (%s).\n", $3, $2, $1 > "/dev/stderr"; erro = 1; next }
    if (i < 0) i = 0
    if (f > dur) f = dur
    if (n > 0 && i <= cf[n]) { if (f > cf[n]) cf[n] = f; next }
    n++; ci[n] = i; cf[n] = f
  }
  END {
    if (erro) exit 1
    pos = 0
    for (k = 1; k <= n; k++) {
      a = grade(pos); b = grade(ci[k])
      if (b - a > 0.04) printf "%.6f %.6f\n", a, b
      pos = cf[k]
    }
    a = grade(pos)
    if (dur - a > 0.04) printf "%.6f %.6f\n", a, dur
  }')" || exit 2

n_cortes="$(printf '%s\n' "$cortes" | wc -l | tr -d ' ')"
echo "Arquivo: $entrada ($(awk -v d="$duracao" 'BEGIN { printf "%.2f", d }') s)"
echo "Cortes a aplicar ($n_cortes):"
printf '%s\n' "$cortes" | awk '{ printf "  #%s  %8.3f s → %8.3f s  (%.2f s)\n", $3, $1, $2, $2 - $1 }'
final="$(printf '%s\n' "$trechos" | awk '{ s += $2 - $1 } END { printf "%.2f", s }')"
echo "Duração final esperada: $final s"

if [ "$aprovado" != 1 ]; then
  echo
  echo "Nada foi gravado. Mostre o relatório de cortes ao usuário e, só depois da aprovação,"
  echo "rode de novo com --aprovado."
  exit 3
fi

n_trechos="$(printf '%s\n' "$trechos" | grep -c .)"
if [ "$n_trechos" = 0 ]; then
  echo "Erro: os cortes removem o arquivo inteiro." >&2
  exit 2
fi
if [ -e "$saida" ]; then
  echo "Aviso: a saída já existe e será sobrescrita: $saida"
fi

# Monta o filtro num arquivo (muitos cortes passariam do limite da linha de comando).
script_filtro="$(mktemp)"
trap 'rm -f "$script_filtro"' EXIT
printf '%s\n' "$trechos" | awk -v video="$video" -v fade="$fade_ms" '
  {
    k = NR - 1; a = $1; b = $2; len = b - a
    d = fade / 1000; if (d > len / 4) d = len / 4
    if (video) printf "[0:v:0]trim=start=%s:end=%s,setpts=PTS-STARTPTS[v%d];\n", a, b, k
    printf "[0:a:0]atrim=start=%s:end=%s,asetpts=PTS-STARTPTS,afade=t=in:st=0:d=%.4f:curve=qsin,afade=t=out:st=%.6f:d=%.4f:curve=qsin[a%d];\n", a, b, d, len - d, d, k
    pares = pares (video ? "[v" k "]" : "") "[a" k "]"
  }
  END { printf "%sconcat=n=%d:v=%d:a=1%s\n", pares, NR, video, (video ? "[vout][aout]" : "[aout]") }' > "$script_filtro"

# ffmpeg 7 ou mais novo usa "-/filter_complex arquivo"; versões antigas, -filter_complex_script.
versao="$(ffmpeg -hide_banner -version | head -n 1 | sed -n 's/^ffmpeg version n\{0,1\}\([0-9]*\).*/\1/p')"
if [ -n "$versao" ] && [ "$versao" -lt 7 ]; then
  opcao_filtro=(-filter_complex_script "$script_filtro")
else
  opcao_filtro=(-/filter_complex "$script_filtro")
fi

if [ "$video" = 1 ]; then
  ffmpeg -hide_banner -loglevel error -nostats -y -i "$entrada" "${opcao_filtro[@]}" \
    -map "[vout]" -map "[aout]" -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p \
    -c:a aac -b:a 320k -ar 48000 -movflags +faststart "$saida"
else
  ffmpeg -hide_banner -loglevel error -nostats -y -i "$entrada" "${opcao_filtro[@]}" \
    -map "[aout]" -c:a pcm_s24le -ar 48000 "$saida"
fi

dur_saida="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$saida" | tr -d '\r')"
echo
echo "Gerado: $saida"
echo "Duração: $(awk -v d="$duracao" 'BEGIN { printf "%.2f", d }') s → $(awk -v d="$dur_saida" 'BEGIN { printf "%.2f", d }') s"
if [ "$video" = 1 ]; then
  dv="$(ffprobe -v error -select_streams v:0 -show_entries stream=duration -of csv=p=0 "$saida" | tr -d '\r')"
  da="$(ffprobe -v error -select_streams a:0 -show_entries stream=duration -of csv=p=0 "$saida" | tr -d '\r')"
  awk -v v="$dv" -v a="$da" -v fps="$fps" 'BEGIN {
    d = v - a; if (d < 0) d = -d
    if (d <= 2 / fps + 0.03) printf "Sincronia: imagem %.3f s, som %.3f s (ok).\n", v, a
    else printf "Atenção: imagem %.3f s e som %.3f s diferem em %.3f s. Confira a sincronia.\n", v, a, d
  }'
fi
echo "Ouça cada emenda antes de entregar."
echo
"$DIR/../diagnosticar.sh" "$saida"
