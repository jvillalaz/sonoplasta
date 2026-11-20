# Scripts de medição, normalização e checagem mono

Leia este arquivo quando o usuário tiver um arquivo de áudio ou vídeo real e for possível rodar comandos (Claude Code ou outro ambiente com terminal), antes de opinar sobre loudness, picos ou fase. No claude.ai sem acesso ao arquivo ou sem terminal, não tente rodar nada: oriente o usuário a medir no medidor dele (ver `referencias/medicao.md`) e siga só com orientação.

Os scripts ficam em `scripts/`, dentro da pasta da skill. Rode com `bash scripts/<nome>.sh` a partir dessa pasta, ou use o caminho completo.

## Requisitos

- `ffmpeg` com `ffprobe`, e `awk` (já presente em Linux, macOS e Git Bash no Windows). Python não é necessário.
- Se o `ffmpeg` não existir, os scripts param e mostram como instalar: `sudo apt install ffmpeg`, `brew install ffmpeg` ou `winget install --id Gyan.FFmpeg`.

## medir.sh

`bash scripts/medir.sh [--json] <arquivo>`

- Aceita áudio ou vídeo e mede a primeira trilha de áudio com o filtro `ebur128` (ITU-R BS.1770).
- Mostra o loudness integrado (I, em LUFS), o loudness range (LRA, em LU), o true peak (dBTP) e o PLR (true peak menos I).
- Com `--json`, devolve uma linha JSON (`integrado_lufs`, `lra_lu`, `true_peak_dbtp`, `plr_db`), boa para comparar arquivos ou alimentar outras etapas.

Como interpretar:
- **I:** compare com o alvo do destino em `referencias/entregas.md`. Diferenças de até ±0,5 LU costumam estar dentro da tolerância. Confirme a tolerância do destino.
- **True peak:** acima de −1 dBTP é risco de distorção na conversão para AAC/MP3 e na recompressão das redes. Para Reels, TikTok e Shorts, prefira −1,5 a −2 dBTP.
- **LRA:** voz falada bem nivelada fica por volta de 3 a 6 LU. Acima de ~10 LU em voz para celular, o ouvinte vai mexer no volume: nivele com automação ou compressão. Música varia muito com o gênero.
- **PLR:** abaixo de ~8 dB indica master muito limitado (pouca dinâmica, transientes achatados). Entre ~9 e 14 dB é a faixa comum em música atual bem resolvida. Use como pista, não como regra.
- **I de −70 LUFS** significa silêncio ou sinal abaixo do gate.

## normalizar.sh

`bash scripts/normalizar.sh <arquivo> <alvo_LUFS> [true_peak] [saida]`

- Normalização em duas passadas com `loudnorm`: a primeira mede, a segunda aplica com os valores medidos e `linear=true`.
- True peak padrão de −1 dBTP. Saída sempre em 48 kHz.
- **Saída padrão:** `<nome>_<alvo>LUFS.wav` (PCM 24 bits) para áudio e `<nome>_<alvo>LUFS.mov` (vídeo copiado, áudio PCM 24 bits) para vídeo.
- **Outro formato:** defina a saída pela extensão. `.mp4`/`.m4a` gera AAC 320 kbps, `.mp3` gera 320 kbps, `.flac` e `.aif` também funcionam. Em vídeo, o vídeo é sempre copiado (`-c:v copy`), sem recodificar.
- Ao final, mede a entrada e a saída e mostra antes e depois.

Como interpretar:
- **"Modo linear":** só ganho, a dinâmica não mudou. É o resultado ideal.
- **"Modo dinâmico" por causa do true peak:** o ganho necessário passaria do true peak máximo, então o `loudnorm` comprimiu e limitou por conta própria. Ouça antes de entregar. O melhor caminho é controlar os picos na mix ou no master (limiter ou clipper suave) e normalizar de novo, ou aceitar um alvo mais baixo.
- **"Modo dinâmico" com LRA 0:** sinal constante (tom, ruído de teste). O resultado equivale a um ganho fixo.
- Normalizar não substitui mixar: se a voz some sob a trilha, o problema é de mix, não de loudness.

Exemplos:
- Voz para podcast: `bash scripts/normalizar.sh episodio.wav -16`
- Vídeo para YouTube, mantendo MP4 com AAC: `bash scripts/normalizar.sh video.mp4 -14 -1 video_final.mp4`

## checar-mono.sh

`bash scripts/checar-mono.sh <arquivo>`

- Mede o loudness em estéreo e depois na soma mono `(L+R)/2`, medida como dual mono, isto é, como se tocasse igual nos dois alto-falantes.
- Referências: canais idênticos perdem 0 dB, canais sem nenhuma correlação perdem cerca de 3 dB e um canal com polaridade invertida faz o sinal sumir.
- Se o arquivo já for mono, avisa e sai. Com mais de 2 canais, usa só os dois primeiros.

Como interpretar a perda na soma mono:
- **Até 1,5 dB (OK):** boa compatibilidade mono, típica de mixes com voz, bumbo e baixo no centro.
- **1,5 a 3 dB (atenção):** estéreo largo. Ouça em mono e confira se os elementos centrais continuam firmes.
- **Acima de 3 dB (ALERTA):** provável problema de fase entre microfones, polaridade invertida ou alargamento exagerado (wideners, Haas, chorus). Ouça em mono e procure o que some ou fica oco. Veja `referencias/gravacao-fase.md`.
- **Sinal desaparece em mono:** um canal está com a polaridade invertida.

A medição não substitui a escuta: confirme sempre ouvindo em mono e no celular.

## Testes

`bash scripts/testes/rodar-testes.sh` gera sinais de teste em `scripts/testes/saida/` (tom de 1 kHz, ruído rosa, estéreo fora de fase, estéreo idêntico e um vídeo curto) e confere os três scripts. A pasta `saida/` não vai para o git nem para o ZIP.
