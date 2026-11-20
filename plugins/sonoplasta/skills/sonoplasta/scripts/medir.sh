#!/usr/bin/env bash
# Mede loudness integrado (I), loudness range (LRA), true peak e PLR de um arquivo de áudio ou vídeo.
# Uso: medir.sh [--json] <arquivo>
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=_comum.sh
source "$DIR/_comum.sh"

uso() {
  echo "Uso: $(basename "$0") [--json] <arquivo>" >&2
  echo "Mede loudness integrado (LUFS), LRA (LU), true peak (dBTP) e PLR (dB) da primeira trilha de áudio." >&2
  exit 2
}

json=0
arquivo=""
for arg in "$@"; do
  case "$arg" in
    --json) json=1 ;;
    -h|--help) uso ;;
    *) [ -z "$arquivo" ] && arquivo="$arg" || uso ;;
  esac
done
[ -n "$arquivo" ] || uso

checar_dependencias
checar_arquivo_audio "$arquivo"

if ! medida="$(medir_ebur128 "$arquivo")"; then
  echo "Erro: o ffmpeg não conseguiu medir o arquivo: $arquivo" >&2
  exit 1
fi
read -r i lra tp <<<"$medida"

if [ "$tp" = "-inf" ] || [ "$i" = "-70.0" ]; then
  plr=""
else
  plr="$(calc "$tp - ($i)")"
fi

if [ "$json" = 1 ]; then
  nome_json="$(printf '%s' "$arquivo" | sed 's/\\/\\\\/g; s/"/\\"/g')"
  num() { case "$1" in ""|-inf|inf|nan) echo null ;; *) echo "$1" ;; esac; }
  printf '{"arquivo": "%s", "integrado_lufs": %s, "lra_lu": %s, "true_peak_dbtp": %s, "plr_db": %s}\n' \
    "$nome_json" "$(num "$i")" "$(num "$lra")" "$(num "$tp")" "$(num "$plr")"
else
  echo "Arquivo: $arquivo"
  printf '  Loudness integrado (I): %s LUFS\n' "$i"
  printf '  Loudness range (LRA):   %s LU\n' "$lra"
  printf '  True peak:              %s dBTP\n' "$tp"
  if [ -n "$plr" ]; then
    printf '  PLR (true peak - I):    %s dB\n' "$plr"
  else
    printf '  PLR (true peak - I):    indefinido (silêncio)\n'
  fi
fi
