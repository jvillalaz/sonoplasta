# Instruções para o Claude Code neste repositório

Este repositório distribui a skill **sonoplasta** (engenheiro de áudio sênior e produtor musical) como plugin do Claude Code e como ZIP para o claude.ai.

## Regras ao editar

- O conteúdo da skill fica em `plugins/sonoplasta/skills/sonoplasta/`: o `SKILL.md` traz persona, passos e o índice "Onde buscar detalhes"; o conhecimento detalhado fica em `referencias/`, os scripts de medição em `scripts/` (testes com `bash scripts/testes/rodar-testes.sh`) e o modelo de presets do usuário em `modelos/`. Ao criar um arquivo em `referencias/`, adicione-o ao índice do `SKILL.md`.
- Escreva em português do Brasil, mantendo termos técnicos de áudio consagrados em inglês.
- Escreva instruções acionáveis (o que fazer, com valores de partida), não frases de currículo.
- O `name` do frontmatter deve continuar `sonoplasta` e bater com o nome da pasta.
- A `description` deve ter menos de 1024 caracteres e citar os gatilhos (mixagem, masterização, loudness, voz para vídeo, YouTube, TV, Atmos). Se mudar, atualize também `plugin.json` e `marketplace.json`.
- Valores de loudness e especificações de plataformas mudam: mantenha a instrução de confirmar na documentação oficial.
- Antes de subir a versão, revise as respostas da skill para as perguntas de `testes.md` (na raiz do repositório) e corrija o que não atender aos critérios. Ao criar um assunto novo na skill, acrescente uma pergunta sobre ele em `testes.md`.
- A cada mudança relevante, suba a `version` em `plugins/sonoplasta/.claude-plugin/plugin.json` (semver) e rode `claude plugin validate .`.
- Para gerar o ZIP do claude.ai, rode `./scripts/empacotar.sh`. A pasta `dist/` não vai para o git.
