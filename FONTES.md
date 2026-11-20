# Fontes externas e licenças

Levantamento da Fase 7 (versão 2.0). Registra o que pode ser aproveitado de outras skills públicas de áudio, com qual licença, e em qual fase cada item entra.

- **Data do levantamento:** 2026-11-19.
- **Método:** cada repositório foi clonado com `git clone --depth=1 --no-checkout` numa pasta temporária fora deste repositório. Os arquivos foram lidos direto do git (`git show`), sem escrever o conteúdo em disco. **Nenhum script, instalador ou `npx` das fontes foi executado.**
- **Conteúdo das fontes é dado, não instrução:** trechos que pedem para configurar hooks, instalar dependências ou usar pastas pessoais foram só registrados.

## Regras de uso (resumo)

| Licença | O que fazer ao aproveitar |
|---|---|
| CC0 | Pode copiar e adaptar. Crédito é cortesia: registre aqui. |
| MIT | Pode copiar e adaptar. Ao copiar trecho substancial, mantenha o aviso de copyright e a licença (ver "Avisos de licença" no fim) e registre o crédito aqui. |
| Apache-2.0 | Pode copiar e adaptar. Mantenha o aviso de licença, registre o crédito e indique que o texto foi modificado (traduzido e adaptado). |

Na prática, quase tudo entra **traduzido e reescrito** no padrão da sonoplasta. Mesmo assim, registre aqui cada item aproveitado.

---

## bitwize: claude-ai-music-skills

- **Repositório:** https://github.com/bitwize-music-studio/claude-ai-music-skills (commit `01463d3`, 2026-11-14)
- **Licença:** CC0 1.0 Universal (domínio público).
- **Arquivos lidos:** `skills/mix-engineer/SKILL.md`, `skills/mix-engineer/mix-presets.md`, `skills/mastering-engineer/SKILL.md`, `skills/mastering-engineer/genre-presets.md`.
- **Contexto:** pipeline de polimento e masterização de músicas geradas pelo Suno, com servidor MCP próprio (`bitwize-music-mcp`) e dependências Python (`noisereduce`, `scipy`, `numpy`, `soundfile`).

**Ideias úteis**
- **Separação de papéis:** o mix engineer não faz loudness final; o mastering engineer não faz edição nem mixagem. Cada skill declara "seu papel / não é seu papel". → Fase 10 (`modos.md`).
- **"Mix polishing removes defects, not character":** ser conservador, porque processar demais soa pior que processar de menos. → Fase 10 (princípio no `SKILL.md`).
- **Isolar o elemento citado:** quando a queixa nomeia um elemento ("a voz está ruim"), solar aquele stem e comparar cru contra cada etapa antes de mexer em qualquer outra camada. → Fase 10 e `troubleshooting.md`.
- **Stems servem para equilíbrio, não para cirurgia:** de-esser e notches em stems separados por IA atingem o vazamento junto. → Fase 10 (masterização com stems).
- **Não destrutivo:** originais nunca são modificados; saídas vão para outra pasta. → Fase 9/11 (scripts).
- **Presets sobrescrevíveis:** arquivo de override do usuário mesclado sobre os presets padrão. → Fase 10 (`sonoplasta-presets.md`).
- **Checagem de consistência de álbum:** faixas com diferença maior que 2 LU, true peak acima de 0 dBTP e loudness fora de −20 a −8 LUFS geram alerta. → Fase 9 (`diagnosticar.sh`, opcional para lote).

**Candidatos a cópia:** nenhum trecho literal necessário. As ideias acima entram reescritas.

**Riscos nos scripts:** o processamento real fica no servidor MCP (`servers/bitwize-music-server/`), não nas skills. Os overrides ficam em `~/.bitwize-music/` (pasta pessoal): **não adotar** esse local. A Fase 10 usa só a pasta de trabalho.

