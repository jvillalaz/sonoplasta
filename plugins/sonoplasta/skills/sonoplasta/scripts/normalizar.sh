#!/usr/bin/env bash
# Normaliza o loudness em duas passadas com o filtro loudnorm do ffmpeg (modo linear).
# Uso: normalizar.sh <arquivo> <alvo_LUFS> [true_peak] [saida]
#   alvo_LUFS  ex.: -14, -16, -23
#   true_peak  padrão -1 (dBTP)
#   saida      padrão <nome>_<alvo>LUFS.wav (áudio) ou <nome>_<alvo>LUFS.mov (vídeo)
# Formato de saída pela extensão: wav/mov/mkv = PCM 24 bits; aif/aiff; flac; mp4/m4a = AAC 320k; mp3 = 320k.
# Sempre em 48 kHz. Em vídeo, o vídeo é copiado sem recodificar.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_comum.sh
source "$DIR/_comum.sh"

uso() {
  echo "Uso: $(basename "$0") <arquivo> <alvo_LUFS> [true_peak=-1] [saida]" >&2
  echo "Ex.: $(basename "$0") voz.wav -16        $(basename "$0") video.mp4 -14 -1.5 video_final.mp4" >&2
  exit 2
}

[ $# -ge 2 ] && [ $# -le 4 ] || uso
entrada="$1"
alvo="$2"
tp="${3:--1}"

numero='^-?[0-9]+([.][0-9]+)?$'
[[ "$alvo" =~ $numero ]] || { echo "Erro: alvo inválido: $alvo (use, por exemplo, -14)" >&2; exit 2; }
[[ "$tp" =~ $numero ]] || { echo "Erro: true peak inválido: $tp (use, por exemplo, -1)" >&2; exit 2; }
if awk -v a="$alvo" 'BEGIN { exit !(a > 0) }'; then
  echo "Erro: o alvo de loudness deve ser negativo (ex.: -14), recebido: $alvo" >&2
  exit 2
fi
if awk -v a="$alvo" 'BEGIN { exit !(a < -70 || a > -5) }'; then
  echo "Erro: alvo fora da faixa aceita pelo loudnorm (-70 a -5 LUFS): $alvo" >&2
  exit 2
fi
if awk -v t="$tp" 'BEGIN { exit !(t < -9 || t > 0) }'; then
  echo "Erro: true peak fora da faixa aceita pelo loudnorm (-9 a 0 dBTP): $tp" >&2
  exit 2
fi

checar_dependencias
checar_arquivo_audio "$entrada"

base="${entrada%.*}"
if [ $# -ge 4 ]; then
  saida="$4"
elif tem_video "$entrada"; then
  saida="${base}_${alvo}LUFS.mov"
else
  saida="${base}_${alvo}LUFS.wav"
fi

if [ "$saida" -ef "$entrada" ] 2>/dev/null || [ "$saida" = "$entrada" ]; then
  echo "Erro: a saída não pode ser o próprio arquivo de entrada." >&2
  exit 2
fi
if ! codec="$(args_codec_saida "$saida")"; then
  echo "Erro: extensão de saída não suportada: $saida (use wav, aif, flac, mov, mkv, mp4, m4a ou mp3)" >&2
  exit 2
fi

[ -e "$saida" ] && echo "Aviso: $saida já existe e será sobrescrito."
echo "Normalizando para ${alvo} LUFS com true peak máximo de ${tp} dBTP (duas passadas)..."
# shellcheck disable=SC2086
resultado="$(loudnorm_duas_passadas "$entrada" "$saida" "$alvo" "$tp" $codec)"
read -r tipo in_i in_tp in_lra _ <<<"$resultado"

echo
echo "ANTES"
"$DIR/medir.sh" "$entrada" | sed 1d
echo "DEPOIS"
"$DIR/medir.sh" "$saida" | sed 1d
echo
echo "Arquivo gerado: $saida"

explicar_modo "$tipo" "$in_i" "$in_tp" "$in_lra" "$alvo" "$tp"
