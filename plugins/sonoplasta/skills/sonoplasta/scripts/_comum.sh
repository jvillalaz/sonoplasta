#!/usr/bin/env bash
# Funções compartilhadas pelos scripts da skill sonoplasta.
# Não execute direto: os outros scripts carregam este arquivo com "source".

# Sai com erro claro se faltar ffmpeg, ffprobe ou awk.
checar_dependencias() {
  if ! command -v ffmpeg >/dev/null 2>&1 || ! command -v ffprobe >/dev/null 2>&1; then
    cat >&2 <<'EOF'
Erro: ffmpeg (com ffprobe) não foi encontrado no PATH.
Instale e rode de novo:
  Debian/Ubuntu:    sudo apt install ffmpeg
  macOS (Homebrew): brew install ffmpeg
  Windows (winget): winget install --id Gyan.FFmpeg
Depois de instalar, abra um terminal novo e confira com: ffmpeg -version
EOF
    exit 127
  fi
  if ! command -v awk >/dev/null 2>&1; then
    echo "Erro: awk não foi encontrado. Instale o pacote gawk ou mawk." >&2
    exit 127
  fi
}

# Confere se o arquivo existe e tem pelo menos uma trilha de áudio.
checar_arquivo_audio() {
  if [ ! -f "$1" ]; then
    echo "Erro: arquivo não encontrado: $1" >&2
    exit 2
  fi
  if [ -z "$(ffprobe -v error -select_streams a:0 -show_entries stream=index -of csv=p=0 "$1" | tr -d '\r')" ]; then
    echo "Erro: o arquivo não tem trilha de áudio: $1" >&2
    exit 2
  fi
}

# Número de canais da primeira trilha de áudio.
canais_audio() {
  ffprobe -v error -select_streams a:0 -show_entries stream=channels -of csv=p=0 "$1" | tr -d '\r' | head -n 1
}

# Verdadeiro se o arquivo tem vídeo de verdade (capa de álbum não conta).
tem_video() {
  ffprobe -v error -select_streams v -show_entries stream_disposition=attached_pic -of csv=p=0 "$1" \
    | tr -d '\r' | grep -q '^0'
}

# Mede com o filtro ebur128 e imprime "I LRA TP" (LUFS, LU, dBTP).
# Lê só o bloco final "Summary:", porque o filtro imprime uma linha por quadro antes dele.
# Uso: medir_ebur128 <arquivo> [cadeia de filtros terminando em ebur128]
medir_ebur128() {
  local arq="$1" cadeia="${2:-ebur128=peak=true}"
  ffmpeg -hide_banner -nostats -i "$arq" -filter_complex "[0:a:0]${cadeia}[m]" -map "[m]" -f null - 2>&1 \
    | tr -d '\r' \
    | awk '/Summary:/        { s = 1; next }
           s && $1 == "I:"    { i = $2 }
           s && $1 == "LRA:"  { lra = $2 }
           s && $1 == "Peak:" { tp = $2 }
           END { if (i == "") exit 1; print i, lra, tp }'
}

# Lê um campo do JSON impresso pelo loudnorm (entrada em stdin).
campo_json() {
  awk -F'"' -v k="$1" '$2 == k { print $4; exit }'
}

# Conta de ponto flutuante com awk. Uso: calc "<expressão>"
calc() {
  awk "BEGIN { printf \"%.1f\", $1 }"
}

# Argumentos de codec para o formato de saída, a partir da extensão.
args_codec_saida() {
  local ext
  ext="$(printf '%s' "${1##*.}" | tr '[:upper:]' '[:lower:]')"
  case "$ext" in
    wav|mov|mkv) echo "-c:a pcm_s24le" ;;
    aif|aiff)    echo "-c:a pcm_s24be" ;;
    flac)        echo "-c:a flac -sample_fmt s32 -bits_per_raw_sample 24" ;;
    mp4|m4a|m4v) echo "-c:a aac -b:a 320k" ;;
    mp3)         echo "-c:a libmp3lame -b:a 320k" ;;
    *) return 1 ;;
  esac
}

