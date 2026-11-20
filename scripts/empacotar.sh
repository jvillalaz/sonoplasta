#!/usr/bin/env bash
# Gera dist/sonoplasta.zip para enviar no claude.ai (Customize > Skills > Upload a skill).
set -euo pipefail

raiz="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$raiz/dist"
rm -f "$raiz/dist/sonoplasta.zip"
cd "$raiz/plugins/sonoplasta/skills"
zip -qr "$raiz/dist/sonoplasta.zip" sonoplasta -x "sonoplasta/scripts/testes/saida/*"
echo "Gerado: dist/sonoplasta.zip"
