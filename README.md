<p align="center">
  <img src="docs/icone.svg" width="128" height="128" alt="Ícone da sonoplasta: três faders de mesa de som sobre uma onda sonora">
</p>

<h1 align="center">Sonoplasta</h1>

<p align="center">
  <b>Um engenheiro de áudio sênior e produtor musical dentro do Claude.</b>
</p>

<p align="center">
  Captação, voz para vídeo, mixagem estéreo e Dolby Atmos, masterização, loudness e entregas para
  YouTube, Instagram Reels, TikTok, podcast, TV, comerciais e discos. Responde em português do
  Brasil, com valores de partida concretos, e no Claude Code também mede e corrige os seus
  arquivos com ffmpeg.
</p>

<p align="center">
  <a href="https://github.com/jvillalaz/sonoplasta/releases/latest"><img alt="Versão" src="https://img.shields.io/github/v/release/jvillalaz/sonoplasta?style=flat-square&label=vers%C3%A3o&color=0b7385"></a>
  <img alt="Claude Code e claude.ai" src="https://img.shields.io/badge/Claude%20Code%20%C2%B7%20claude.ai-skill-d97757?style=flat-square">
  <img alt="Idioma: português do Brasil" src="https://img.shields.io/badge/idioma-pt--BR-2bb3a3?style=flat-square">
  <img alt="Scripts com ffmpeg" src="https://img.shields.io/badge/scripts-ffmpeg%20%C2%B7%20bash-16324f?style=flat-square&logo=ffmpeg">
  <a href="LICENSE"><img alt="Licença: MIT" src="https://img.shields.io/badge/licen%C3%A7a-MIT-blue?style=flat-square"></a>
</p>

<p align="center">
  <a href="#o-que-faz">O que faz</a> ·
  <a href="#recursos">Recursos</a> ·
  <a href="#instalar">Instalar</a> ·
  <a href="#como-usar">Como usar</a> ·
  <a href="#scripts">Scripts</a> ·
  <a href="#seus-presets">Seus presets</a> ·
  <a href="#como-%C3%A9-feita">Como é feita</a> ·
  <a href="#vers%C3%B5es">Versões</a> ·
  <a href="#licen%C3%A7a-e-cr%C3%A9ditos">Licença</a>
</p>

## O que faz

Você descreve o problema do jeito que fala com um técnico de som, e a sonoplasta responde como um:
começa pela causa mais provável, dá a ordem de trabalho e os valores de partida (frequência, ratio,
attack/release, LUFS, true peak) e separa o que é especificação oficial do que é prática comum.

<table>
  <tr>
    <td width="50%" valign="top">

**Você pergunta**

> Estou mixando uma música pop com voz, violão, piano, baixo e bateria. A mix está embolada e a voz
> não aparece, mesmo alta. Uso Reaper.

**A sonoplasta responde** (trecho)

> Voz alta que não aparece quase sempre é mascaramento em 200 a 500 Hz e em 2 a 5 kHz, e muitas
> vezes começa no arranjo [...]
>
> 2. **HPF em tudo que não é grave:** violão a 120 a 150 Hz, piano a 100 a 150 Hz, voz a 80 a
>    100 Hz.
> 3. **Lama:** corte de 2 a 4 dB entre 250 e 400 Hz no violão e no piano (Q por volta de 1).
> 4. **Espaço para a voz:** EQ dinâmica em 2 a 4 kHz no bus de violão e piano, com sidechain da voz.
>
> No Reaper, o ReaEQ não tem banda dinâmica. Use o ReaXcomp em uma faixa [...]

</td>
    <td width="50%" valign="top">

**Você pergunta**

> Uma agência pediu o áudio de um comercial de 30 segundos para TV aberta no Brasil. O que preciso
> entregar?

**A sonoplasta responde** (trecho)

> O primeiro passo é pedir à agência o manual técnico de recebimento da emissora [...]
>
> ```
> FICHA DE ENTREGA: comercial 30 s / TV aberta (Brasil)
> - Loudness integrado: conforme ABNT NBR 16313 e
>   emissora; referência de mercado −23 LKFS
>   (prática comum)
> - Sample rate: 48 kHz
> - Bit depth / codec: 24 bits PCM
> - Versões e stems: mix completa, versão sem
>   locução, trilha e efeitos separados
> - Confirmar com: manual técnico da emissora
> ```

