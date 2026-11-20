# Codecs e formatos de arquivo

Leia este arquivo antes de recomendar formato, codec ou bitrate de exportação, explicar perda de qualidade na conversão ou montar um comando ffmpeg de conversão. Para alvos de loudness e especificações por destino, veja `referencias/entregas.md`.

## Regra geral

- **Master e arquivos de trabalho:** sempre sem perdas (WAV, AIFF ou FLAC) em 24 bits. Converta para um formato com perdas só na entrega e uma única vez, a partir do master.
- **Nunca recodifique de um formato com perdas para outro** (MP3 → AAC, AAC → AAC). Cada geração soma artefatos. Se só tiver o MP3, avise que a qualidade já está limitada.
- **Plataformas recodificam:** YouTube, Instagram, TikTok e WhatsApp recodificam o que você envia. Envie em alta qualidade para chegar menos degradado, e deixe folga de true peak (−1 a −2 dBTP), porque a codificação cria picos acima do original.
- **Taxa de amostragem:** 48 kHz para tudo que acompanha vídeo; 44,1 kHz é aceito para música e podcast só de áudio. Não converta à toa entre as duas.

## Codecs

| Codec | Tipo | Encoder no ffmpeg | Onde é usado | Observações |
|---|---|---|---|---|
| WAV (PCM) | Sem perdas, sem compressão | `pcm_s24le` (24 bits), `pcm_s16le` (16 bits) | Masters, stems, entrega para TV e para editores | Padrão de trabalho. Acima de 4 GB, use RF64 (`-rf64 auto`). |
| AIFF | Sem perdas, sem compressão | `pcm_s24be` | Masters em fluxos Apple | Equivalente ao WAV. |
| FLAC | Sem perdas, comprimido (~50 a 60% do WAV) | `flac` | Arquivamento, distribuição em alta resolução, troca de arquivos | Mesmo áudio do WAV, em arquivo menor. |
| AAC | Com perdas | `aac` (nativo); `libfdk_aac` se o ffmpeg tiver | Vídeo (MP4), Instagram, TikTok, YouTube (upload), Apple, podcasts em M4A | Melhor que MP3 na mesma taxa. É o padrão do áudio em vídeo. |
| MP3 | Com perdas | `libmp3lame` | Podcasts (feed RSS), compatibilidade geral | Compatível com tudo. Precisa de taxa maior que AAC e Opus para a mesma qualidade. |
| Opus | Com perdas | `libopus` | Chamadas, WebM, YouTube (reprodução), mensagens de voz do WhatsApp | O mais eficiente em taxas baixas, principalmente para fala. Trabalha em 48 kHz. |

## Taxas recomendadas por uso

| Uso | AAC | MP3 | Opus |
|---|---|---|---|
| Fala (podcast, voz, aula) | 64 a 96 kbps mono; 96 a 128 kbps estéreo | 96 a 128 kbps (mono 64 a 96) | 32 a 64 kbps |
| Música, qualidade padrão | 128 a 192 kbps | 192 a 256 kbps | 96 a 128 kbps |
| Música, alta qualidade | 256 a 320 kbps | 320 kbps | 160 a 256 kbps |
| Upload para plataforma de vídeo | 256 a 384 kbps estéreo | (não use) | (não use) |

Para o YouTube, a recomendação oficial de upload é AAC-LC, 48 kHz e 384 kbps em estéreo (ver `referencias/entregas.md`). Para Reels e TikTok, 256 a 320 kbps em AAC 48 kHz é prática comum.

## Por destino

