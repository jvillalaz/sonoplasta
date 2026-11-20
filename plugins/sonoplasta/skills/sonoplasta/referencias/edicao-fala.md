# Edição e processamento de fala

Leia este arquivo antes de orientar a edição de voz falada (podcast, vídeo, aula, locução, Reels): ordem de processamento, corte de silêncios, emendas, ducking de música sob a voz e exportação de fala. Para cadeias por tipo de microfone, veja `referencias/presets.md` e `referencias/instagram-criadores.md`.

## Ordem de processamento

Processe nesta ordem. Cada etapa depende da anterior.

1. **Limpeza:**
   - De-click, de-plosive, de-hum e redução de ruído leve (6 a 10 dB no máximo).
   - Redução de ruído antes da compressão, porque a compressão sobe o ruído junto com as partes baixas.
2. **Corte de silêncios e edição:** tire pausas longas, tomadas repetidas e vícios de fala, com emendas suaves (ver "Emendas").
3. **EQ corretiva:**
   - HPF a 70 a 90 Hz (voz masculina) ou 100 a 120 Hz (feminina).
   - Corte de 2 a 4 dB entre 200 e 400 Hz se embolar.
   - Cortes estreitos em ressonâncias da sala.
4. **Compressão:** 3:1 a 4:1, attack de 5 a 15 ms, release de 80 a 150 ms e 3 a 6 dB de GR. Para voz com variação grande, use dois estágios leves (ver `referencias/presets.md`).
5. **EQ de cor:** +1,5 a +3 dB entre 2 e 5 kHz (inteligibilidade) e ar suave a partir de 10 kHz.
6. **De-esser:** 5 a 8 kHz, 3 a 5 dB de GR. Depois do realce de agudo.
7. **Nivelamento:**
   - Automação de volume ou clip gain nas frases que ficaram baixas ou altas.
   - Leveler automático, se houver, com moderação.
   - Meta: LRA de 3 a 6 LU.
8. **Limiter e loudness final:** teto de −1 dBTP e normalização para o destino (−16 LUFS para podcast e −14 LUFS para vídeo em redes, prática comum). Use `scripts/normalizar.sh` ou `scripts/preparar-reels.sh`.

A EQ corretiva vem antes da compressão (para o compressor não reagir a graves e ressonâncias inúteis) e a EQ de cor vem depois. É a mesma lógica do restante da skill.

## Corte de silêncios

- **O que cortar:** pausas acima de ~0,6 a 1 s que não têm intenção (o falante procurando a palavra, retomando o raciocínio).
- **O que manter:**
  - Pausas dramáticas, respiros antes de uma ideia nova e o ritmo natural do falante.
  - Deixe 150 a 300 ms de respiro em cada corte. Cortar tudo deixa a fala "metralhada" e cansativa.
- **Respirações:** abaixe 6 a 12 dB (não remova todas). Remover todas soa artificial.
- **Room tone:** mantenha o room tone contínuo por baixo da fala editada, para o fundo não ligar e desligar a cada corte.
- **Vícios de fala em português:**
  - Corte "é...", "ãh", "hum" e "tipo", "né", "então", "assim" quando estiverem **isolados** como hesitação, não quando fizerem parte da frase.
  - Repetição acidental ("o o", "que que") sai; repetição enfática ("muito, muito importante") fica.
  - Quando o falante diz a mesma ideia duas vezes depois de uma pausa (retomada), corte a primeira tentativa e mantenha a versão mais limpa.

Com ffmpeg, para listar os silêncios (início, fim e duração):

```bash
ffmpeg -hide_banner -nostats -i entrada.wav -af silencedetect=noise=-45dB:d=0.6 -f null - 2>&1 | grep silence_
```

- **Ruído do limiar:** ajuste `noise` ao ruído de fundo. Comece 10 a 15 dB acima do room tone medido (de −50 a −35 dB).
- **Corte automático:** remover os silêncios automaticamente (`silenceremove`) é rápido, mas não diferencia pausa de intenção. Prefira listar, revisar e cortar com aprovação: é o que faz o fluxo de `referencias/limpar-fala.md`.

## Emendas

- **Microfades:** 5 a 20 ms em cada corte, para evitar estalos (clique por corte fora do cruzamento por zero).
- **Crossfade entre trechos de fala:** 10 a 40 ms, com curva de potência igual (equal power), para a emenda não ter queda de volume no meio.
- **Corte na respiração ou entre palavras,** nunca no meio de uma sílaba. Consoantes como "p", "t" e "k" escondem bem um corte logo antes delas.
- **Mudança de tomada:** se o ruído de fundo ou a distância do microfone mudam entre tomadas, iguale com EQ e com room tone antes de emendar.
- **Confira ouvindo:** passar no medidor não garante que a emenda não aparece. Ouça cada corte em fone.

## Gates, "isolamento de voz" e tiques

