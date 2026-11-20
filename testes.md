# Testes da skill sonoplasta

Perguntas reais para revisar as respostas da skill antes de subir a versão. Para cada pergunta, rode a skill (Claude Code ou claude.ai), compare a resposta com os critérios e anote o que faltou. Uma boa resposta segue o formato do `SKILL.md`: começa pelo diagnóstico, dá passos numerados, traz valores de partida e termina com "se não resolver, verifique:" quando for troubleshooting.

## Instagram e criadores

### 1. Voz baixa no Reels

> Meus Reels ficam com a voz mais baixa que a dos outros criadores. Gravo com lapela sem fio no celular e edito no CapCut.

Uma boa resposta precisa:
- Citar −14 LUFS e true peak de −1 a −2 dBTP como **prática comum**, não como regra oficial da Meta.
- Dar passos no CapCut (normalização de loudness, volume da música, realçar voz).
- Sugerir `scripts/preparar-reels.sh` se houver terminal, sem exigir.
- Recomendar a escuta no celular antes de postar.

### 2. Música em conta comercial

> Tenho uma conta comercial no Instagram. Posso usar música em alta nos meus Reels de publicidade?

Uma boa resposta precisa:
- Explicar que contas comerciais costumam ter acesso limitado à biblioteca por licenciamento.
- Citar a Sound Collection da Meta e música licenciada para uso comercial.
- Avisar que as regras mudam e precisam ser conferidas na central de ajuda.
- Não afirmar regras definitivas que a skill não pode garantir.

### 3. Estalos nos jump cuts

> Quando corto as pausas do vídeo aparece um "tec" em cada corte e o fundo muda de som. Como resolvo?

Uma boa resposta precisa:
- Indicar microfades de 5 a 20 ms em cada corte.
- Indicar room tone contínuo em uma trilha por baixo.
- Desaconselhar o gate e explicar o porquê.
- Explicar como igualar o ruído entre tomadas.

### 4. Primeiros segundos

> O que fazer no áudio dos primeiros segundos de um Reel para segurar quem está rolando o feed?

Uma boa resposta precisa:
- Dizer que a voz começa no primeiro quadro, sem silêncio nem respiração.
- Recomendar um "hit" no primeiro corte só quando fizer sentido.
- Pedir que a música entre baixa ou com fade curto, sem início mais baixo que o resto.
- Lembrar a legenda, já que muita gente assiste sem som.

## Vídeo, podcast e broadcast

### 5. Ruído de ventilador no podcast

> Gravei um episódio inteiro com um ventilador ligado. Dá para salvar?

Uma boa resposta precisa:
- Dizer com honestidade que nenhum plugin salva tudo.
- Indicar redução de ruído espectral treinada no ruído, com 6 a 10 dB e passadas leves.
- Alertar para os artefatos acima de ~12 dB de redução.
- Sugerir trilha leve para mascarar o resíduo.
- Explicar como evitar na próxima gravação.
- Terminar com "se não resolver, verifique:".

### 6. Podcast em vídeo com três pessoas

> Vamos gravar um podcast em vídeo com três pessoas na mesma sala. Que microfones e que fluxo usar?

Uma boa resposta precisa:
- Recomendar dinâmicos por pessoa, a 5 a 10 cm, em multitrack.
- Sugerir áudio de referência na câmera e claquete.
- Indicar automixer ou expander suave para o vazamento.
- Pedir nivelamento entre as vozes.
- Dar o alvo de −16 LUFS para atender ao YouTube e ao feed de áudio.

### 7. Comercial para TV

> Uma agência pediu um comercial de 30 s para TV aberta no Brasil. O que entrego?

Uma boa resposta precisa:
- Pedir o manual técnico da emissora antes de tudo.
- Citar a ABNT NBR 16313 e dizer que os valores devem ser confirmados com a emissora.
- Trazer uma ficha de entrega preenchida (48 kHz, 24 bits, versões, duração exata, slate e timecode).
- Marcar o −23 LKFS como referência de mercado, não como valor oficial confirmado.

## Música

### 8. Mix embolada

> Minha mix pop está embolada e a voz não aparece, mesmo alta.

Uma boa resposta precisa:
- Começar pelo arranjo (instrumentos na mesma região da voz).
- Indicar HPF nas faixas sem grave e corte entre 250 e 400 Hz.
- Sugerir EQ dinâmica com sidechain da voz.
- Indicar filtros nos retornos de reverb.
- Pedir comparação com uma referência no mesmo loudness.
- Terminar com "se não resolver, verifique:".

### 9. Master de funk alto demais

> Quero meu funk tão alto quanto os do topo das paradas. Masterizo a −5 LUFS?

Uma boa resposta precisa:
- Explicar que o streaming normaliza (Spotify por volta de −14 LUFS) e que o excesso de limitação soa pior depois.
- Citar o PLR e sugerir medir com `scripts/medir.sh`.
- Sugerir buscar peso com saturação e equilíbrio.
- Lembrar o true peak de −1 dBTP.
- Tratar o loudness alto do gênero como prática comum, sem proibir.

### 10. Coral em igreja

> Vou gravar um coral de 40 vozes numa igreja. Como microfonar e mixar?

Uma boa resposta precisa:
- Recomendar um par estéreo principal (ORTF, XY ou AB) com a posição.
- Tratar os spots por naipe como reforço, alinhados no tempo.
- Recomendar aproveitar a acústica da igreja.
- Pedir processamento mínimo e preservação da dinâmica.
- Citar o de-esser leve para a sibilância coletiva.

### 11. Fase na bateria

> O bumbo e a caixa soam ocos quando ligo os overheads.

Uma boa resposta precisa:
- Diagnosticar problema de fase.
- Pedir para checar a polaridade de cada par e alinhar no tempo (1 ms ≈ 34 cm).
- Citar a regra 3:1.
- Lembrar o PDC e os plugins.
- Sugerir `scripts/checar-mono.sh`.
- Terminar com "se não resolver, verifique:".

## Entrega

### 12. Atmos para distribuidora

> A distribuidora pediu a versão em Dolby Atmos do meu single. Quais especificações sigo?

Uma boa resposta precisa:
- Citar −18 LKFS, −1 dBTP, ADM BWF a 48 kHz e 24 bits.
- Explicar a conferência do binaural e do downmix.
- Recomendar a âncora frontal (voz, bumbo, caixa e baixo) e evitar grave nos canais de altura.
- Pedir a confirmação da especificação com a distribuidora.
- Usar o formato de ficha de entrega.
