#!/usr/bin/env bash
# Diagnóstico completo de um arquivo de áudio ou vídeo: preflight, loudness, picos e clipping,
# DC offset, silêncios longos e compatibilidade mono. Termina com um resumo
# "o que está bom / o que precisa de atenção" e uma recomendação para cada problema.
# Uso: diagnosticar.sh <arquivo> [--alvo <LUFS>] [--silencio <dB> <segundos>]
#   --alvo      compara o loudness integrado com um alvo (ex.: -14, -16, -23), tolerância de ±1 LU
#   --silencio  limiar e duração mínima de silêncio (padrão: -50 dB por 1 s)
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_comum.sh
source "$DIR/_comum.sh"

uso() {
  echo "Uso: $(basename "$0") <arquivo> [--alvo <LUFS>] [--silencio <dB> <segundos>]" >&2
  exit 2
}

arquivo=""
alvo=""
sil_db="-50"
sil_s="1"
while [ $# -gt 0 ]; do
  case "$1" in
    --alvo) [ $# -ge 2 ] || uso; alvo="$2"; shift 2 ;;
    --silencio) [ $# -ge 3 ] || uso; sil_db="$2"; sil_s="$3"; shift 3 ;;
    -h|--help) uso ;;
    *) [ -z "$arquivo" ] || uso; arquivo="$1"; shift ;;
  esac
done
[ -n "$arquivo" ] || uso

checar_dependencias
[ -f "$arquivo" ] || { echo "Erro: arquivo não encontrado: $arquivo" >&2; exit 2; }

bons=()
atencao=()
bom() { bons+=("$1"); }
atencao() { atencao+=("$1"); }

# 1. Preflight
echo "== 1. Preflight"
saida_pre="$("$DIR/preflight.sh" "$arquivo")"
printf '%s\n' "$saida_pre"
while IFS= read -r linha; do
  case "$linha" in "  ! "*) atencao "${linha#  ! }" ;; esac
done <<<"$saida_pre"
if [ -z "$(ffprobe -v error -select_streams a:0 -show_entries stream=index -of csv=p=0 "$arquivo" | tr -d '\r')" ]; then
  echo
  echo "Sem áudio: nada mais a medir."
  exit 0
fi

# 2. Loudness
echo
echo "== 2. Loudness e true peak"
"$DIR/medir.sh" "$arquivo" | sed 1d
read -r i lra tp <<<"$(medir_ebur128 "$arquivo")"
if [ "$i" = "-70.0" ]; then
  atencao "Arquivo em silêncio ou abaixo do gate de medição (-70 LUFS). Confira se a trilha certa foi exportada."
else
  if [ "$tp" != "-inf" ] && awk -v t="$tp" 'BEGIN { exit !(t > -1) }'; then
    atencao "True peak de ${tp} dBTP, acima de -1 dBTP: risco de distorção na conversão para AAC/MP3. Normalize com scripts/normalizar.sh ou ajuste o teto do limiter para -1 dBTP (-1,5 a -2 em Reels)."
  else
    bom "True peak de ${tp} dBTP, com folga para a conversão."
  fi
  plr="$(calc "$tp - ($i)")"
  if awk -v p="$plr" 'BEGIN { exit !(p < 8) }'; then
    atencao "PLR de ${plr} dB: master muito limitado, com pouca dinâmica de pico. Plataformas que normalizam vão abaixá-lo sem ganho de impacto; alivie o limiter."
  else
    bom "PLR de ${plr} dB: dinâmica de pico preservada."
  fi
  if awk -v l="$lra" 'BEGIN { exit !(l > 15) }'; then
    atencao "LRA de ${lra} LU: variação de loudness grande. Se for voz falada ou vídeo para celular, nivele com automação ou compressão (meta: 3 a 6 LU para fala)."
  fi
  if [ -n "$alvo" ]; then
    dif="$(calc "$i - ($alvo)")"
    if awk -v d="$dif" 'BEGIN { exit !(d > 1 || d < -1) }'; then
      atencao "Loudness integrado de ${i} LUFS, ${dif} LU fora do alvo de ${alvo} LUFS. Use scripts/normalizar.sh \"$arquivo\" ${alvo}."
    else
      bom "Loudness integrado de ${i} LUFS, dentro de ±1 LU do alvo de ${alvo} LUFS."
    fi
  fi
fi

# 3. Picos, clipping e DC offset (astats)
echo
echo "== 3. Picos, clipping e DC offset"
stats="$(ffmpeg -hide_banner -nostats -i "$arquivo" -map 0:a:0 \
  -af astats=measure_perchannel=none:measure_overall=Peak_level+RMS_level+DC_offset+Peak_count+Flat_factor \
  -f null - 2>&1 | tr -d '\r')"
