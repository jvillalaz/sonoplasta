#!/usr/bin/env bash
# Mostra o que há dentro de um arquivo de áudio ou vídeo (container, duração, trilhas de áudio e vídeo)
# e avisa sobre situações comuns antes de mixar, normalizar ou entregar.
# Uso: preflight.sh <arquivo> [saida_planejada]
#   saida_planejada (opcional): confere se é seguro gravar nesse caminho (diferente da entrada,
#   se já existe e se há espaço em disco).
# As linhas de aviso começam com "  ! ".
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_comum.sh
source "$DIR/_comum.sh"

[ $# -ge 1 ] && [ $# -le 2 ] || { echo "Uso: $(basename "$0") <arquivo> [saida_planejada]" >&2; exit 2; }
arquivo="$1"
saida="${2:-}"

checar_dependencias
[ -f "$arquivo" ] || { echo "Erro: arquivo não encontrado: $arquivo" >&2; exit 2; }

info="$(ffprobe -v error \
  -show_entries format=format_name,duration,bit_rate:stream=index,codec_type,codec_name,channels,sample_rate,sample_fmt,bits_per_sample,bits_per_raw_sample,bit_rate,width,height,avg_frame_rate:stream_disposition=attached_pic \
  -of flat "$arquivo" 2>&1 | tr -d '\r')" || { echo "Erro: o ffprobe não conseguiu ler o arquivo: $arquivo" >&2; exit 1; }

# Valor de uma chave do formato "flat" do ffprobe, sem aspas.
valor() { printf '%s\n' "$info" | awk -F= -v k="$1" '$1 == k { gsub(/"/, "", $2); print $2; exit }'; }

avisos=()
aviso() { avisos+=("$1"); }

formato="$(valor format.format_name)"
duracao="$(valor format.duration)"
echo "Arquivo: $arquivo"
printf '  Container: %s\n' "$formato"
printf '  Duração:   %s s\n' "$(awk -v d="$duracao" 'BEGIN { printf "%.2f", d }')"

n_audio=0
n_video=0
taxa_audio=""
canais_primeira=""
indices="$(printf '%s\n' "$info" | awk -F. '/^streams\.stream\.[0-9]+\.index=/ { print $3 }')"
for i in $indices; do
  p="streams.stream.$i"
  tipo="$(valor "$p.codec_type")"
  codec="$(valor "$p.codec_name")"
  if [ "$tipo" = "audio" ]; then
    n_audio=$((n_audio + 1))
    canais="$(valor "$p.channels")"
    taxa="$(valor "$p.sample_rate")"
    bits="$(valor "$p.bits_per_raw_sample")"
    [ -z "$bits" ] || [ "$bits" = "N/A" ] || [ "$bits" = "0" ] && bits="$(valor "$p.bits_per_sample")"
    case "$bits" in ""|0|N/A) bits="n/a (formato com perdas ou float: $(valor "$p.sample_fmt"))" ;; *) bits="$bits bits" ;; esac
    br="$(valor "$p.bit_rate")"
    case "$br" in ""|N/A) br="n/a" ;; *) br="$(awk -v b="$br" 'BEGIN { printf "%d kbps", b / 1000 }')" ;; esac
    printf '  Áudio %d: %s, %s canal(is), %s Hz, %s, %s\n' "$n_audio" "$codec" "$canais" "$taxa" "$bits" "$br"
    if [ "$n_audio" = 1 ]; then
      taxa_audio="$taxa"
      canais_primeira="$canais"
    fi
  elif [ "$tipo" = "video" ] && [ "$(valor "$p.disposition.attached_pic")" != "1" ]; then
    n_video=$((n_video + 1))
    fps="$(awk -v f="$(valor "$p.avg_frame_rate")" 'BEGIN { split(f, a, "/"); if (a[2] > 0) printf "%.3g", a[1] / a[2]; else print "?" }')"
    printf '  Vídeo %d: %s, %sx%s, %s fps\n' "$n_video" "$codec" "$(valor "$p.width")" "$(valor "$p.height")" "$fps"
  fi
done

# Avisos sobre o conteúdo.
if [ "$n_audio" = 0 ]; then
  aviso "Não há trilha de áudio no arquivo."
fi
if [ "$n_audio" -gt 1 ]; then
  aviso "Há $n_audio trilhas de áudio. Os scripts usam só a primeira; confira qual é a mix certa (e se as outras são idiomas, stems ou backup)."
fi
if [ "$n_video" -gt 0 ] && [ -n "$taxa_audio" ] && [ "$taxa_audio" != "48000" ]; then
  aviso "Áudio em $taxa_audio Hz num vídeo. O padrão para vídeo é 48 kHz: exporte a sessão em 48 kHz (ou converta uma única vez na entrega)."
fi
if [ "$canais_primeira" = "2" ]; then
  # Mede o pico de cada canal para achar mono gravado em estéreo com um canal vazio.
  picos="$(ffmpeg -hide_banner -nostats -i "$arquivo" -map 0:a:0 -af astats=measure_perchannel=Peak_level:measure_overall=none -f null - 2>&1 \
    | tr -d '\r' | awk '/Channel: [0-9]+/ { c = $NF } /Peak level dB:/ { print c, $NF }')"
  pico1="$(printf '%s\n' "$picos" | awk '$1 == 1 { print $2 }')"
  pico2="$(printf '%s\n' "$picos" | awk '$1 == 2 { print $2 }')"
  vazio() { [ "$1" = "-inf" ] || awk -v p="$1" 'BEGIN { exit !(p < -80) }'; }
  if vazio "$pico1" && ! vazio "$pico2"; then
    aviso "Canal esquerdo vazio (pico ${pico1} dB): parece mono gravado em estéreo. Use só o canal direito como mono (ffmpeg: -af \"pan=mono|c0=c1\")."
  elif vazio "$pico2" && ! vazio "$pico1"; then
    aviso "Canal direito vazio (pico ${pico2} dB): parece mono gravado em estéreo. Use só o canal esquerdo como mono (ffmpeg: -af \"pan=mono|c0=c0\")."
  fi
fi

# Avisos sobre a gravação planejada.
if [ -n "$saida" ]; then
  if [ "$saida" -ef "$arquivo" ] 2>/dev/null || [ "$saida" = "$arquivo" ]; then
    aviso "A saída planejada é o próprio arquivo de entrada: isso destruiria o original. Escolha outro nome."
  elif [ -e "$saida" ]; then
    aviso "A saída planejada já existe e seria sobrescrita: $saida"
  fi
  pasta="$(dirname "$saida")"
  if [ ! -d "$pasta" ]; then
    aviso "A pasta da saída não existe: $pasta"
  else
    tam_kb="$(du -k "$arquivo" | awk '{ print $1 }')"
    livre_kb="$(df -Pk "$pasta" 2>/dev/null | awk 'NR == 2 { print $4 }')"
    if [ -n "$livre_kb" ] && [ "$livre_kb" -lt $((tam_kb * 2)) ]; then
      aviso "Pouco espaço em disco: ${livre_kb} KB livres, cerca de $((tam_kb * 2)) KB necessários."
    fi
  fi
fi

echo
if [ ${#avisos[@]} -eq 0 ]; then
  echo "Nenhum aviso."
else
  echo "Avisos:"
  for a in "${avisos[@]}"; do echo "  ! $a"; done
fi