**Divergências com a sonoplasta**
- Recomenda "master a −14 LUFS funciona em todo gênero". A sonoplasta mantém "busque o volume que a música pede" com faixas típicas por gênero (`generos-br.md`, prática comum).
- Coordenação de frequências específica do pipeline (presença em 3 kHz na mix e corte em 3,5 kHz no master) é regra do pipeline deles. Descartar.

---

## claude-video

- **Repositório:** https://github.com/agricidaniel/claude-video (commit `4253a2b`, 2026-04-06)
- **Licença:** MIT, Copyright (c) 2026 Daniel Agrici.
- **Arquivos lidos:** `skills/video-audio/SKILL.md`, `references/audio.md`, `references/audio-enhance.md`, `scripts/preflight.sh`, `hooks/preflight-check.sh`, `scripts/audio_enhance.py` (só cabeçalho e chamadas).

**Ideias úteis**
- **O `preflight.sh` deles é uma checagem de segurança de escrita, não uma análise com ffprobe:** saída diferente da entrada (com `realpath`), aviso se a saída já existe, pasta de saída e espaço em disco (2 vezes o tamanho da entrada), com resultado em JSON. A análise com `ffprobe` (codec, canais, sample rate, bitrate) fica no passo "Pre-Flight" do `SKILL.md`. → Fase 9: o `preflight.sh` da sonoplasta junta as duas coisas.
- **Usar `ffmpeg -n` (não sobrescrever) por padrão.** Os scripts atuais da sonoplasta usam `-y`. → Fase 9 (avaliar `-n` ou aviso quando a saída existe).
- **Filtros de referência:** `silencedetect=noise=-30dB:d=0.5`, `silenceremove`, `afftdn=nf=-25:nt=w` (redução de ruído por FFT) e `anlmdn` (non-local means). → Fase 8 (`edicao-fala.md`) e Fase 9 (`silencedetect`; o plano usa −50 dB por 1 s como padrão para silêncio longo).
- **Ferramentas de IA citadas:** Demucs (separação de voz), DeepFilterNet3 (redução de ruído) e pyannote (diarização). → Fase 8, só como menção ("quando o ffmpeg não basta"), sem script.

**Candidatos a cópia:** a lógica de `realpath` e espaço em disco é simples e será reescrita, sem cópia literal.

**Riscos nos scripts**
- `hooks/hooks.json` e `preflight-check.sh` pedem para instalar hooks em `~/.claude/settings.json`. **Não adotar.**
- `audio_enhance.py` roda `subprocess` com Demucs e DeepFilterNet (baixam modelos) e pede token do HuggingFace (`HF_TOKEN`) para o pyannote. **Não adotar.**

**Divergências com a sonoplasta**
- TikTok/Reels a −1,0 dBTP. A sonoplasta mantém −1 a −2 dBTP como prática comum, por causa da recompressão.
- Podcast a −1,5 dBTP. A sonoplasta mantém −1 dBTP (Apple Podcasts). As duas formas são seguras.
- Cita o modo "Loud" do Spotify (−11 LUFS). É útil: → Fase 8, conferir na documentação do Spotify e acrescentar em `entregas.md` como observação.

---

## josiahsiegel: claude-plugin-marketplace

- **Repositório:** https://github.com/josiahsiegel/claude-plugin-marketplace (commit `5a1b112`, 2026-06-18)
- **Licença:** MIT, Copyright (c) 2025 Josiah Siegel (o `plugin.json` do `ffmpeg-core` também declara MIT).
- **Arquivos lidos:** `plugins/ffmpeg-core/skills/ffmpeg-audio-processing/SKILL.md` e lista de referências e scripts do `ffmpeg-core`.

**Ideias úteis**
- **Tabela de codecs:** AAC, MP3, Opus, FLAC, ALAC, Vorbis, AC3 e EAC3, com encoder do ffmpeg, faixa de bitrate e uso. → Fase 8 (`codecs.md`).
- **Bitrates recomendados por uso:**

  | Uso | AAC | MP3 | Opus |
  |---|---|---|---|
  | Fala | 64 a 96k | 96 a 128k | 48 a 64k |
  | Música padrão | 128 a 192k | 192 a 256k | 96 a 128k |
  | Música em alta | 256 a 320k | 320k | 160 a 256k |

  → Fase 8.