| Destino | Formato de envio | Observações |
|---|---|---|
| YouTube | MP4 com AAC-LC 48 kHz, 384 kbps estéreo | Oficial (configurações de upload do YouTube). O YouTube recodifica (AAC e Opus) para reprodução. |
| Instagram, Reels, TikTok, Shorts | MP4 (H.264) com AAC 48 kHz, 256 a 320 kbps | Prática comum. A plataforma recodifica em taxa menor. Use `scripts/preparar-reels.sh`. |
| Podcast (feed) | MP3 128 kbps estéreo ou 64 a 96 kbps mono, 44,1 kHz; ou AAC em M4A | Prática comum. Siga os requisitos do host ou agregador. Master em WAV. |
| WhatsApp | Vídeo em MP4 com AAC; áudio como MP3 ou M4A (AAC) | O app recomprime vídeos e áudios para economizar dados (mensagens de voz em Opus). A qualidade final é baixa: priorize clareza da voz e folga de pico. Para enviar sem recompressão, mande como documento. |
| Spotify e Apple Music (via distribuidora) | WAV ou FLAC, 16 ou 24 bits, 44,1 kHz ou mais | A plataforma faz a conversão. Apple Digital Masters pede 24 bits. |
| TV e agência | WAV 48 kHz 24 bits, ou embutido no vídeo de entrega | Siga o manual técnico da emissora. |

## Comandos ffmpeg

Troque `entrada` e `saida` pelos arquivos reais. No Windows, use aspas nos caminhos com espaço e prefira barras normais (`C:/Pasta/arquivo.wav`).

```bash
# WAV 48 kHz 24 bits (master ou entrega)
ffmpeg -i entrada -ar 48000 -c:a pcm_s24le saida.wav

# FLAC 24 bits (arquivamento)
ffmpeg -i entrada.wav -c:a flac -sample_fmt s32 -bits_per_raw_sample 24 saida.flac

# AAC 256 kbps 48 kHz (áudio para vídeo ou M4A)
ffmpeg -i entrada.wav -ar 48000 -c:a aac -b:a 256k saida.m4a

# MP3 para podcast: 128 kbps estéreo, ou 96 kbps mono
ffmpeg -i entrada.wav -ar 44100 -c:a libmp3lame -b:a 128k saida.mp3
ffmpeg -i entrada.wav -ar 44100 -ac 1 -c:a libmp3lame -b:a 96k saida_mono.mp3

# Opus para fala (48 kbps)
ffmpeg -i entrada.wav -c:a libopus -b:a 48k -application voip saida.opus

# Trocar só o áudio de um vídeo, sem recodificar a imagem
ffmpeg -i video.mp4 -i audio_final.wav -map 0:v:0 -map 1:a:0 -c:v copy -c:a aac -b:a 320k -ar 48000 -shortest video_final.mp4

# Extrair o áudio de um vídeo sem recodificar (mantém o codec original)
ffmpeg -i video.mp4 -vn -c:a copy audio.m4a

# Extrair o áudio de um vídeo em WAV para editar
ffmpeg -i video.mp4 -vn -ar 48000 -c:a pcm_s24le audio.wav
```

Ao converter para 16 bits (CD, por exemplo), aplique dither uma única vez, no último passo: `ffmpeg -i master.wav -af "aresample=osf=s16:dither_method=triangular" -c:a pcm_s16le saida_16bits.wav`.

Para normalizar o loudness junto com a conversão, use `scripts/normalizar.sh` com a extensão de saída desejada (`.mp4`, `.m4a`, `.mp3`, `.flac`, `.wav`).

## Diagnóstico rápido

- **Ver codec, taxa e canais de um arquivo:** `ffprobe -v error -show_entries stream=codec_name,sample_rate,channels,bit_rate -of default=nw=1 arquivo`
- **Agudo "lavado", com chiado metálico (artefatos de "água"):** taxa baixa demais ou recodificação em cascata. Volte ao master sem perdas.
- **Distorção que só aparece no arquivo final:** picos acima do teto depois da codificação. Meça o true peak no arquivo codificado e deixe mais folga (−1,5 a −2 dBTP).
- **Estalos ou tiques perto de silêncios no arquivo final:** a codificação AAC pode criar degraus em trechos que chegam a zero digital (comum depois de gates e de "isolamento de voz"). Confira sempre o arquivo codificado, não só o WAV (ver `referencias/edicao-fala.md`).

Fontes: tabela de codecs e taxas adaptada e traduzida de `ffmpeg-audio-processing` (josiahsiegel/claude-plugin-marketplace, MIT) e de `claude-video` (MIT). Os avisos de licença estão em `LICENCAS-TERCEIROS.md`.
