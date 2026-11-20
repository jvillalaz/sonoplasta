# Presets de partida por fonte

Leia este arquivo antes de sugerir uma cadeia de processamento para voz falada, voz cantada (pop, gospel/worship), violão, bateria ou baixo. Para voz de Reels e criadores, use os presets de `referencias/instagram-criadores.md`.

Estes presets não dependem de marca de plugin. Os nomes entre parênteses ("estilo 1176", "estilo LA-2A") indicam o comportamento do processador, e qualquer equivalente serve. São pontos de partida: ajuste ouvindo, em contexto e no loudness final. Comece sempre pela fonte (microfone, posição, performance) antes de processar, como manda o passo 2 do `SKILL.md`.

Se a pasta de trabalho tiver um `sonoplasta-presets.md` do usuário, as cadeias, os plugins e os alvos dele têm prioridade sobre estes (ver "Presets do usuário" no `SKILL.md`).

Convenções: GR = redução de ganho. Frequências e ganhos são faixas: comece pelo meio e mova até soar certo.

## Voz falada (YouTube, podcast, locução)

1. **Limpeza:** de-click, de-plosive e redução de ruído leve (6 a 10 dB no máximo). Remova respirações altas só onde atrapalham. Não remova todas.
2. **HPF:** 70 a 90 Hz (voz masculina) ou 100 a 120 Hz (voz feminina), 12 a 18 dB/oitava.
3. **EQ corretiva:** −2 a −4 dB entre 200 e 400 Hz se estiver embolada. Corte estreito (Q 4 a 8) em ressonâncias da sala, se houver.
4. **Compressor 1 (picos, estilo FET):** ratio 4:1, attack 1 a 5 ms, release 50 a 100 ms, 3 a 5 dB de GR nos picos.
5. **Compressor 2 (nivelamento, estilo óptico):** 2 a 4 dB de GR constante.
6. **EQ de cor:** +1,5 a +3 dB entre 2 e 5 kHz (inteligibilidade) e shelf de +1 a +2 dB a partir de 10 kHz (ar).
7. **De-esser:** 5 a 8 kHz, 3 a 5 dB de GR nos "s".
8. **Limiter:** teto de −1 dBTP e 1 a 2 dB de GR no máximo. O loudness final se acerta na normalização.

Meta: LRA de 3 a 6 LU e voz estável no fone e no celular.

## Voz cantada pop

1. **Edição:** comping, afinação (transparente, a menos que o efeito seja o estilo) e alinhamento de dobras e backing vocals.
2. **HPF:** 80 a 100 Hz. Nas dobras e backs, 150 a 250 Hz.
3. **EQ corretiva:** −2 a −3 dB entre 250 e 400 Hz. EQ dinâmica entre 2 e 5 kHz para ressonâncias que só aparecem em notas fortes (2 a 4 dB de redução quando ativa).
4. **Compressão em série:** FET com ratio 4:1 a 8:1, attack rápido e 3 a 5 dB de GR, seguido de óptico com 2 a 4 dB de GR.
5. **EQ de cor:** +2 dB entre 3 e 5 kHz e shelf de +2 a +4 dB a partir de 10 a 12 kHz (pop pede voz brilhante e à frente).
6. **De-esser:** 5 a 9 kHz, 3 a 6 dB de GR. Depois do brilho, não antes.
7. **Saturação:** leve (mix de 10 a 25%) para densidade e presença.
8. **Envios:**
   - Plate curto: decay de 1 a 1,8 s, pre-delay de 40 a 100 ms, HPF a 300 Hz e LPF a 8 kHz no retorno.
   - Delay de 1/4 ou 1/8 sincronizado, com feedback de 15 a 25% e filtrado.
   - Slapback opcional de 80 a 120 ms.
9. **Automação de volume:** palavra por palavra nos trechos em que a voz some. Funciona melhor que comprimir mais.

## Voz gospel / worship

Mesma base da voz pop, com estes ajustes:

- **Dinâmica:** o canto vai do sussurro ao clímax. Use menos compressão fixa e mais automação de volume. Um compressor de nivelamento lento (óptico, 2 a 3 dB de GR) antes do FET ajuda a controlar a variação grande.
- **Clímax:** prepare automação de EQ e de compressão para as partes mais fortes. Picos em 2 a 4 kHz ficam agressivos em voz alta: use EQ dinâmica com mais redução (3 a 5 dB).
- **Ambiência:** hall ou plate maior que no pop, com decay de 2 a 3 s e pre-delay de 60 a 120 ms. Automatize o envio para crescer nos refrões e no clímax.
- **Coros e backing vocals:** HPF a 150 a 250 Hz. Agrupe em um bus com compressão leve (2 a 3 dB de GR, attack lento) para colar o grupo. Deixe o bus 3 a 6 dB abaixo da voz principal e um pouco mais atrás (mais reverb, menos 3 a 5 kHz).
- **Ao vivo (cultos, gravação de DVD):** o vazamento da banda nos microfones de voz pede gate ou expander suave (3 a 6 dB de atenuação, nunca fechando por completo) e cuidado com fase entre os microfones dos cantores.