- **Comandos de extração e conversão** (`-c:a aac -b:a 256k`, `libmp3lame`, `libopus`, `flac`) e menção à ferramenta `ffmpeg-normalize` (modo álbum). → Fase 8.
- **Tabela de padrões de loudness** (EBU R128, ATSC A/85 −24 LKFS/−2 dBTP, podcast −16 a −19 LUFS). Confere com `entregas.md`.
- **Alerta de caminhos no Windows** (barras e aspas) no topo da skill. → Fase 9 (documentar em `scripts.md`).

**Candidatos a cópia:** a tabela de bitrates (dados factuais, reescritos em português). Crédito obrigatório aqui.

**Riscos nos scripts:** `scripts/generate-whisper-subtitles.sh` baixa modelos do HuggingFace com `wget`/`curl`. **Não adotar** (a Fase 11 usa `faster-whisper` com instrução de instalação explícita).

---

## audioeditor: personal_ai_infrastructure (AudioEditor)

- **Repositório:** https://github.com/danielmiessler/personal_ai_infrastructure (commit `94bd8f2`, 2026-11-18)
- **Licença:** MIT, Copyright (c) 2025-2026 Daniel Miessler.
- **Caminho:** o plano citava `Packs/Utilities/src/AudioEditor`, mas a skill está hoje em `LifeOS/install/skills/AudioEditor/`.
- **Arquivos lidos:** `SKILL.md`, `Tools/Transcribe.ts`, `Tools/Analyze.ts`, `Tools/Edit.ts` e `Tools/Polish.ts` (trechos).

**Ideias úteis**
- **Fluxo transcrever → classificar → editar com `--preview`:** o preview não modifica nada. → Fase 11 (fluxo com aprovação obrigatória).
- **Categorias de corte:**
  - `CUT_FILLER`: vícios isolados, não os embutidos na fala.
  - `CUT_FALSE_START`.
  - `CUT_STUTTER`: "o o", mas não a repetição enfática "muito, muito importante".
  - `CUT_DEAD_AIR`.
  - `CUT_REDO_TAKE`: a mesma ideia dita de novo depois de uma pausa; corta a primeira tomada.

  → Fase 11 (`marcar-cortes.py`; a distinção entre repetição enfática e acidental é a parte mais valiosa).
- **Emendas:** crossfade de 40 ms (curva `qsin`) em cada corte e room tone extraído do próprio arquivo para preencher. → Fase 11 (o plano pede microfades de 10 ms; testar 10 a 40 ms).
- **"Done means heard":** passar no medidor não basta, é preciso ouvir. Os reparos mexem só no defeito. → Fase 10 (princípio).
- **Artefatos de noise gate na captação:**
  - Gates e "isolamento de voz" do sistema cortam para zero digital sem fade, e o nivelamento transforma cada borda em um "tique".
  - A codificação AAC reintroduz degraus perto do silêncio, então a checagem precisa ser feita no arquivo final codificado.

  → Fase 8 (`edicao-fala.md`) e `troubleshooting.md`.

**Candidatos a cópia:** nenhum código (TypeScript/Bun, dependente da infraestrutura LifeOS). As categorias de corte entram reescritas.

**Riscos nos scripts**
- `Polish.ts` lê `~/.claude/.env` (segredos do usuário) e envia o áudio para a API externa Cleanvoice. **Não adotar.**
- `Analyze.ts` chama um LLM pela infraestrutura própria (`LIFEOS/TOOLS/Inference.ts`).
- `Transcribe.ts` usa `insanely-fast-whisper` com o modelo `openai/whisper-large-v3` (download grande).
- As preferências do usuário ficam em `~/.claude/LIFEOS/USER/...`. **Não adotar.**

---

## clawfu: clawfu-skills

