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

## Estrutura

```
.claude-plugin/marketplace.json           catálogo (permite /plugin marketplace add)
plugins/sonoplasta/.claude-plugin/plugin.json
plugins/sonoplasta/skills/sonoplasta/SKILL.md   ← o conteúdo da skill
scripts/empacotar.sh                      gera o ZIP para o claude.ai
```

## Editar

O conteúdo fica todo em `plugins/sonoplasta/skills/sonoplasta/SKILL.md`. Ao mudar algo relevante, suba a `version` em `plugins/sonoplasta/.claude-plugin/plugin.json` para que quem instalou receba a atualização com `/plugin marketplace update sonoplasta`.
