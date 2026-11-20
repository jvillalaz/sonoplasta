# Sonoplasta 🎚️

Skill para o Claude que faz o papel de um **engenheiro de áudio sênior e produtor musical**: captação, tratamento de voz, mixagem estéreo e Dolby Atmos, masterização, loudness e entregas para YouTube, redes sociais, TV, comerciais e discos.

## Recursos

- **Orientação técnica com valores de partida:** cadeias de processamento por fonte, frequências, compressão, alvos de loudness e true peak, sempre marcando o que é especificação oficial e o que é prática comum.
- **Entregas:** fichas por destino (YouTube, Reels, TikTok, Spotify, podcast, TV, comerciais, Atmos, CD e vinil) e codecs com comandos de conversão.
- **Modos de trabalho:** separa captação, edição, mixagem, masterização e entrega, e avisa quando o problema é de uma etapa anterior.
- **Diagnóstico de arquivos** (Claude Code): preflight, loudness, true peak, clipping, DC offset, silêncios e compatibilidade mono, com um resumo do que está bom e do que precisa de atenção.
- **Normalização:** loudnorm em duas passadas e exportação pronta para Reels, sem recodificar o vídeo.
- **Limpeza de fala** (Claude Code): transcreve, propõe cortes de silêncios, "ãh", "né" e repetições, e só aplica depois da sua aprovação.
- **Seus presets:** a skill usa seus plugins, cadeias e alvos (ver abaixo).
- **Contexto brasileiro:** gospel e worship, coral, sertanejo, MPB, funk e podcast em vídeo.

## Requisitos

- **Só orientação** (claude.ai ou Claude Code): nada além da skill.
- **Scripts de medição, diagnóstico e normalização** (Claude Code): `ffmpeg` com `ffprobe` e `bash` (no Windows, Git Bash ou WSL).
- **Limpeza de fala:** também Python 3 e, para transcrever, a biblioteca [faster-whisper](https://github.com/SYSTRAN/faster-whisper) (`pip install faster-whisper`). A transcrição roda no seu computador.

## Instalar

### Claude Code (CLI)

```
/plugin marketplace add jvillalaz/sonoplasta
/plugin install sonoplasta@sonoplasta
```

Depois disso, a skill entra sozinha quando o assunto for áudio. Também dá para chamar direto com `/sonoplasta`.

### Claude no navegador ou app (claude.ai)

1. Gere o ZIP com `./scripts/empacotar.sh` (ou baixe na aba Releases, se houver).
2. Abra **Customize > Skills**, clique em **+ > Create skill > Upload a skill**.
3. Envie o arquivo `dist/sonoplasta.zip`.

## Seus presets

Para a skill usar seus plugins, suas cadeias e seus alvos, copie `plugins/sonoplasta/skills/sonoplasta/modelos/sonoplasta-presets.md` para a pasta do seu projeto, mantendo o nome `sonoplasta-presets.md`, e preencha o que quiser. No Claude Code, a skill procura esse arquivo só na pasta de trabalho e dá prioridade a ele sobre os presets genéricos. No claude.ai, cole o conteúdo na conversa. Os avisos de segurança e as especificações oficiais continuam valendo.

## Estrutura

```
.claude-plugin/marketplace.json                     catálogo (permite /plugin marketplace add)
plugins/sonoplasta/.claude-plugin/plugin.json       manifesto e versão do plugin
plugins/sonoplasta/skills/sonoplasta/SKILL.md       persona, passos e índice da skill
plugins/sonoplasta/skills/sonoplasta/referencias/   conhecimento detalhado por assunto
plugins/sonoplasta/skills/sonoplasta/scripts/       diagnóstico, medição, normalização, Reels e limpeza de fala
plugins/sonoplasta/skills/sonoplasta/modelos/       modelo de presets do usuário (sonoplasta-presets.md)
plugins/sonoplasta/skills/sonoplasta/glossario.md   termos técnicos
plugins/sonoplasta/skills/sonoplasta/exemplos.md    modelos de resposta
plugins/sonoplasta/skills/sonoplasta/LICENCAS-TERCEIROS.md   avisos de licença das fontes
testes.md                                           perguntas para revisar a skill antes de cada versão
FONTES.md                                           fontes externas, licenças e o que foi aproveitado
CHANGELOG.md                                        mudanças de cada versão
scripts/empacotar.sh                                gera o ZIP para o claude.ai
```

## Editar

O `SKILL.md` traz a persona, os passos e o índice; o detalhe de cada assunto fica em `referencias/`. Os scripts precisam do `ffmpeg` e têm testes em `scripts/testes/rodar-testes.sh`. Ao mudar algo relevante, suba a `version` em `plugins/sonoplasta/.claude-plugin/plugin.json` para que quem instalou receba a atualização com `/plugin marketplace update sonoplasta`.

## Créditos

A versão 2.0 aproveita ideias de outras skills de áudio de código aberto, todas reescritas em português e adaptadas ao padrão da sonoplasta. O levantamento, as licenças e o que entrou de cada uma estão em [`FONTES.md`](FONTES.md). Os avisos de licença exigidos (MIT e Apache-2.0) estão em [`LICENCAS-TERCEIROS.md`](plugins/sonoplasta/skills/sonoplasta/LICENCAS-TERCEIROS.md), que também vai dentro do ZIP.
