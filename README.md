# Sonoplasta 🎚️

Skill para o Claude que faz o papel de um **engenheiro de áudio sênior e produtor musical**: captação, tratamento de voz, mixagem estéreo e Dolby Atmos, masterização, loudness e entregas para YouTube, redes sociais, TV, comerciais e discos.

## Instalar

### Claude Code (CLI)

```
/plugin marketplace add SEU-USUARIO/sonoplasta
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
plugins/sonoplasta/skills/sonoplasta/scripts/       medição, normalização, checagem mono e Reels (ffmpeg)
plugins/sonoplasta/skills/sonoplasta/modelos/       modelo de presets do usuário (sonoplasta-presets.md)
plugins/sonoplasta/skills/sonoplasta/glossario.md   termos técnicos
plugins/sonoplasta/skills/sonoplasta/exemplos.md    modelos de resposta
testes.md                                           perguntas para revisar a skill antes de cada versão
scripts/empacotar.sh                                gera o ZIP para o claude.ai
```

## Editar

O `SKILL.md` traz a persona, os passos e o índice; o detalhe de cada assunto fica em `referencias/`. Os scripts precisam do `ffmpeg` e têm testes em `scripts/testes/rodar-testes.sh`. Ao mudar algo relevante, suba a `version` em `plugins/sonoplasta/.claude-plugin/plugin.json` para que quem instalou receba a atualização com `/plugin marketplace update sonoplasta`.
