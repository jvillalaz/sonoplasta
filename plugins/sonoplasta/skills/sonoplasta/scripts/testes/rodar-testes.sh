#!/usr/bin/env bash
# Gera os sinais de teste e confere o comportamento de medir.sh, normalizar.sh e checar-mono.sh.
# Uso: rodar-testes.sh
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS="$DIR/.."
SAIDA="$DIR/saida"

falhas=0
ok()    { echo "  ok    $1"; }
falha() { echo "  FALHA $1"; falhas=$((falhas + 1)); }

"$DIR/gerar-sinais.sh" || { echo "Não foi possível gerar os sinais de teste."; exit 1; }

echo
echo "medir.sh"
for f in tom.wav ruido.wav fora-de-fase.wav; do
  if json="$("$SCRIPTS/medir.sh" --json "$SAIDA/$f")" && [[ "$json" == *'"integrado_lufs": -'* ]]; then
    ok "$f: $json"
  else
    falha "$f: $json"
  fi
done

# Confere I dentro de ±0,5 LU do alvo e true peak sem passar do máximo.
conferir_normalizacao() {
  local arq="$1" alvo="$2" tp_max="$3" json i tp
  json="$("$SCRIPTS/medir.sh" --json "$arq")" || { falha "$arq: não foi possível medir"; return; }
  i="$(printf '%s' "$json" | sed 's/.*"integrado_lufs": \([^,]*\),.*/\1/')"
  tp="$(printf '%s' "$json" | sed 's/.*"true_peak_dbtp": \([^,]*\),.*/\1/')"
  if awk -v i="$i" -v a="$alvo" -v tp="$tp" -v m="$tp_max" \
       'BEGIN { d = i - a; if (d < 0) d = -d; exit !(d <= 0.5 && tp <= m) }'; then
    ok "$(basename "$arq"): I = $i LUFS (alvo $alvo), true peak = $tp dBTP (máx. $tp_max)"
  else
    falha "$(basename "$arq"): I = $i LUFS (alvo $alvo), true peak = $tp dBTP (máx. $tp_max)"
  fi
}

echo
echo "normalizar.sh"
"$SCRIPTS/normalizar.sh" "$SAIDA/ruido.wav" -14 >/dev/null
conferir_normalizacao "$SAIDA/ruido_-14LUFS.wav" -14 -1
"$SCRIPTS/normalizar.sh" "$SAIDA/video-teste.mp4" -16 -1.5 "$SAIDA/video-teste_final.mp4" >/dev/null
conferir_normalizacao "$SAIDA/video-teste_final.mp4" -16 -1.5
codec_video="$(ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of csv=p=0 "$SAIDA/video-teste_final.mp4" | tr -d '\r')"
[ "$codec_video" = "h264" ] && ok "vídeo copiado sem recodificar ($codec_video)" || falha "vídeo de saída: '$codec_video'"

echo
echo "checar-mono.sh"
saida_fase="$("$SCRIPTS/checar-mono.sh" "$SAIDA/fora-de-fase.wav")"
[[ "$saida_fase" == *ALERTA* ]] && ok "fora-de-fase.wav gera ALERTA" || falha "fora-de-fase.wav sem ALERTA"
saida_igual="$("$SCRIPTS/checar-mono.sh" "$SAIDA/estereo-igual.wav")"
[[ "$saida_igual" == *"OK:"* ]] && ok "estereo-igual.wav sem alerta" || falha "estereo-igual.wav: $saida_igual"
saida_tom="$("$SCRIPTS/checar-mono.sh" "$SAIDA/tom.wav")"
[[ "$saida_tom" == *"já é mono"* ]] && ok "tom.wav reconhecido como mono" || falha "tom.wav: $saida_tom"

echo
echo "preparar-reels.sh"
"$SCRIPTS/preparar-reels.sh" "$SAIDA/teste-reels.mp4" >/dev/null
conferir_normalizacao "$SAIDA/teste-reels_reels.mp4" -14 -1.5
streams="$(ffprobe -v error -show_entries stream=codec_name,sample_rate -of csv=p=0 "$SAIDA/teste-reels_reels.mp4" | tr -d '\r' | tr '\n' ' ')"
[[ "$streams" == *h264*"aac,48000"* ]] && ok "teste-reels_reels.mp4: vídeo copiado e AAC 48 kHz ($streams)" || falha "streams: $streams"

echo
if [ "$falhas" -eq 0 ]; then
  echo "Todos os testes passaram."
else
  echo "$falhas teste(s) falharam."
  exit 1
fi
