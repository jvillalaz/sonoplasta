#!/usr/bin/env bash
# Prepara um vídeo para Reels, TikTok ou Shorts: checa a compatibilidade mono, normaliza o loudness
# em duas passadas (mesma lógica do normalizar.sh) e exporta com o vídeo copiado e o áudio em AAC 48 kHz.
# Uso: preparar-reels.sh <video> [alvo_LUFS=-14] [true_peak=-1.5]
# Saída: <nome>_reels.mp4 (ou .mov, se o codec de vídeo não couber em MP4).
# Alvo e true peak padrão são prática comum, não especificação oficial da Meta.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_comum.sh
source "$DIR/_comum.sh"

uso() {
  echo "Uso: $(basename "$0") <video> [alvo_LUFS=-14] [true_peak=-1.5]" >&2
  exit 2
}

[ $# -ge 1 ] && [ $# -le 3 ] || uso
entrada="$1"
alvo="${2:--14}"
tp="${3:--1.5}"

numero='^-[0-9]+([.][0-9]+)?$'
[[ "$alvo" =~ $numero ]] || { echo "Erro: alvo inválido: $alvo (use, por exemplo, -14)" >&2; exit 2; }
[[ "$tp" =~ $numero ]] || { echo "Erro: true peak inválido: $tp (use, por exemplo, -1.5)" >&2; exit 2; }

checar_dependencias
checar_arquivo_audio "$entrada"
if ! tem_video "$entrada"; then
  echo "Erro: o arquivo não tem vídeo. Para áudio, use normalizar.sh." >&2
  exit 2
fi

codec_video="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$entrada" | tr -d '\r')"
case "$codec_video" in
  h264|hevc|av1|mpeg4) saida="${entrada%.*}_reels.mp4" ;;
  *)
    saida="${entrada%.*}_reels.mov"
    echo "Aviso: o vídeo está em $codec_video, que não cabe bem em MP4. A saída será .mov com o vídeo copiado."
    echo "Se o Instagram recusar, exporte o vídeo em H.264 no editor e rode de novo."
    ;;
esac

echo "== Compatibilidade mono"
"$DIR/checar-mono.sh" "$entrada" | grep -v '^Arquivo:'
echo

echo "== Normalizando para ${alvo} LUFS, true peak máximo ${tp} dBTP, AAC 48 kHz"
# A codificação AAC pode criar picos acima do que saiu do loudnorm. Se isso acontecer,
# refaz com um teto mais baixo (até duas vezes) para respeitar o true peak pedido.
tp_interno="$tp"
for tentativa in 1 2 3; do
  resultado="$(loudnorm_duas_passadas "$entrada" "$saida" "$alvo" "$tp_interno" \
    -c:a aac -b:a 320k -movflags +faststart)"
  read -r tipo in_i in_tp in_lra _ <<<"$resultado"
  read -r i_out _ tp_out <<<"$(medir_ebur128 "$saida")"
  excesso="$(calc "$tp_out - ($tp)")"
  if awk -v e="$excesso" 'BEGIN { exit !(e <= 0) }' || [ "$tentativa" = 3 ]; then
    break
  fi
  tp_interno="$(calc "$tp_interno - $excesso - 0.2")"
  echo "  A codificação AAC passou do true peak em ${excesso} dB. Refazendo com teto interno de ${tp_interno} dBTP..."
done

echo
echo "ANTES"
"$DIR/medir.sh" "$entrada" | sed 1d
echo "DEPOIS"
"$DIR/medir.sh" "$saida" | sed 1d
echo
echo "Arquivo gerado: $saida"

if awk -v e="$excesso" 'BEGIN { exit !(e > 0) }'; then
  echo "Atenção: o true peak final (${tp_out} dBTP) ficou acima de ${tp} dBTP. Controle os picos na mix e rode de novo."
fi
explicar_modo "$tipo" "$in_i" "$in_tp" "$in_lra" "$alvo" "$tp_interno"
echo "Antes de publicar: ouça no celular, confira a legenda e os direitos da música."