## Violão

1. **Microfonação:** condensador a 15 a 30 cm, apontado para onde o braço encontra o corpo (por volta da 12ª a 14ª casa), não para a boca. Para estéreo, use um segundo microfone perto do cavalete ou um par XY. Confira a fase entre microfone e captador.
2. **HPF:** 80 a 100 Hz quando o violão está solo ou dedilhado, e 120 a 200 Hz quando é base em mix cheia.
3. **EQ corretiva:** −2 a −4 dB entre 150 e 300 Hz (ronco do corpo) e corte estreito em ressonâncias entre 800 Hz e 1,2 kHz se soar "nasal".
4. **Compressor:** ratio 2:1 a 3:1, attack de 10 a 30 ms (deixe o ataque da palheta passar), release de 100 a 200 ms e 2 a 4 dB de GR.
5. **EQ de cor:** +1 a +3 dB entre 5 e 10 kHz para brilho das cordas e +1 dB por volta de 2 a 3 kHz para definição.
6. **Captador (piezo) junto com o microfone:** use o captador só como reforço de grave e ataque, bem abaixo do microfone, e alinhe no tempo. O piezo sozinho soa duro: corte 2 a 3 dB entre 1 e 3 kHz nele.

## Bateria

**Bumbo**
- HPF a 30 a 40 Hz.
- Corpo: +2 a +4 dB entre 50 e 80 Hz.
- Papelão: −3 a −6 dB entre 250 e 450 Hz.
- Ataque (beater): +2 a +4 dB entre 2 e 5 kHz.
- Compressor: ratio 4:1, attack de 10 a 30 ms (deixe o ataque passar), release no tempo da música e 3 a 6 dB de GR.
- Bumbo in/out: alinhe a fase entre os dois.

**Caixa**
- HPF a 80 a 100 Hz.
- Corpo: +2 a +3 dB entre 180 e 250 Hz.
- Ring: corte estreito entre 400 e 900 Hz, se houver.
- Estalo: +2 a +3 dB entre 4 e 6 kHz.
- Compressor: ratio 4:1, attack de 5 a 20 ms e 3 a 5 dB de GR.
- Esteira (caixa embaixo): polaridade invertida em relação à caixa de cima, HPF a 200 a 300 Hz e bem mais baixa que a de cima.

**Tons**
- HPF a 60 a 80 Hz (surdo) ou 80 a 120 Hz (tons).
- Corte de 300 a 600 Hz se estiver embolado.
- Ataque entre 3 e 5 kHz.
- Gate ou edição do vazamento entre as viradas.

**Overheads**
- HPF a 100 a 200 Hz, conforme o quanto de corpo vier deles.
- Corte suave de 2 a 3 dB entre 2 e 4 kHz se os pratos agredirem.
- Confira a fase dos overheads contra a caixa e o bumbo.

**Room**
- Compressão pesada e paralela (10 dB ou mais de GR) misturada por baixo.

**Bus de bateria**
- Compressor estilo VCA com ratio 2:1 a 4:1, attack de 10 a 30 ms, release automático ou no tempo e 2 a 3 dB de GR.
- Compressão paralela pesada, com 10 dB ou mais de GR, misturada a gosto (ver `referencias/mixagem.md`).

## Baixo

1. **Fontes:** DI e amplificador ou simulador. Alinhe a fase entre DI e microfone (atraso de 1 a 3 ms no microfone é comum).
2. **HPF:** 30 a 40 Hz para tirar o subsônico.
3. **EQ:** fundamental entre 60 e 100 Hz (escolha uma região que não brigue com o bumbo), −2 a −4 dB entre 200 e 300 Hz se estiver embolado e +2 a +4 dB entre 700 Hz e 1,5 kHz para definição em alto-falante pequeno.
4. **Compressor:** ratio 4:1, attack de 10 a 30 ms, release de 80 a 150 ms e 4 a 6 dB de GR. Um segundo estágio leve (2 dB) ajuda a nivelar notas.
5. **Saturação:** distorção leve em paralelo (bus com HPF a 300 Hz e saturação forte, misturado por baixo). Faz o baixo aparecer no celular.
6. **Bumbo e baixo:** sidechain leve do bumbo no baixo (1 a 3 dB de GR, attack e release rápidos) ou EQ dinâmica no baixo acionada pelo bumbo na região do corpo do bumbo.
7. **Mono:** mantenha o baixo em mono abaixo de ~120 Hz.