campo() { printf '%s\n' "$stats" | awk -F': ' -v k="$1" 'index($0, k ": ") { v = $NF } END { print v }'; }
pico="$(campo "Peak level dB")"
rms="$(campo "RMS level dB")"
dc="$(campo "DC offset")"
n_pico="$(campo "Peak count")"
flat="$(campo "Flat factor")"
printf '  Pico (sample peak): %s dBFS\n' "$(awk -v p="$pico" 'BEGIN { printf "%.2f", p }')"
printf '  Nível RMS:          %s dBFS\n' "$(awk -v r="$rms" 'BEGIN { printf "%.2f", r }')"
printf '  DC offset:          %s\n' "$dc"
printf '  Ocorrências no pico: %s, flat factor: %s\n' "$(awk -v n="$n_pico" 'BEGIN { printf "%d", n }')" "$(awk -v f="$flat" 'BEGIN { printf "%.2f", f }')"

if awk -v p="$pico" 'BEGIN { exit !(p > 0.01) }'; then
  atencao "Pico acima de 0 dBFS (arquivo em ponto flutuante). Vai clipar ao converter para 16/24 bits ou para AAC: abaixe o ganho ou use limiter antes de exportar."
elif awk -v p="$pico" -v f="$flat" 'BEGIN { exit !(p >= -0.1 && f > 0) }'; then
  atencao "Clipping detectado: o sinal encosta em 0 dBFS com topos achatados ($(awk -v n="$n_pico" 'BEGIN { printf "%d", n }') ocorrências no pico). Se veio da gravação, tente um declipper (iZotope RX De-clip ou similar) e regrave com menos ganho; se veio da mix ou do master, baixe o ganho antes do limiter."
else
  bom "Sem clipping digital."
fi
if awk -v d="$dc" 'BEGIN { if (d < 0) d = -d; exit !(d > 0.005) }'; then
  atencao "DC offset (média do sinal) de ${dc}: há componente contínua ou subsônica (abaixo de 20 Hz), comum em interface ou microfone com problema e em ruído de vento ou manuseio. Remova com HPF a 20 a 30 Hz (ffmpeg: -af highpass=f=20) ou com a função de remover DC da DAW."
fi

# 4. Silêncios longos
echo
echo "== 4. Silêncios (abaixo de ${sil_db} dB por ${sil_s} s ou mais)"
duracao="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$arquivo" | tr -d '\r')"
silencios="$(ffmpeg -hide_banner -nostats -i "$arquivo" -map 0:a:0 -af "silencedetect=noise=${sil_db}dB:d=${sil_s}" -f null - 2>&1 \
  | tr -d '\r' | awk -v dur="$duracao" '
      /silence_start:/ { for (k = 1; k <= NF; k++) if ($k == "silence_start:") ini = $(k + 1); aberto = 1 }
      /silence_end:/   { for (k = 1; k <= NF; k++) if ($k == "silence_end:") fim = $(k + 1); printf "%.2f %.2f\n", ini, fim; aberto = 0 }
      END { if (aberto) printf "%.2f %.2f\n", ini, dur }')"
if [ -z "$silencios" ]; then
  echo "  Nenhum silêncio longo."
  bom "Sem silêncios longos (abaixo de ${sil_db} dB por ${sil_s} s)."
else
  n_sil=0
  while read -r ini fim; do
    n_sil=$((n_sil + 1))
    onde="no meio"
    awk -v a="$ini" 'BEGIN { exit !(a < 0.05) }' && onde="no início"
    awk -v b="$fim" -v d="$duracao" 'BEGIN { exit !(d - b < 0.05) }' && onde="no fim"
    printf '  %d. de %s s a %s s (%s s, %s)\n' "$n_sil" "$ini" "$fim" "$(calc "$fim - $ini")" "$onde"
  done <<<"$silencios"
  atencao "${n_sil} silêncio(s) longo(s) listado(s) acima. Confira se são intencionais; em vídeo para redes, a fala deve começar já no início. Para cortar, veja referencias/edicao-fala.md."
fi

# 5. Compatibilidade mono
canais="$(canais_audio "$arquivo")"
if [ "$canais" -ge 2 ] 2>/dev/null; then
  echo
  echo "== 5. Compatibilidade mono"
  saida_mono="$("$DIR/checar-mono.sh" "$arquivo")"
  printf '%s\n' "$saida_mono" | grep -v '^Arquivo:'
  status="$(printf '%s\n' "$saida_mono" | grep -E '^(OK|Atenção|ALERTA)' | head -n 1)"
  case "$status" in
    OK*) bom "Boa compatibilidade mono." ;;
    ALERTA*) atencao "Problema de fase ou largura estéreo na soma mono. Ouça em mono e veja \"Fase entre microfones\" em referencias/troubleshooting.md." ;;
    Atenção*) atencao "Estéreo largo: confira em mono se voz, bumbo, baixo e caixa continuam firmes." ;;
  esac
fi

# Resumo
echo
echo "== Resumo"
echo "O que está bom:"
if [ ${#bons[@]} -eq 0 ]; then echo "  (nada a destacar)"; else for b in "${bons[@]}"; do echo "  + $b"; done; fi
echo "O que precisa de atenção:"
if [ ${#atencao[@]} -eq 0 ]; then echo "  (nada: o arquivo está tecnicamente em ordem)"; else for a in "${atencao[@]}"; do echo "  - $a"; done; fi
echo
echo "A medição não substitui a escuta: confirme ouvindo, em fone, em mono e no celular."
