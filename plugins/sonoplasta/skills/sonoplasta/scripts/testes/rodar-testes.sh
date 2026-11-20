#!/usr/bin/env bash
# Gera os sinais de teste e confere o comportamento de todos os scripts.
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

# Confere se a saída de um comando contém um texto esperado.
espera() {
  local descricao="$1" texto="$2" saida="$3"
  [[ "$saida" == *"$texto"* ]] && ok "$descricao" || falha "$descricao (esperado: \"$texto\")"
}
nao_espera() {
  local descricao="$1" texto="$2" saida="$3"
  [[ "$saida" != *"$texto"* ]] && ok "$descricao" || falha "$descricao (não esperado: \"$texto\")"
}

echo
echo "preflight.sh"
espera "video-44k.mp4 avisa sobre 44,1 kHz em vídeo" "Áudio em 44100 Hz num vídeo" "$("$SCRIPTS/preflight.sh" "$SAIDA/video-44k.mp4")"
espera "canal-vazio.wav avisa sobre mono gravado em estéreo" "Canal esquerdo vazio" "$("$SCRIPTS/preflight.sh" "$SAIDA/canal-vazio.wav")"
espera "ruido.wav sem avisos" "Nenhum aviso." "$("$SCRIPTS/preflight.sh" "$SAIDA/ruido.wav")"
espera "saída igual à entrada é bloqueada" "destruiria o original" "$("$SCRIPTS/preflight.sh" "$SAIDA/tom.wav" "$SAIDA/tom.wav")"

echo
echo "diagnosticar.sh"
espera "clipado.wav detecta clipping" "Clipping detectado" "$("$SCRIPTS/diagnosticar.sh" "$SAIDA/clipado.wav")"
nao_espera "ruido.wav sem clipping" "Clipping detectado" "$("$SCRIPTS/diagnosticar.sh" "$SAIDA/ruido.wav")"
diag_sil="$("$SCRIPTS/diagnosticar.sh" "$SAIDA/com-silencio.wav")"
espera "com-silencio.wav lista o silêncio com início e fim" "de 3.00 s a 6.00 s" "$diag_sil"
espera "fora-de-fase.wav aponta problema na soma mono" "Problema de fase" "$("$SCRIPTS/diagnosticar.sh" "$SAIDA/fora-de-fase.wav")"
espera "alvo fora de ±1 LU é apontado" "fora do alvo de -16 LUFS" "$("$SCRIPTS/diagnosticar.sh" "$SAIDA/com-silencio.wav" --alvo -16)"

echo
echo "limpar-fala"
LF="$SCRIPTS/limpar-fala"
# Python que funcione de verdade (no Windows, "python3" pode ser só o atalho da Microsoft Store).
PY=""
if python3 -c 'import sys' >/dev/null 2>&1; then PY="python3"; elif py -3 -c 'import sys' >/dev/null 2>&1; then PY="py -3"; fi
if [ -n "$PY" ]; then
  rel="$($PY "$LF/marcar-cortes.py" "$DIR/transcricao-exemplo.json" --saida "$SAIDA/marcados.cortes.json")"
  espera "marcar-cortes propõe 5 cortes" "Total: 5 corte(s)" "$rel"
  espera "silêncio no início marcado" "silêncio no início" "$rel"
  espera "vício \"ãh\" marcado" 'vício: "ãh"' "$rel"
  espera "\"então\" isolado marcado" 'vício: "então"' "$rel"
  espera "repetição acidental \"o o\" marcada" 'repetição: "o"' "$rel"
  nao_espera "repetição enfática \"muito, muito\" mantida" 'repetição: "muito"' "$rel"
  nao_espera "\"tipo\" dentro da frase mantido" 'vício: "tipo"' "$rel"
  nao_espera "\"é\" verbo mantido" 'vício: "é"' "$rel"
else
  echo "  (pulado: Python 3 não encontrado; marcar-cortes.py não foi testado)"
fi

rm -f "$SAIDA/fala-video_limpo.mp4"
sem_aprovacao="$("$LF/aplicar-cortes.sh" "$SAIDA/fala-video.mp4" "$DIR/cortes-exemplo.json" 2>&1)"; cod=$?
[ "$cod" = 3 ] && [ ! -e "$SAIDA/fala-video_limpo.mp4" ] && ok "sem --aprovado nada é gravado" || falha "sem --aprovado: código $cod"
saida_cortes="$("$LF/aplicar-cortes.sh" "$SAIDA/fala-video.mp4" "$DIR/cortes-exemplo.json" --aprovado 2>&1)"
espera "vídeo cortado com imagem e som sincronizados" "(ok)." "$saida_cortes"
dur="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$SAIDA/fala-video_limpo.mp4" | tr -d '')"
awk -v d="$dur" 'BEGIN { exit !(d > 5.22 && d < 5.32) }' && ok "duração final $dur s (esperado ~5,27 s)" || falha "duração final $dur s (esperado ~5,27 s)"
sed 's/"id": 5, "aplicar": true/"id": 5, "aplicar": false/' "$DIR/cortes-exemplo.json" > "$SAIDA/cortes-sem-5.json"
"$LF/aplicar-cortes.sh" "$SAIDA/fala-tom.wav" "$SAIDA/cortes-sem-5.json" --aprovado --saida "$SAIDA/fala-tom_limpo.wav" >/dev/null 2>&1
dur="$(ffprobe -v error -show_entries format=duration -of csv=p=0 "$SAIDA/fala-tom_limpo.wav" | tr -d '')"
awk -v d="$dur" 'BEGIN { exit !(d > 6.68 && d < 6.76) }' && ok "corte com \"aplicar\": false ignorado ($dur s)" || falha "\"aplicar\": false: duração $dur s (esperado ~6,73 s)"
# Estalo nas emendas aparece como energia acima de 3 kHz num seno de 440 Hz.
pico_agudo="$(ffmpeg -hide_banner -nostats -i "$SAIDA/fala-tom_limpo.wav" -af highpass=f=3000:poles=2,highpass=f=3000:poles=2,astats=measure_overall=Peak_level:measure_perchannel=none -f null - 2>&1 | tr -d '' | awk '/Peak level dB:/ { print $NF }')"
awk -v p="$pico_agudo" 'BEGIN { exit !(p < -60) }' && ok "emendas sem estalo (pico acima de 3 kHz: $pico_agudo dB)" || falha "estalo nas emendas (pico acima de 3 kHz: $pico_agudo dB)"

echo
if [ "$falhas" -eq 0 ]; then
  echo "Todos os testes passaram."
else
  echo "$falhas teste(s) falharam."
  exit 1
fi