- **Repositório:** https://github.com/guia-matthieu/clawfu-skills (commit `4108f5c`, 2026-10-01)
- **Licença:** MIT, Copyright (c) 2026 Guia (o frontmatter das skills também declara MIT).
- **Arquivos lidos:** `skills/audio/audio-editing/SKILL.md` e `skills/audio/pydub-automation/SKILL.md`.
- **Contexto:** voltado a profissionais de marketing; distribuído também por um servidor MCP via npm (`@clawfu/mcp-skills`).

**Ideias úteis**
- **Tabela "Claude faz / você decide"** (Claude estrutura e sugere; o usuário decide direção criativa, equipamento e padrão de qualidade). → Fase 10 (`modos.md`).
- **Valores de compressão para voz falada** (threshold de −18 dB, ratio 3:1, attack de 15 ms e release de 150 ms) e para áudio ruim (ratio 4:1, attack de 20 ms e release de 200 ms). Coerentes com `presets.md`; servem para conferir.
- **PyDub para lote** (`detect_silence`, `split_on_silence`, exportação com bitrate). → Fase 11, como alternativa citada (a sonoplasta segue com ffmpeg).

**Candidatos a cópia:** nenhum. Pouca coisa além do que a sonoplasta já tem. O plano esperava parâmetros de ducking, mas eles não aparecem nessas skills.

**Riscos nos scripts:** não há scripts nas skills lidas. O pacote npm do servidor MCP não foi avaliado. **Não instalar.**

**Divergências com a sonoplasta**
- **Ordem "compressão antes da EQ":** a sonoplasta mantém EQ corretiva → compressão → EQ de cor, mais detalhada e alinhada às fases 1 a 4.
- **"Spotify/Apple Podcasts −14 LUFS":** a sonoplasta mantém −16 LUFS para a Apple Podcasts (oficial).
- **Noise gate em −40 dB entre falas:** a sonoplasta prefere expander suave (`troubleshooting.md`), porque o gate cria o efeito de "abre e fecha" e os tiques citados pela fonte audioeditor.

---

## patterns: audio-engineering-patterns

- **Ponteiro no plano:** https://github.com/majiayu000/claude-skill-registry, caminho `skills/data/audio-engineering-patterns`.
  - Hoje o caminho tem só um aviso de que a cópia arquivada foi para `majiayu000/claude-skill-registry-data` (commit `a21980a`).
  - O README desse registro avisa que **a licença MIT do registro não relicencia as skills arquivadas** e manda conferir o `metadata.json`.
- **Origem real (pelo `metadata.json`):** https://github.com/4444J99/a-i--skills, caminho `skills/creative/audio-engineering-patterns/` (commit `df54458`, 2026-10-24). Autor: 4444J99.
- **Licença:**
  - O `LICENSE` do repositório de origem é **Apache-2.0**, e o `metadata.json` do registro também registra Apache-2.0 ("compatible").
  - O frontmatter da própria skill declara `license: MIT`.

  Por segurança, siga **Apache-2.0** (a mais exigente das duas): crédito, aviso de licença e indicação de modificação.
- **Arquivos lidos:** `SKILL.md`, `references/frequency-chart.md` e lista de seções de `references/plugin-chains.md`.

**Ideias úteis**
- **`frequency-chart.md`:**
  - Faixas de fundamental por instrumento (bumbo de 40 a 100 Hz, caixa de 150 a 250 Hz, baixo de 40 a 400 Hz, voz masculina de 85 a 180 Hz, voz feminina de 165 a 255 Hz, piano de 27 Hz a 4,2 kHz, entre outros) e até onde vão os harmônicos.
  - Guia por região: sub, grave, médio-grave, médio, médio-agudo, presença, brilho e ar, com "realçar / cortar / instrumentos".

  → Fase 8 (`frequencias.md`, base da tabela por fonte).
