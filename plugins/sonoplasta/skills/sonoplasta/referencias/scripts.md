# Scripts de diagnóstico, medição, normalização e checagem mono

Leia este arquivo quando o usuário tiver um arquivo de áudio ou vídeo real e for possível rodar comandos (Claude Code ou outro ambiente com terminal), antes de opinar sobre loudness, picos ou fase. No claude.ai sem acesso ao arquivo ou sem terminal, não tente rodar nada: oriente o usuário a medir no medidor dele (ver `referencias/medicao.md`) e siga só com orientação.

Os scripts ficam em `scripts/`, dentro da pasta da skill. Rode com `bash scripts/<nome>.sh` a partir dessa pasta, ou use o caminho completo.

## Requisitos

- `ffmpeg` com `ffprobe`, e `awk` (já presente em Linux, macOS e Git Bash no Windows). Python não é necessário.
- Se o `ffmpeg` não existir, os scripts param e mostram como instalar: `sudo apt install ffmpeg`, `brew install ffmpeg` ou `winget install --id Gyan.FFmpeg`.
- **Windows:** rode pelo Git Bash (ou WSL). Coloque caminhos com espaço entre aspas e prefira barras normais (`"C:/Users/nome/Meus Videos/video.mp4"`). Caminhos com `\` também funcionam entre aspas.
- **Sobrescrita:** `normalizar.sh` e `preparar-reels.sh` avisam quando a saída já existe e será sobrescrita. Eles nunca gravam por cima do arquivo de entrada.

## Por onde começar

Quando houver um arquivo, rode primeiro `bash scripts/diagnosticar.sh <arquivo>`. Ele junta o preflight, a medição de loudness, a checagem de clipping, DC offset e silêncios e a compatibilidade mono, e termina com o que está bom e o que precisa de atenção. Depois use `normalizar.sh` ou `preparar-reels.sh` para corrigir o loudness, e `medir.sh` para conferir.

## preflight.sh

`bash scripts/preflight.sh <arquivo> [saida_planejada]`

- Mostra container, duração, trilhas de áudio (codec, canais, sample rate, bit depth, bitrate) e de vídeo (codec, resolução, fps).
- Avisa (linhas com `!`) sobre:
  - arquivo sem áudio;
  - mais de uma trilha de áudio (os scripts usam só a primeira);
  - áudio fora de 48 kHz em vídeo;
  - mono gravado como estéreo, com um canal vazio (comum em gravação com interface de 2 entradas e só um microfone).
- Com `saida_planejada`, confere se é seguro gravar: saída diferente da entrada, se o arquivo já existe, se a pasta existe e se há espaço em disco (cerca de 2 vezes o tamanho da entrada).

## diagnosticar.sh

`bash scripts/diagnosticar.sh <arquivo> [--alvo <LUFS>] [--silencio <dB> <segundos>]`

Roda, nesta ordem:

1. `preflight.sh`.
2. `medir.sh`: loudness integrado, LRA, true peak e PLR.
3. `astats` do ffmpeg: sample peak, nível RMS, DC offset, ocorrências no pico e flat factor.
4. `silencedetect`: lista os silêncios com início, fim e duração. O padrão é −50 dB por 1 s.
5. `checar-mono.sh`, se o arquivo for estéreo.

Termina com um resumo "o que está bom / o que precisa de atenção", com uma recomendação para cada problema.

Como interpretar:
- **Clipping:** detectado quando o pico chega a 0 dBFS com topos achatados (flat factor acima de zero). Um seno ou uma mix que só encosta no pico não conta. Pico acima de 0 dBFS só existe em arquivo de ponto flutuante e vai clipar na conversão.
- **DC offset:** acima de 0,005 (média do sinal), indica componente contínua ou subsônica. Um HPF a 20 a 30 Hz resolve.
- **Silêncios:** o diagnóstico indica se cada um está no início, no meio ou no fim. Em vídeo para redes, silêncio no início é problema. Ajuste o limiar com `--silencio` (ex.: `--silencio -40 0.6` para pausas de fala).
- **`--alvo`:** compara o loudness integrado com o alvo do destino, com tolerância de ±1 LU (ver `referencias/entregas.md`).

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

## preparar-reels.sh

`bash scripts/preparar-reels.sh <video> [alvo_LUFS=-14] [true_peak=-1.5]`

- Para Reels, TikTok e Shorts. O alvo e o true peak padrão são prática comum, não especificação oficial da Meta.
- Roda o `checar-mono.sh` no vídeo, normaliza com a mesma lógica do `normalizar.sh` e exporta `<nome>_reels.mp4` com o vídeo copiado (sem recodificar) e o áudio em AAC 320 kbps, 48 kHz.
- A codificação AAC pode criar picos acima do que saiu da normalização. O script mede o arquivo final e, se passar do true peak, refaz com um teto mais baixo (até duas vezes).
- Se o vídeo não estiver em H.264, HEVC ou AV1, a saída sai em `.mov` com o vídeo copiado. Se o Instagram recusar, exporte em H.264 no editor e rode de novo.
- Mostra a medição antes e depois e explica se o `loudnorm` precisou comprimir.

Depois de rodar, ainda vale o checklist pré-publicação de `referencias/instagram-criadores.md`: escuta no celular, legenda e direitos da música.

## limpar-fala/

`transcrever.py`, `marcar-cortes.py` e `aplicar-cortes.sh` cortam silêncios, vícios e repetições de vídeos falados, com aprovação obrigatória do usuário antes de aplicar. Requisitos, fluxo e ajustes em `referencias/limpar-fala.md`.

## Testes

`bash scripts/testes/rodar-testes.sh` gera sinais de teste em `scripts/testes/saida/` (tom de 1 kHz, ruído rosa, estéreo fora de fase, estéreo idêntico, vídeo curto, vídeo vertical para Reels, arquivo clipado, arquivo com silêncio no meio, vídeo com áudio em 44,1 kHz e estéreo com um canal vazio) e confere todos os scripts. A limpeza de fala é testada com uma transcrição de exemplo (`testes/transcricao-exemplo.json`) e uma lista de cortes (`testes/cortes-exemplo.json`), sem precisar da faster-whisper; se não houver Python, o teste do `marcar-cortes.py` é pulado. A pasta `saida/` não vai para o git nem para o ZIP.