</td>
  </tr>
</table>

<sub>Trechos dos modelos de resposta em <a href="plugins/sonoplasta/skills/sonoplasta/exemplos.md"><code>exemplos.md</code></a>, que calibram o formato e o nível de detalhe da skill.</sub>

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

### Por área

- **Captação:** escolha e posição de microfone, ganho, sala, fase entre microfones e room tone.
- **Voz para vídeo:** lapela e shotgun, redução de ruído sem artefatos, ducking da trilha e edição de
  fala (silêncios, emendas, respiração).
- **Mixagem:** HPF e mascaramento por faixa de frequência, compressão em série, buses, envios de
  reverb e delay, pan e conferência em mono e em referência.
- **Dolby Atmos:** beds e objetos, binaural e entrega.
- **Masterização:** cadeia, limiter, true peak, dither e versões por destino.
- **Loudness e medição:** LUFS integrado, short-term e momentary, LRA, true peak e como cada
  plataforma normaliza.
- **Entregas:** fichas com loudness, formato, sample rate, canais, stems e o que confirmar com quem
  recebe, para streaming, redes sociais, TV, comerciais, CD e vinil.

Valores de loudness e especificações de plataformas mudam: a skill sempre indica onde confirmar na
documentação oficial.

## Instalar

### Claude Code

```
/plugin marketplace add jvillalaz/sonoplasta
/plugin install sonoplasta@sonoplasta
```

A skill entra sozinha quando o assunto for áudio. Também dá para chamar direto com
`/sonoplasta:sonoplasta`. Para atualizar: `/plugin marketplace update sonoplasta`.

### claude.ai (navegador ou app)

