# Sonoplasta 🎚️

Skill para o Claude que faz o papel de um **engenheiro de áudio sênior e produtor musical**: captação, voz para vídeo, mixagem estéreo e Dolby Atmos, masterização, loudness e entregas para YouTube, Instagram Reels, TikTok, podcast, TV, comerciais e discos.

Responde em português do Brasil, com valores de partida concretos (frequências, ratio, attack/release, LUFS, true peak) e deixando claro o que é especificação oficial e o que é prática comum. No Claude Code, também mede e corrige arquivos de verdade com ffmpeg.

## Recursos

| Recurso | Onde funciona |
|---|---|
| **Orientação técnica:** cadeias por fonte (voz, violão, bateria, baixo), frequências, compressão, mixagem estéreo e Atmos, masterização | claude.ai e Claude Code |
| **Entregas:** fichas por destino (YouTube, Reels, TikTok, Spotify, podcast, TV, comerciais, Atmos, CD e vinil) e codecs com comandos de conversão | claude.ai e Claude Code |
| **Modos de trabalho:** separa captação, edição, mixagem, masterização e entrega, e avisa quando o problema nasceu numa etapa anterior | claude.ai e Claude Code |
| **Troubleshooting:** roteiros para voz abafada, sibilância, ruído de fundo, mix embolada, grave que some no celular e outros | claude.ai e Claude Code |
| **Contexto brasileiro:** gospel e worship, coral, sertanejo, MPB, funk e podcast em vídeo | claude.ai e Claude Code |
| **Seus presets:** usa seus plugins, cadeias e alvos | claude.ai (colando) e Claude Code |
| **Diagnóstico de arquivos:** loudness, true peak, clipping, DC offset, silêncios e compatibilidade mono, com resumo do que está bom e do que precisa de atenção | Claude Code |
| **Normalização:** loudnorm em duas passadas e exportação pronta para Reels, sem recodificar o vídeo | Claude Code |
| **Limpeza de fala:** propõe cortes de silêncios, "ãh", "né" e repetições, e só aplica depois da sua aprovação | Claude Code |

## Instalar

### Claude Code

```
/plugin marketplace add jvillalaz/sonoplasta
/plugin install sonoplasta@sonoplasta
```

A skill entra sozinha quando o assunto for áudio. Também dá para chamar direto com `/sonoplasta:sonoplasta`.

Para atualizar: `/plugin marketplace update sonoplasta`.

### claude.ai (navegador ou app)