- **Problemas por faixa** (embolado em 200 a 400 Hz, "caixa" em 400 a 600 Hz, nasal em 800 Hz a 1 kHz, aspereza em 2 a 4 kHz, sibilância em 5 a 8 kHz). Coerente com a sonoplasta. → Fase 8.
- **`plugin-chains.md`** (cadeias de voz, bateria, baixo, guitarra, mix bus e master e erros comuns). → Conferência dos `presets.md`. Guitarra elétrica (limpa e distorcida) não existe na sonoplasta: → Fase 8 (`frequencias.md`) ou futura atualização de `presets.md`.

**Candidatos a cópia:** valores da tabela de fundamentais (dados factuais, reescritos em português e cruzados com outra fonte). Crédito e aviso Apache-2.0 obrigatórios.

**Riscos nos scripts:** não há scripts na skill.

---

## travis: travisjneuman/.claude (audio-production)

- **Repositório:** https://github.com/travisjneuman/.claude (commit `5ed98f2`, 2026-11-18)
- **Licença:** MIT, Copyright (c) 2026 Travis Neuman.
- **Arquivos lidos:** `skills/audio-production/SKILL.md` e as referências `mixing.md`, `mastering.md`, `podcast-production.md`, `quality-checklist.md` e `file-formats.md` (seções e alvos).

**Ideias úteis**
- **Metas de masterização** (lista de objetivos) e **cadeia típica de master**. → Fase 10 (modo masterização: "faz / não faz").
- **Checklist de qualidade pré-exportação e final** (alvo de LUFS, true peak abaixo de −1 dBTP). → Fase 9 (resumo do `diagnosticar.sh`).
- **Especificações de exportação por formato.** → Fase 8 (`codecs.md`, conferência).
- **Tabela de conceitos** (sample rate, bit depth, faixa dinâmica de ~96 dB em 16 bits e ~144 dB em 24 bits). → `glossario.md` (conferência).

**Candidatos a cópia:** nenhum literal.

**Riscos:** o `SKILL.md` tem uma instrução sobre "host de mídia designado" da configuração privada do autor. Não se aplica e foi ignorada. Não há scripts na skill.

**Divergências com a sonoplasta**
- **Podcast "−16 LUFS (mono), −19 LUFS (estéreo)":** está **invertido** em relação à referência usual (AES e Apple Podcasts: −16 LUFS em estéreo, cerca de −19 LUFS em mono). A sonoplasta mantém os valores de `entregas.md`.
- **"CD −9 a −12 LUFS":** a sonoplasta mantém "sem alvo de norma; decisão artística", com faixas por gênero como prática comum.

---

## Decisões: aproveitar / adaptar / descartar