# Normalização em duas passadas com loudnorm (modo linear).
# Uso: loudnorm_duas_passadas <entrada> <saida> <alvo_LUFS> <true_peak> [args de codec...]
# Em vídeo, copia o vídeo e processa só o áudio. Saída em 48 kHz.
# Imprime em stdout: "<tipo> <I medido> <TP medido> <LRA medido> <LRA alvo>",
# onde tipo é "linear" ou "dynamic" (o loudnorm volta ao modo dinâmico quando o ganho
# linear passaria do true peak, quando o LRA medido é maior que o alvo ou quando o LRA é 0).
loudnorm_duas_passadas() {
  local entrada="$1" saida="$2" alvo="$3" tp="$4"
  shift 4
  local medida in_i in_tp in_lra in_th offset lra_alvo resultado tipo

  # Passada 1: medir.
  medida="$(ffmpeg -hide_banner -nostats -i "$entrada" -map 0:a:0 \
    -af "loudnorm=I=${alvo}:TP=${tp}:LRA=7:print_format=json" -f null - 2>&1 | tr -d '\r')"
  in_i="$(printf '%s\n' "$medida" | campo_json input_i)"
  in_tp="$(printf '%s\n' "$medida" | campo_json input_tp)"
  in_lra="$(printf '%s\n' "$medida" | campo_json input_lra)"
  in_th="$(printf '%s\n' "$medida" | campo_json input_thresh)"
  offset="$(printf '%s\n' "$medida" | campo_json target_offset)"
  if [ -z "$in_i" ] || [ "$in_i" = "-inf" ]; then
    echo "Erro: não foi possível medir o áudio (arquivo em silêncio ou ilegível)." >&2
    return 1
  fi

  # O loudnorm só aceita measured_I até 0 LUFS. Em sinais muito quentes, baixa 10 dB antes
  # e desloca as medidas na mesma quantidade (ganho linear muda tudo igual).
  local pre=""
  if awk -v i="$in_i" 'BEGIN { exit !(i > -1) }'; then
    pre="volume=-10dB,"
    in_i="$(calc "$in_i - 10")"
    in_tp="$(calc "$in_tp - 10")"
    in_th="$(calc "$in_th - 10")"
  fi

  # O modo linear só vale se o LRA alvo for maior ou igual ao LRA medido.
  lra_alvo="$(awk -v l="$in_lra" 'BEGIN { x = l + 1; if (x < 7) x = 7; if (x > 50) x = 50; printf "%.1f", x }')"

  # Passada 2: aplicar.
  local filtro="${pre}loudnorm=I=${alvo}:TP=${tp}:LRA=${lra_alvo}:measured_I=${in_i}:measured_TP=${in_tp}:measured_LRA=${in_lra}:measured_thresh=${in_th}:offset=${offset}:linear=true:print_format=json"
  local mapa=(-map 0:a:0) ext_saida
  ext_saida="$(printf '%s' "${saida##*.}" | tr '[:upper:]' '[:lower:]')"
  if tem_video "$entrada" && [[ ! "$ext_saida" =~ ^(wav|aif|aiff|flac|mp3|m4a)$ ]]; then
    mapa=(-map 0:v:0 -map 0:a:0 -c:v copy)
  fi
  resultado="$(ffmpeg -hide_banner -nostats -y -i "$entrada" "${mapa[@]}" -af "$filtro" -ar 48000 "$@" "$saida" 2>&1 | tr -d '\r')" || {
    printf '%s\n' "$resultado" | tail -n 5 >&2
    echo "Erro: o ffmpeg falhou ao gravar $saida" >&2
    return 1
  }
  tipo="$(printf '%s\n' "$resultado" | campo_json normalization_type)"
  echo "${tipo:-desconhecido} $in_i $in_tp $in_lra $lra_alvo"
}

# Explica o modo que o loudnorm usou, a partir da saída de loudnorm_duas_passadas.
# Uso: explicar_modo <tipo> <I medido> <TP medido> <LRA medido> <alvo> <true_peak>
explicar_modo() {
  local tipo="$1" in_i="$2" in_tp="$3" in_lra="$4" alvo="$5" tp="$6" pico_previsto
  if [ "$tipo" = "linear" ]; then
    echo "Modo linear: só ganho, sem alterar a dinâmica."
    return
  fi
  [ "$tipo" = "dynamic" ] || return 0
  pico_previsto="$(calc "$in_tp + ($alvo) - ($in_i)")"
  if awk -v p="$pico_previsto" -v t="$tp" 'BEGIN { exit !(p > t) }'; then
    cat <<MSG
Atenção: o loudnorm usou o modo dinâmico (compressão e limitação automáticas), porque só com ganho
o true peak chegaria a ${pico_previsto} dBTP, acima do máximo de ${tp} dBTP. Para manter o som intacto:
  - controle os picos antes (limiter ou clipper suave na mix, teto de ${tp} dBTP) e rode de novo, ou
  - aceite um alvo mais baixo. Ouça o resultado antes de entregar.
MSG
  elif awk -v l="$in_lra" 'BEGIN { exit !(l < 0.05) }'; then
    echo "Modo dinâmico: o sinal não varia de loudness (LRA 0, típico de tons e sinais de teste)."
    echo "Nesse caso o resultado equivale a um ganho fixo."
  else
    echo "Atenção: o loudnorm usou o modo dinâmico (LRA medido: ${in_lra} LU). Ouça o resultado antes de entregar."
  fi
}
