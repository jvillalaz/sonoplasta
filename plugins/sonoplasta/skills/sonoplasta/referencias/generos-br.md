# Gêneros e formatos brasileiros

Leia este arquivo antes de responder sobre gravação, mixagem ou masterização de gospel/worship, coral, sertanejo, MPB, funk ou podcast em vídeo. Combine com `referencias/presets.md` (cadeias por fonte) e `referencias/mixagem.md`.

As características abaixo são tendências do mercado (**prática comum**), não regras. Pergunte sempre pela referência sonora do artista: ela vale mais que o gênero.

## Gospel / worship

- **Estética:** voz principal à frente e emocional, banda grande e larga (pads, guitarras ambientes com delay e reverb, teclados), crescendos longos até o clímax.
- **Dinâmica:** o arranjo cresce do íntimo ao clímax. Preserve isso com automação, sem achatar com compressão no master. LRA de 6 a 10 LU é comum em faixas de adoração.
- **Voz:** ver "Voz gospel / worship" em `referencias/presets.md`. Automatize envios de reverb e delay para crescer no refrão e no clímax.
- **Pads e guitarras ambientes:** HPF a 150 a 300 Hz e LPF a 8 a 12 kHz para não cobrir a voz. Mantenha-os largos e atrás.
- **Ao vivo (culto, gravação de DVD):**
  - Grave microfones de público (par estéreo voltado para a congregação) para trazer o canto coletivo nos refrões.
  - Cuidado com o vazamento do PA e dos monitores nos microfones de voz.
  - Planeje o multitrack com folga de canais e uma gravação de segurança.
- **Masterização:** loudness moderado (cerca de −10 a −12 LUFS integrado em faixas de banda cheia, prática comum), priorizando o impacto do clímax sobre o volume médio.

## Coral

- **Microfonação:**
  - Par estéreo principal (ORTF, XY ou AB espaçado) a 2 a 4 m do coro, 1 a 2 m acima das cabeças, cobrindo todos os naipes.
  - Spots por naipe (soprano, contralto, tenor, baixo) só como reforço, bem abaixo do par principal e alinhados no tempo com ele (cerca de 1 ms a cada 34 cm de diferença).
- **Sala:** a acústica faz parte do som. Prefira igrejas e salas com reverberação natural de 1,5 a 2,5 s, em vez de reverb artificial pesado.
- **Equilíbrio dos naipes:** acerte primeiro na posição do coro e com o regente. Na mix, ajuste com os spots, sem EQ agressiva.
- **Processamento mínimo:**
  - HPF a 60 a 80 Hz (ruído de palco, passos, ar-condicionado).
  - EQ suave se a sala embolar (−2 dB entre 200 e 400 Hz).
  - Compressão leve ou nenhuma: a dinâmica é a expressão do coro.
- **Sibilância coletiva:** os "s" de dezenas de vozes chegam fora de sincronia e soam como chiado. Um de-esser leve no par principal (2 a 3 dB) ajuda.
- **Masterização:** preserve a dinâmica (−16 a −14 LUFS integrado é comum, prática comum). Não limite para competir com pop.

## Sertanejo

- **Estética:** vozes muito à frente, brilhantes e presentes, com banda pop/country moderna. É comum masters altos e mix densa.
- **Duplas:** primeira e segunda voz cantando em terças ou sextas.
  - Equilibre as duas quase no mesmo nível, com a primeira voz levemente à frente (1 a 2 dB).
  - Abra-as ligeiramente no estéreo (10 a 20% para cada lado) ou deixe as duas no centro, conforme a referência.
  - Alinhe e afine as duas juntas: é a assinatura do gênero.
- **Instrumentos característicos:**
  - Sanfona: HPF a 100 a 150 Hz, corte em 300 a 500 Hz se embolar e presença em 2 a 4 kHz.
  - Viola caipira: brilho em 5 a 10 kHz, HPF a 120 Hz.
  - Violão base.
