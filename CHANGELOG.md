# Changelog

Mudanças de cada versão da skill sonoplasta. O formato segue o [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/) e as versões seguem o [versionamento semântico](https://semver.org/lang/pt-BR/).

## [2.0.1] - 2026-11-20

### Adicionado
- Licença MIT (`LICENSE`) e campo `license` no `plugin.json` e no `marketplace.json`.
- `homepage` e `repository` no `plugin.json`.
- Ícone do projeto em `docs/icone.svg`.

### Mudado
- README reorganizado: cabeçalho com ícone e badges, navegação, exemplos de pergunta e resposta, tour por área, tabela de scripts, seção de versões e licença.

## [2.0.0] - 2026-11-20

Lançamento que reúne as versões 1.6.0 a 1.9.0, com conhecimento e ideias adaptados de outras skills de áudio de código aberto (ver `FONTES.md`).

### Adicionado
- Gatilhos de diagnóstico de áudio e limpeza de fala na `description` da skill.
- `CHANGELOG.md`.
- README com recursos, requisitos e créditos.

### Mudado
- README com o endereço real do marketplace (`jvillalaz/sonoplasta`).

### Corrigido
- `normalizar.sh` podia deixar o true peak 0,1 a 0,2 dB acima do máximo; agora refaz com um teto interno mais baixo, como o `preparar-reels.sh`.

### Testes da 2.0
As perguntas 13 a 19 de `testes.md` cobrem as fases 8 a 11: áudio no WhatsApp, ducking, frequências na EQ, diagnóstico de vídeo, problema de mix pedido no master, presets do usuário e limpeza de fala para Reels.

## [1.9.0] - 2026-11-20

### Adicionado
- Limpeza automática de fala em `scripts/limpar-fala/`:
  - `transcrever.py`: transcrição local com tempo por palavra (faster-whisper, modelo `small`, idioma `pt`).
  - `marcar-cortes.py`: propõe cortes de silêncios, vícios de fala ("ãh", "né", "tipo" isolados) e repetições acidentais, com relatório legível e listas editáveis.
  - `aplicar-cortes.sh`: aplica só com `--aprovado`, corta imagem e som juntos com microfades de 10 ms, confere a sincronia e roda o diagnóstico na saída.
- `referencias/limpar-fala.md` com fluxo, ajustes por estilo e limitações.
- Regra no `SKILL.md`: nunca aplicar cortes sem a aprovação do usuário.
- Testes de marcação, da trava de aprovação, da sincronia e de estalos nas emendas.

## [1.8.0] - 2026-11-20

### Adicionado
- `referencias/modos.md`: captação, edição e limpeza, mixagem, masterização e entrega, cada uma com "faz / não faz".
- Presets do usuário: a skill procura `sonoplasta-presets.md` só na pasta de trabalho e dá prioridade a ele sobre os presets genéricos.
- Modelo comentado em `modelos/sonoplasta-presets.md`.

### Mudado
- Passo 2 do `SKILL.md`: identificar o modo do pedido e o princípio "processar remove defeitos, não caráter: na dúvida, processe menos".

## [1.7.0] - 2026-11-19

### Adicionado
- `scripts/preflight.sh`: container, trilhas e avisos (sem áudio, várias trilhas, áudio fora de 48 kHz em vídeo, canal vazio, saída insegura).
- `scripts/diagnosticar.sh`: preflight, loudness, clipping, DC offset, silêncios e mono, com resumo "bom / atenção".

### Mudado
- `normalizar.sh` e `preparar-reels.sh` avisam antes de sobrescrever a saída.
- O `SKILL.md` manda rodar o diagnóstico primeiro quando houver um arquivo.

## [1.6.0] - 2026-11-19

### Adicionado
- `referencias/frequencias.md`: faixas por instrumento, mascaramento e o que o celular reproduz.
- `referencias/codecs.md`: codecs, bitrates e comandos de conversão.
- `referencias/edicao-fala.md`: ordem de processamento, silêncios, emendas e ducking.
- `LICENCAS-TERCEIROS.md` com os avisos das fontes MIT e Apache-2.0.
- Níveis de normalização do Spotify em `entregas.md`.

### Documentação
- `FONTES.md`: levantamento das skills de áudio externas, com licenças e decisões de adoção (Fase 7).

## [1.5.0] - 2026-11-19

### Adicionado
- `referencias/generos-br.md`: gospel/worship, coral, sertanejo, MPB, funk e podcast em vídeo.
- `glossario.md` e `exemplos.md` (respostas modelo).
- `testes.md` com perguntas de revisão antes de cada versão.

## [1.4.0] - 2026-11-19

### Adicionado
- `referencias/presets.md`: cadeias de partida para voz falada e cantada, violão, bateria e baixo.
- `referencias/troubleshooting.md`: roteiros para os problemas mais comuns.

## [1.3.0] - 2026-11-19

### Adicionado
- `referencias/instagram-criadores.md`: Reels, TikTok, Shorts e criadores de conteúdo.
- `scripts/preparar-reels.sh`: normaliza e exporta em AAC 48 kHz com o vídeo copiado.

### Corrigido
- Normalização de arquivos acima de 0 LUFS.

## [1.2.0] - 2026-11-19

### Adicionado
- Scripts com ffmpeg: `medir.sh`, `normalizar.sh` (loudnorm em duas passadas) e `checar-mono.sh`, com testes.

## [1.1.0] - 2026-11-19

### Mudado
- `SKILL.md` virou um índice curto, com o conhecimento separado em `referencias/`.

### Adicionado
- `referencias/entregas.md`: fichas de entrega por plataforma, com status "oficial" ou "prática comum".

## [1.0.0] - 2026-11-19

### Adicionado
- Primeira versão da skill sonoplasta: persona, passos e conhecimento de captação, mixagem, masterização, loudness e entregas.