| Item | Fonte | Decisão | Fase |
|---|---|---|---|
| Tabela de fundamentais e harmônicos por instrumento | patterns | Adaptar (traduzir, cruzar valores, crédito Apache-2.0) | 8 |
| Guia de regiões do espectro e problemas por faixa | patterns | Adaptar | 8 |
| O que o alto-falante do celular reproduz | sonoplasta (já existe) | Aproveitar o que já está em `instagram-criadores.md` e `troubleshooting.md` | 8 |
| Tabela de codecs e bitrates por uso | josiahsiegel | Adaptar (crédito MIT) | 8 |
| Comandos ffmpeg de conversão por codec | josiahsiegel, claude-video | Adaptar | 8 |
| Modo "Loud" do Spotify (−11 LUFS) | claude-video | Adaptar após conferir no Spotify for Artists | 8 |
| Filtros `afftdn`, `anlmdn`, `silenceremove` | claude-video | Adaptar | 8 |
| Ordem de processamento de fala | clawfu, travis | Descartar a ordem deles e manter a da sonoplasta | 8 |
| Artefatos de gate e degraus reintroduzidos pelo AAC | audioeditor | Adaptar | 8 |
| Parâmetros de ducking | (nenhuma fonte trouxe) | Escrever do zero com base em `instagram-criadores.md` | 8 |
| Preflight de segurança de escrita (entrada ≠ saída, disco, `-n`) | claude-video | Adaptar (reescrever) | 9 |
| Preflight de análise com ffprobe | claude-video (SKILL.md) | Adaptar | 9 |
| Consistência de lote/álbum (diferença > 2 LU) | bitwize | Adaptar (opcional) | 9 |
| Checklist de qualidade final | travis | Adaptar no resumo do `diagnosticar.sh` | 9 |
| Alerta de caminhos no Windows | josiahsiegel | Adaptar em `scripts.md` | 9 |
| Separação de papéis "faz / não faz" | bitwize, travis, clawfu | Adaptar | 10 |
| "Remover defeitos, não caráter" e "done means heard" | bitwize, audioeditor | Adaptar | 10 |
| Presets sobrescrevíveis | bitwize | Adaptar (só na pasta de trabalho, nunca em pasta pessoal) | 10 |
| Fluxo transcrever → marcar → aprovar → aplicar com preview | audioeditor | Adaptar | 11 |
| Categorias de corte (repetição enfática × acidental, retomada) | audioeditor | Adaptar para português | 11 |
| Crossfade nas emendas e room tone de preenchimento | audioeditor | Adaptar (testar 10 a 40 ms) | 11 |
| PyDub para lote | clawfu | Descartar (a sonoplasta usa ffmpeg) | 11 |
| Hooks em `~/.claude/settings.json` | claude-video | Descartar | — |
| Upload para Cleanvoice e leitura de `~/.claude/.env` | audioeditor | Descartar | — |
| Download de modelos por script (whisper.cpp, Demucs, DeepFilterNet) | josiahsiegel, claude-video | Descartar como script; citar como opção manual | 8/11 |
| Servidor MCP e pipeline Suno | bitwize, clawfu | Descartar | — |
| "−14 LUFS para todo gênero", alvos de podcast invertidos, "CD −9 a −12" | bitwize, travis | Descartar (conflitam com fases 1 a 6) | — |

## Avisos de licença

Os textos completos das licenças estão nos repositórios de origem. Ao copiar trecho substancial de uma fonte MIT ou Apache-2.0, reproduza aqui o aviso correspondente.

- **claude-video:** MIT License, Copyright (c) 2026 Daniel Agrici.
- **josiahsiegel/claude-plugin-marketplace:** MIT License, Copyright (c) 2025 Josiah Siegel.
- **personal_ai_infrastructure:** MIT License, Copyright (c) 2025-2026 Daniel Miessler.
- **clawfu-skills:** MIT License, Copyright (c) 2026 Guia.
- **travisjneuman/.claude:** MIT License, Copyright (c) 2026 Travis Neuman.
- **4444J99/a-i--skills (audio-engineering-patterns):** Apache License 2.0. Conteúdo traduzido e adaptado pela sonoplasta.
- **bitwize-music-studio/claude-ai-music-skills:** CC0 1.0 (sem exigência de aviso).

## Divergências registradas

Conflitos entre fontes e a sonoplasta, para a regra da Fase 8 ("se houver conflito, mantenha o valor das fases 1 a 4 e registre a diferença"):

| Tema | Fonte diz | A sonoplasta mantém |
|---|---|---|
| Alvo de master por gênero | −14 LUFS serve para todos (bitwize) | Volume que a música pede; faixas por gênero como prática comum |
| True peak em Reels/TikTok | −1,0 dBTP (claude-video) | −1 a −2 dBTP, prática comum |
| Podcast mono × estéreo | −16 mono / −19 estéreo (travis) | −16 estéreo / ~−19 mono |
| Apple Podcasts | −14 LUFS (clawfu) | −16 LUFS (oficial Apple) |
| Ordem de processamento de fala | compressão antes da EQ (clawfu) | EQ corretiva → compressão → EQ de cor |
| Ruído entre falas | gate em −40 dB (clawfu) | Expander suave (3 a 6 dB) |
| Loudness de CD | −9 a −12 LUFS (travis) | Sem alvo de norma |
| Crossfade nas emendas | 40 ms qsin (audioeditor) | Microfades de 5 a 20 ms (`instagram-criadores.md`); a Fase 11 testa |