- **Voz:** cadeia pop (ver `referencias/presets.md`), com delays e reverbs perceptíveis nas pontas de frase e automação de volume detalhada.
- **Ao vivo (DVD):** público alto nos refrões, comunicação do artista com a plateia e microfones de ambiente bem posicionados.
- **Masterização:** loudness alto é comum (cerca de −8 a −10 LUFS integrado, prática comum). Lembre que o streaming normaliza: busque densidade sem esmagar os transientes da bateria.

## MPB

- **Estética:** timbres acústicos naturais, voz intimista e próxima, dinâmica preservada e arranjos com espaço.
- **Instrumentos:**
  - Violão de nylon: condensador a 20 a 30 cm da junção do braço com o corpo, HPF a 80 Hz e pouca compressão (2:1, 2 a 3 dB de GR).
  - Percussão brasileira (pandeiro, surdo, ganzá, tamborim, cuíca): microfone próprio, preservando os transientes, sem compressão rápida.
  - Contrabaixo acústico ou baixo elétrico com timbre redondo.
- **Voz:** perto do microfone, com compressão suave (óptica, 2 a 4 dB de GR), sem brilho exagerado e com reverb discreto (sala ou plate curto).
- **Masterização:** loudness moderado (cerca de −12 a −14 LUFS integrado, prática comum) e LRA mais alto. O streaming vai normalizar, e a dinâmica é parte do gênero.

## Funk brasileiro

- **Estética:** grave muito presente (808, sub e batida do tamborzão), voz seca e à frente, arranjos minimalistas e masters altos. O andamento varia: em torno de 130 BPM no funk carioca e paulista e até 150 BPM em vertentes mais rápidas (prática comum).
- **Grave:**
  - Escolha o 808 ou o sub afinado no tom da música.
  - Deixe o bumbo e o 808 sem disputa: sidechain do bumbo no 808 (2 a 4 dB de GR) ou escolha um dos dois para o sub-grave.
  - Tudo abaixo de ~120 Hz em mono.
- **Celular e paredão:** o funk é ouvido em celular e em som automotivo ou paredão.
  - Para o celular, sature o 808 para ele aparecer (ver "Grave que some no celular" em `referencias/troubleshooting.md`).
  - Para o carro e o paredão, controle o sub abaixo de 40 Hz para não distorcer.
- **Voz:**
  - Seca e próxima, compressão firme (FET, 5 a 8 dB de GR), presença em 3 a 5 kHz e de-esser firme.
  - Efeitos em pontos específicos (delay em palavras finais, filtro, pitch).
  - Afinação como efeito, quando for o estilo.
- **Masterização:** é comum loudness muito alto (−6 a −8 LUFS integrado, prática comum). Avise que no streaming isso será normalizado e que clipping em excesso soa pior depois da normalização. Busque o "peso" com saturação e equilíbrio, não só com limiter.

## Podcast em vídeo

- **Microfones:**
  - Um dinâmico por pessoa, a 5 a 10 cm da boca, com a mesma marca e posição para todos. Dinâmicos rejeitam melhor o vazamento entre participantes.
  - Grave cada microfone em trilha separada (multitrack), com uma gravação de segurança.
- **Câmera:** grave o áudio também na câmera (referência para sincronizar) e use claquete ou palma no início.
- **Convidado remoto:** mix-minus para que ele não ouça a própria voz com atraso. Peça para ele gravar localmente (double-ender) quando possível.
- **Vazamento:** use automixer ou expander suave em cada microfone (3 a 6 dB de atenuação quando a pessoa não fala). Na edição, limpe o crosstalk nos trechos de fala única.
- **Nivelamento:**
  - Cada voz com a cadeia de voz falada de `referencias/presets.md`.
  - Ajuste para que todas as vozes tenham o mesmo loudness percebido (diferença de até 1 LU entre participantes).
- **Trilha:** vinheta de abertura e transições no mesmo loudness da fala, nunca mais altas.
- **Entrega:** vídeo para YouTube por volta de −14 a −16 LUFS e feed de áudio a −16 LUFS (ver `referencias/entregas.md`). Uma mix a −16 LUFS atende aos dois. Cortes para Reels seguem `referencias/instagram-criadores.md`.
