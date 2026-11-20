#!/usr/bin/env bash
# Gera sinais de teste em scripts/testes/saida/ (pasta fora do git e do ZIP).
# Uso: gerar-sinais.sh
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../_comum.sh
source "$DIR/../_comum.sh"
checar_dependencias

SAIDA="$DIR/saida"
mkdir -p "$SAIDA"
cd "$SAIDA"

gerar() {
  local nome="$1"
  shift
  ffmpeg -hide_banner -loglevel error -y "$@" "$nome"
  echo "  $nome"
}

echo "Gerando sinais em $SAIDA"
gerar tom.wav             -f lavfi -i "sine=frequency=1000:duration=10"
gerar ruido.wav           -f lavfi -i "anoisesrc=color=pink:duration=10"
gerar fora-de-fase.wav    -f lavfi -i "aevalsrc=sin(2*PI*440*t)|-sin(2*PI*440*t):d=10"
gerar estereo-igual.wav   -f lavfi -i "aevalsrc=sin(2*PI*440*t)|sin(2*PI*440*t):d=10"
gerar video-teste.mp4     -f lavfi -i "testsrc=duration=10:size=640x360:rate=30" \
                          -f lavfi -i "anoisesrc=color=pink:duration=10:amplitude=0.2" \
                          -shortest -c:v libx264 -pix_fmt yuv420p -c:a aac