1. Baixe o `sonoplasta.zip` da [versão mais recente](https://github.com/jvillalaz/sonoplasta/releases/latest).
2. Abra **Customize > Skills** e clique em **+ > Create skill > Upload a skill**.
3. Envie o ZIP.

No claude.ai a skill orienta, mas não roda os scripts. Para medir um arquivo, use o seu medidor de loudness (ex.: Youlean Loudness Meter) e passe os valores na conversa.

## Requisitos dos scripts (Claude Code)

Só a orientação não precisa de nada. Para os scripts:

| Para | Precisa de | Como instalar |
|---|---|---|
| Diagnóstico, medição, normalização e Reels | `ffmpeg` (com `ffprobe`) e `bash` | Windows: `winget install --id Gyan.FFmpeg` e Git Bash · macOS: `brew install ffmpeg` · Linux: `sudo apt install ffmpeg` |
| Limpeza de fala | Python 3 e [faster-whisper](https://github.com/SYSTRAN/faster-whisper) | `pip install faster-whisper` (no Windows: `py -m pip install faster-whisper`) |

A transcrição roda no seu computador: o áudio não é enviado para nenhum serviço. Na primeira vez, a faster-whisper baixa o modelo (cerca de 500 MB).

## Como usar

Exemplos de pedidos:

- "Minha voz no YouTube está abafada. Gravo com um SM7B numa sala sem tratamento."
- "Quais as especificações de entrega para um comercial de TV?"
- "Analisa o áudio desse vídeo antes de eu postar." (Claude Code, com o arquivo na pasta)
- "Deixa esse vídeo pronto para o Reels." (Claude Code)
- "Tira os silêncios e os 'ãh' desse vídeo." (Claude Code; os cortes só são aplicados depois que você aprovar o relatório)

Os scripts também podem ser rodados à mão, a partir da pasta da skill:

```bash
bash scripts/diagnosticar.sh video.mp4 --alvo -14     # diagnóstico completo
bash scripts/normalizar.sh episodio.wav -16           # normaliza para -16 LUFS
bash scripts/preparar-reels.sh video.mp4              # -14 LUFS, -1,5 dBTP, AAC 48 kHz
```

Detalhes de cada script em [`referencias/scripts.md`](plugins/sonoplasta/skills/sonoplasta/referencias/scripts.md) e da limpeza de fala em [`referencias/limpar-fala.md`](plugins/sonoplasta/skills/sonoplasta/referencias/limpar-fala.md).

## Seus presets

Para a skill usar seus plugins, suas cadeias e seus alvos:

1. Copie o [modelo](plugins/sonoplasta/skills/sonoplasta/modelos/sonoplasta-presets.md) para a pasta do seu projeto com o nome `sonoplasta-presets.md`.
2. Preencha só o que quiser. O que você não definir continua vindo dos presets genéricos.

No Claude Code, a skill procura esse arquivo só na pasta de trabalho, nunca em pastas pessoais. No claude.ai, cole o conteúdo na conversa. Os avisos de segurança e as especificações oficiais continuam valendo mesmo com presets próprios.

## Estrutura

```
.claude-plugin/marketplace.json      catálogo (permite /plugin marketplace add)
plugins/sonoplasta/
├── .claude-plugin/plugin.json       manifesto e versão do plugin
└── skills/sonoplasta/               conteúdo da skill (é o que vai no ZIP)
    ├── SKILL.md                     persona, passos e índice
    ├── referencias/                 conhecimento detalhado por assunto
    ├── scripts/                     diagnóstico, medição, normalização, Reels e limpeza de fala
    ├── modelos/                     modelo de presets do usuário
    ├── glossario.md                 termos técnicos
    ├── exemplos.md                  modelos de resposta
    └── LICENCAS-TERCEIROS.md        avisos de licença das fontes
scripts/empacotar.sh                 gera o ZIP para o claude.ai
testes.md                            perguntas para revisar a skill antes de cada versão
FONTES.md                            fontes externas, licenças e o que foi aproveitado
CHANGELOG.md                         mudanças de cada versão
```

## Desenvolvimento

- O `SKILL.md` é um índice curto; o detalhe de cada assunto fica em `referencias/`. Ao criar um arquivo novo lá, adicione-o ao índice do `SKILL.md`.
- Testes dos scripts: `bash plugins/sonoplasta/skills/sonoplasta/scripts/testes/rodar-testes.sh` (gera sinais de teste e confere todos os scripts).
- Antes de cada versão, revise as respostas da skill para as perguntas de [`testes.md`](testes.md).
- Ao mudar algo relevante, suba a `version` em `plugins/sonoplasta/.claude-plugin/plugin.json`, registre no [`CHANGELOG.md`](CHANGELOG.md) e valide com `claude plugin validate .`.
- Gere o ZIP com `./scripts/empacotar.sh` (sai em `dist/`, que não vai para o git).

As regras de edição para o Claude Code estão no [`CLAUDE.md`](CLAUDE.md).

## Créditos

A versão 2.0 aproveita ideias de outras skills de áudio de código aberto, todas reescritas em português e adaptadas ao padrão da sonoplasta. O levantamento, as licenças e o que entrou de cada uma estão em [`FONTES.md`](FONTES.md). Os avisos de licença exigidos (MIT e Apache-2.0) estão em [`LICENCAS-TERCEIROS.md`](plugins/sonoplasta/skills/sonoplasta/LICENCAS-TERCEIROS.md), que também vai dentro do ZIP.
