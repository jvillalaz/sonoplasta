#!/usr/bin/env bash
# Compara o loudness da mix em estéreo com a soma mono (L+R)/2 para achar problemas de fase
# ou largura estéreo exagerada.
# Uso: checar-mono.sh <arquivo>
#
# A soma mono é medida como "dual mono" (como se tocasse igual nos dois alto-falantes).
# Assim, um sinal idêntico nos dois canais não perde nada (0 dB), um sinal sem nenhuma
# correlação entre os canais perde cerca de 3 dB e um sinal com um canal invertido some.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_comum.sh
source "$DIR/_comum.sh"

[ $# -eq 1 ] || { echo "Uso: $(basename "$0") <arquivo>" >&2; exit 2; }
arquivo="$1"

checar_dependencias
checar_arquivo_audio "$arquivo"

canais="$(canais_audio "$arquivo")"
if [ "$canais" = "1" ]; then
  echo "O arquivo já é mono: não há soma estéreo para checar."
  exit 0
fi
if [ "$canais" -gt 2 ] 2>/dev/null; then
  echo "Aviso: o arquivo tem $canais canais. A checagem usa só os dois primeiros (normalmente L e R)."
fi

read -r i_est _ _ <<<"$(medir_ebur128 "$arquivo" "pan=stereo|c0=c0|c1=c1,ebur128=peak=true")"
read -r i_mono _ _ <<<"$(medir_ebur128 "$arquivo" "pan=mono|c0=0.5*c0+0.5*c1,ebur128=peak=true:dualmono=true")"

perda="$(calc "$i_est - ($i_mono)")"

echo "Arquivo: $arquivo"
printf '  Loudness em estéreo:       %s LUFS\n' "$i_est"
printf '  Loudness na soma mono:     %s LUFS\n' "$i_mono"
printf '  Perda na soma mono:        %s dB\n' "$perda"
echo

if [ "$i_mono" = "-70.0" ]; then
  echo "ALERTA: o sinal praticamente desaparece em mono. Um canal está com a polaridade invertida"
  echo "ou os canais estão em oposição de fase. Confira a polaridade das fontes e dos plugins de estéreo."
elif awk -v p="$perda" 'BEGIN { exit !(p > 3) }'; then
  echo "ALERTA: perda acima de 3 dB na soma mono. Possível problema de fase entre microfones,"
  echo "polaridade invertida em alguma fonte ou alargamento estéreo exagerado (wideners, Haas, chorus)."
  echo "Ouça em mono e procure o que some ou fica oco: bumbo, baixo, voz principal."
elif awk -v p="$perda" 'BEGIN { exit !(p > 1.5) }'; then
  echo "Atenção: estéreo bem largo. Confira em mono se voz, bumbo, baixo e caixa continuam firmes."
else
  echo "OK: boa compatibilidade mono."
fi