- **Origem dos tiques:** noise gates e recursos de "isolamento de voz" do sistema (computador ou celular) cortam o sinal para zero digital sem fade. Quando a fala é nivelada ou comprimida depois, cada borda vira um tique ou estalo audível.
- **Na captação:** desligue o gate do gravador e o isolamento de voz do sistema. Trate o ruído na pós.
- **Na pós:** prefira um expander suave (3 a 6 dB de atenuação, release de 100 a 200 ms) a um gate que fecha por completo.
- **No arquivo final:** a codificação AAC pode reintroduzir degraus perto do silêncio. Confira o arquivo final codificado, não só o WAV intermediário.

## Ducking: música sob a voz

| Parâmetro | Ponto de partida | Observação |
|---|---|---|
| Nível da música na fala | 15 a 20 dB abaixo da voz (percebido) | Somando nível fixo e ducking. Música com letra precisa ficar mais baixa. |
| Redução do ducking | 4 a 8 dB | Quanto a música abaixa quando a voz entra. Até 10 a 12 dB em trilha densa. |
| Attack | 10 a 50 ms | Rápido o bastante para não engolir a primeira sílaba. |
| Hold | 100 a 300 ms | Evita que a música suba entre palavras. |
| Release | 300 a 800 ms | A música volta suave nas pausas. Release curto demais "bombeia". |
| Ratio (compressor com sidechain) | 4:1 a 10:1 | Com threshold ajustado para reagir à voz normal. |

Alternativas:
- **Automação manual** de volume na trilha: o resultado mais musical, ideal em vídeos curtos.
- **EQ dinâmica com sidechain:** abaixa só 1 a 4 kHz na trilha quando a voz fala, mantendo grave e brilho. Soa menos "bombeado".

Com ffmpeg (voz em `voz.wav` e trilha em `trilha.wav`):

```bash
ffmpeg -i voz.wav -i trilha.wav -filter_complex \
 "[1:a]volume=-12dB[mus];[0:a]aformat=channel_layouts=stereo,asplit=2[v][sc];[mus][sc]sidechaincompress=threshold=0.03:ratio=8:attack=20:release=500[duck];[v][duck]amix=inputs=2:normalize=0[mix]" \
 -map "[mix]" -ar 48000 -c:a pcm_s24le mix.wav
```

A voz é convertida para estéreo (`aformat`) para a mix não cair para mono quando a trilha é estéreo. Ajuste o `volume` da trilha e o `threshold` ouvindo. Depois, normalize o resultado com `scripts/normalizar.sh`.

## Filtros úteis do ffmpeg para fala

| Filtro | Para quê | Partida |
|---|---|---|
| `highpass=f=80` | HPF | 70 a 120 Hz conforme a voz |
| `afftdn=nf=-25` | Redução de ruído constante por FFT | `nf` mais baixo = mais agressivo. Comece em −25 e ouça. |
| `anlmdn` | Redução de ruído (non-local means) | Mais lento e de melhor qualidade que `afftdn`. Use valores baixos. |
| `deesser` | De-esser simples | Use com moderação. Um de-esser de DAW costuma ser melhor. |
| `acompressor=threshold=-18dB:ratio=3:attack=10:release=120` | Compressão | Equivale ao estágio de nivelamento |
| `speechnorm` / `dynaudnorm` | Nivelamento automático | Útil para rascunho. Pode bombear e subir o ruído entre falas. |
| `alimiter=limit=0.89` | Limitador de pico | 0,89 ≈ −1 dBFS de sample peak. Para true peak, use `scripts/normalizar.sh`. |

Redução de ruído com IA (separação de voz, por exemplo Demucs ou DeepFilterNet) funciona melhor que `afftdn` em ruído variável. Exige instalação à parte e baixa modelos: indique só como opção manual, com o usuário ciente.

## Exportação de fala

| Destino | Formato | Loudness (prática comum, ver `referencias/entregas.md`) |
|---|---|---|
| Master | WAV 48 kHz, 24 bits | Sem limitação final, para reaproveitar |
| Podcast (feed) | MP3 128 kbps estéreo ou 96 kbps mono, ou AAC | −16 LUFS (estéreo), cerca de −19 LUFS (mono), −1 dBTP |
| Vídeo (YouTube) | AAC 48 kHz 384 kbps dentro do MP4 | ~−14 LUFS, −1 dBTP |
| Reels, TikTok, Shorts | AAC 48 kHz, 256 a 320 kbps | ~−14 LUFS, −1 a −2 dBTP |
| WhatsApp e mensagens | AAC (M4A) ou MP3 | Voz clara e folga de pico. O app recomprime. |

Códigos ffmpeg de exportação em `referencias/codecs.md`.

Fontes: ideias de fluxo de edição, categorias de corte e o alerta sobre gates e AAC adaptados de `AudioEditor` (danielmiessler/personal_ai_infrastructure, MIT). Filtros de silêncio e de ruído adaptados de `claude-video` (MIT). Os avisos de licença estão em `LICENCAS-TERCEIROS.md`.