1. Baixe o `sonoplasta.zip` da [versão mais recente](https://github.com/jvillalaz/sonoplasta/releases/latest).
2. Abra **Customize > Skills** e clique em **+ > Create skill > Upload a skill**.
3. Envie o ZIP.

No claude.ai a skill orienta, mas não roda os scripts. Para medir um arquivo, use o seu medidor de
loudness (ex.: Youlean Loudness Meter) e passe os valores na conversa.

## Como usar

Exemplos de pedidos:

- "Minha voz no YouTube está abafada. Gravo com um SM7B numa sala sem tratamento."
- "Quais as especificações de entrega para um comercial de TV?"
- "Analisa o áudio desse vídeo antes de eu postar." (Claude Code, com o arquivo na pasta)
- "Deixa esse vídeo pronto para o Reels." (Claude Code)
- "Tira os silêncios e os 'ãh' desse vídeo." (Claude Code; os cortes só são aplicados depois que você
  aprovar o relatório)

Quanto mais contexto, melhor a resposta: destino (YouTube, TV, Spotify), equipamento, DAW ou editor
e o que você já tentou.

## Scripts

No Claude Code, a skill roda os scripts sozinha quando há um arquivo na pasta. Eles também podem ser
rodados à mão, a partir da pasta da skill:

```bash
bash scripts/diagnosticar.sh video.mp4 --alvo -14     # diagnóstico completo
bash scripts/normalizar.sh episodio.wav -16           # normaliza para -16 LUFS
bash scripts/preparar-reels.sh video.mp4              # -14 LUFS, -1,5 dBTP, AAC 48 kHz
```

| Script | O que faz |
|---|---|
| `preflight.sh` | Confere container, trilhas e sample rate, e avisa sobre áudio ausente, canal vazio e saída insegura |
| `diagnosticar.sh` | Preflight, loudness, clipping, DC offset, silêncios e mono, com resumo "bom / atenção" |
| `medir.sh` | Loudness integrado, LRA e true peak |
| `checar-mono.sh` | Compatibilidade mono e correlação entre canais |
| `normalizar.sh` | Loudnorm em duas passadas para o alvo pedido, respeitando o true peak |
| `preparar-reels.sh` | Normaliza e exporta em AAC 48 kHz com o vídeo copiado |
| `limpar-fala/` | Transcreve, propõe cortes e aplica só com `--aprovado` |

### Requisitos

Só a orientação não precisa de nada. Para os scripts:

| Para | Precisa de | Como instalar |
|---|---|---|
| Diagnóstico, medição, normalização e Reels | `ffmpeg` (com `ffprobe`) e `bash` | Windows: `winget install --id Gyan.FFmpeg` e Git Bash · macOS: `brew install ffmpeg` · Linux: `sudo apt install ffmpeg` |
| Limpeza de fala | Python 3 e [faster-whisper](https://github.com/SYSTRAN/faster-whisper) | `pip install faster-whisper` (no Windows: `py -m pip install faster-whisper`) |

A transcrição roda no seu computador: o áudio não é enviado para nenhum serviço. Na primeira vez, a
faster-whisper baixa o modelo (cerca de 500 MB).

Detalhes de cada script em [`referencias/scripts.md`](plugins/sonoplasta/skills/sonoplasta/referencias/scripts.md)
e da limpeza de fala em [`referencias/limpar-fala.md`](plugins/sonoplasta/skills/sonoplasta/referencias/limpar-fala.md).

## Seus presets

Para a skill usar seus plugins, suas cadeias e seus alvos:

1. Copie o [modelo](plugins/sonoplasta/skills/sonoplasta/modelos/sonoplasta-presets.md) para a pasta
   do seu projeto com o nome `sonoplasta-presets.md`.
2. Preencha só o que quiser. O que você não definir continua vindo dos presets genéricos.

No Claude Code, a skill procura esse arquivo só na pasta de trabalho, nunca em pastas pessoais. No
claude.ai, cole o conteúdo na conversa. Os avisos de segurança e as especificações oficiais continuam
valendo mesmo com presets próprios.

## Como é feita

O `SKILL.md` é um índice curto com a persona e os passos de trabalho; o conhecimento de cada assunto
fica em `referencias/` e só é lido quando o pedido precisa dele.

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
docs/icone.svg                       ícone do projeto
scripts/empacotar.sh                 gera o ZIP para o claude.ai
testes.md                            perguntas para revisar a skill antes de cada versão
FONTES.md                            fontes externas, licenças e o que foi aproveitado
CHANGELOG.md                         mudanças de cada versão
```

### Desenvolvimento

- Ao criar um arquivo em `referencias/`, adicione-o ao índice do `SKILL.md`.
- Testes dos scripts: `bash plugins/sonoplasta/skills/sonoplasta/scripts/testes/rodar-testes.sh`
  (gera sinais de teste e confere todos os scripts).
- Antes de cada versão, revise as respostas da skill para as perguntas de [`testes.md`](testes.md).
- Ao mudar algo relevante, suba a `version` em `plugins/sonoplasta/.claude-plugin/plugin.json`,
  registre no [`CHANGELOG.md`](CHANGELOG.md) e valide com `claude plugin validate .`.
- Gere o ZIP com `./scripts/empacotar.sh` (sai em `dist/`, que não vai para o git).

As regras de edição para o Claude Code estão no [`CLAUDE.md`](CLAUDE.md). Sugestões e problemas são
bem-vindos nas [issues](https://github.com/jvillalaz/sonoplasta/issues).

## Versões

A [versão mais recente](https://github.com/jvillalaz/sonoplasta/releases/latest) traz o
`sonoplasta.zip` para o claude.ai, e [todas as versões](https://github.com/jvillalaz/sonoplasta/releases),
da 1.0.0 em diante, têm as notas de cada uma. O histórico completo está no
[`CHANGELOG.md`](CHANGELOG.md).

## Licença e créditos

A sonoplasta é distribuída sob a [licença MIT](LICENSE).

A versão 2.0 aproveita ideias de outras skills de áudio de código aberto, todas reescritas em
português e adaptadas ao padrão da sonoplasta. O levantamento, as licenças e o que entrou de cada uma
estão em [`FONTES.md`](FONTES.md). Os avisos de licença exigidos (MIT e Apache-2.0) estão em
[`LICENCAS-TERCEIROS.md`](plugins/sonoplasta/skills/sonoplasta/LICENCAS-TERCEIROS.md), que também vai
dentro do ZIP.
