# Roteiros de troubleshooting

Leia este arquivo antes de diagnosticar um problema de som: voz abafada, sibilância, ruído de fundo, mix embolada, grave que some no celular, fase entre microfones ou mix que soa baixa depois da normalização.

Como usar: siga os passos na ordem, um de cada vez, ouvindo depois de cada mudança. Os primeiros passos atacam a origem, os últimos o processamento. Quando o usuário tiver o arquivo e houver terminal, meça antes com os scripts (`referencias/scripts.md`). Termine a resposta com o bloco "se não resolver, verifique:" do roteiro.

## Voz abafada

1. **Ouça a origem sem processamento.** Se a voz crua já é abafada, o problema é de captação. Plugins vêm depois.
2. **Microfone e posição:**
   - Lapela coberta por roupa ou apontada para baixo perde agudo. Ajuste a posição.
   - Microfone fora do eixo (de lado) também perde agudo. Aponte para a boca.
   - Muito perto, o efeito de proximidade engorda a voz e cobre a clareza.
3. **Sala:** reflexões de paredes nuas embolam a região de 200 a 500 Hz. Use cortinas, sofá, um edredom atrás da pessoa ou grave mais perto do microfone.
4. **Lama:** corte de 2 a 4 dB entre 200 e 400 Hz (Q 1 a 1,5). Procure a frequência exata varrendo com um boost estreito e corte onde soar pior.
5. **Presença e ar:** +2 a +3 dB entre 2 e 5 kHz e shelf de +2 dB a partir de 10 kHz. Se o ganho realçar ruído, a captação era o problema.
6. **Cadeia:**
   - De-esser exagerado ou redução de ruído forte tiram agudo. Diminua e compare.
   - Compressão com attack lento demais pode deixar o início das sílabas sem definição.
7. **Mix:** música ou trilha ocupando 2 a 5 kHz mascara a voz. Corte 2 a 3 dB nessa faixa na trilha ou use EQ dinâmica com sidechain da voz.

Se não resolver, verifique:
- Se o arquivo exportado está em codec de baixa qualidade (AAC/MP3 abaixo de 128 kbps corta agudo).
- Se a sample rate do projeto bate com a do arquivo (uma conversão errada pode filtrar o agudo).
- Se o monitor ou fone de referência não está escuro (compare com uma referência comercial).
- Se o microfone não está com defeito ou com a cápsula suja (teste outro microfone).

## Sibilância

1. **Posição:** grave com o microfone ligeiramente fora do eixo (apontado para o queixo ou o canto da boca) e use pop filter. Isso reduz "s" e plosivas na origem.
2. **Microfone:** condensadores com pico em 6 a 10 kHz exageram a sibilância. Com voz muito sibilante, prefira um dinâmico ou um condensador mais escuro.
3. **Ordem da cadeia:** aplique o de-esser depois do boost de agudo e da compressão. Compressão com attack rápido realça os "s".
4. **De-esser:**
   - Encontre a frequência, normalmente 5 a 8 kHz em voz masculina e 6 a 10 kHz em feminina, ouvindo o sinal de detecção.
   - Comece com 3 a 6 dB de GR só nos "s".
   - Em voz cantada, o modo split-band soa mais natural que o wideband.
5. **Manual:** em casos piores, abaixe cada "s" com automação de clip gain (3 a 6 dB). É o resultado mais natural.
6. **Envios:** os "s" no reverb e no delay incomodam mais que na voz seca. Coloque um de-esser antes do envio ou um LPF a 6 a 8 kHz no retorno.

Se não resolver, verifique:
- Se o limiter ou a compressão do master não estão realçando os agudos.
- Se a sibilância não vem da conversão para AAC/MP3 (compare o WAV com o arquivo final).
- Se o fone ou monitor não tem pico de agudo (compare em outro sistema).
- Se não há dobras ou backing vocals com "s" fora de sincronia somando com a voz principal.

## Ruído de fundo

1. **Identifique o tipo:**
   - Constante (ar-condicionado, chiado, hum de 50/60 Hz): é o mais fácil de tirar.
   - Variável (rua, pessoas, trânsito): é difícil e às vezes não sai.
   - Clique ou estalo: use de-click.
2. **Na próxima gravação:** desligue a fonte de ruído, aproxime o microfone (cada vez que a distância cai pela metade, a voz sobe ~6 dB em relação ao ruído) e grave room tone.
3. **Hum:** filtros notch em 50 ou 60 Hz e harmônicos (de-hum). Em hum causado por loop de terra, resolva o cabo ou a alimentação.
4. **Ruído constante:**
   - Redução de ruído espectral treinada no room tone (iZotope RX Spectral De-noise, Waves Clarity ou equivalente).
   - Comece com 6 a 10 dB de redução. Acima de ~12 dB aparecem artefatos ("água", "voz de robô").
   - Duas passadas leves soam melhor que uma forte.
5. **Ruído variável:** use ferramentas de separação de voz (dialogue isolate) com mix de 50 a 80%, não 100%. Um pouco de ambiente soa mais natural que voz "no vácuo".
6. **Entre as falas:** use um expander suave (3 a 6 dB de atenuação, release de 100 a 200 ms) em vez de gate. Gate fechando por completo deixa o ruído "abrindo e fechando".
7. **Mascaramento:** uma trilha ou ambiência leve por baixo esconde o ruído residual.

Se não resolver, verifique:
- Se o ganho de entrada não estava baixo demais na gravação (o ruído da interface sobe junto quando se compensa depois).
- Se há uma trilha de segurança, outro microfone ou a câmera com um áudio mais limpo do mesmo trecho.
- Se a redução de ruído do microfone sem fio estava ligada e criou artefatos que a pós piorou.
- Se o trecho não é melhor regravado ou dublado (ADR), quando o resgate soa artificial.

## Mix embolada

1. **Arranjo primeiro:** liste o que está tocando ao mesmo tempo na mesma região. Dois instrumentos na mesma oitava e no mesmo registro brigam. Mude oitava ou voicing, simplifique uma parte ou tire um elemento no trecho.
2. **Lama coletiva:** passe HPF em tudo que não precisa de grave (voz, violão, guitarras, teclados, overheads, reverbs). O acúmulo de 150 a 400 Hz de muitas faixas é a causa mais comum.
3. **Espaço por instrumento:** escolha uma faixa principal para cada elemento e corte um pouco dela nos outros (EQ complementar). Use EQ dinâmica com sidechain para abrir espaço só quando o elemento principal toca.
4. **Reverbs:** reverb demais embola. Use HPF a 300 a 500 Hz e LPF a 6 a 8 kHz nos retornos, encurte o decay e use pre-delay para separar a fonte da ambiência.
5. **Profundidade:** nem tudo precisa estar na frente. Mande elementos de apoio para trás, com menos agudo, mais reverb e menos volume.
6. **Pan:** abra guitarras, teclados e backs para os lados e deixe o centro para voz, bumbo, caixa e baixo.
7. **Bus e master:** compressão pesada no master achata a profundidade e soma a lama. Tire o processamento do master e compare.

Se não resolver, verifique:
- Se a sala de mixagem não tem acúmulo de grave (escute em fones de referência e no carro).
- Se o volume de monitoração não está alto demais (abaixo de ~80 dB SPL fica mais fácil julgar o equilíbrio).
- Se há problemas de fase entre microfones da mesma fonte (ver roteiro abaixo).
- Se a referência comercial usada é do mesmo gênero e está nivelada no mesmo loudness.

## Grave que some no celular

1. **Entenda o limite:** alto-falante de celular reproduz pouco abaixo de ~150 a 200 Hz. O grave fundamental vai sumir de qualquer jeito, e o objetivo é que ele seja percebido.
2. **Harmônicos:**
   - No baixo e no bumbo, adicione saturação (paralela no baixo, com HPF a 300 Hz no bus distorcido).
   - Reforce os harmônicos: baixo entre 700 Hz e 1,5 kHz, ataque do bumbo entre 2 e 5 kHz.
   - Processadores de "grave psicoacústico" geram harmônicos de forma controlada.
3. **Grave sem conteúdo útil:** sub-grave sem informação (abaixo de 30 a 40 Hz) consome headroom e não aparece em lugar nenhum. Use HPF.
4. **Mono:** grave fora de fase ou estéreo some na soma mono do celular. Deixe tudo abaixo de ~120 Hz em mono. Rode `scripts/checar-mono.sh`.
5. **Equilíbrio:** compare no celular com uma referência comercial do mesmo gênero, nivelada no mesmo loudness.

Se não resolver, verifique:
- Se o grave está alto demais na mix, o que força o limiter e abaixa todo o resto.
- Se o problema é o arranjo (baixo tocando numa região muito grave para o estilo).
- Se o celular de teste não está em modo de economia ou com EQ do sistema ligado.
- Se a plataforma não está recomprimindo um arquivo já de baixa qualidade (exporte em qualidade alta).

## Fase entre microfones

1. **Sintomas:** som oco, fino ou "flanger", grave que some quando dois microfones tocam juntos, e mudança grande de timbre ao somar em mono.
2. **Polaridade:** inverta a polaridade de um dos microfones e escolha a posição com mais grave e corpo. Pares comuns: bumbo in/out, caixa em cima/embaixo, DI e amp do baixo, microfone e captador do violão.
3. **Tempo:** alinhe no tempo, aproximando a forma de onda do microfone mais distante do mais próximo.
   - Manualmente: zoom nos transientes.
   - Com ferramenta de alinhamento automático.
   - Referência: 1 ms ≈ 34 cm de distância.
4. **Regra 3:1:** na gravação, o segundo microfone deve estar a pelo menos 3 vezes a distância do primeiro à fonte. Isso reduz o vazamento que causa filtro pente.
5. **Overheads e room:** em bateria, alinhe ou meça os overheads em relação à caixa. Não alinhe tudo na marra: um pouco de atraso natural dá profundidade.
6. **Plugins:** EQs de fase linear e mínima em faixas paralelas da mesma fonte, e plugins com latência sem compensação, criam desalinhamento. Confira o PDC (compensação de latência) da DAW.

Se não resolver, verifique:
- Se um cabo ou adaptador não está com os pinos trocados (polaridade invertida na fiação).
- Se algum plugin de estéreo (widener, Haas, chorus) não está criando o cancelamento.
- Se as faixas não foram deslocadas na edição (crossfades ou cortes desalinhados entre faixas do grupo).
- Se o resultado em mono está aceitável (`scripts/checar-mono.sh` sem ALERTA).

## Mix que soa baixa depois da normalização

1. **Entenda o que aconteceu:** plataformas normalizam pelo loudness integrado. Uma mix muito comprimida e limitada fica baixa em pico e sem impacto quando a plataforma a abaixa para o alvo, enquanto mixes com mais dinâmica soam mais abertas no mesmo loudness.
2. **Meça:** loudness integrado, true peak e PLR (`scripts/medir.sh`). PLR abaixo de ~8 dB indica limitação demais.
3. **Compare certo:** nivele a sua mix e a referência no mesmo loudness antes de comparar. "Soar baixo" muitas vezes é diferença de equilíbrio, não de volume.
4. **Densidade sem esmagar:**
   - Use compressão em série e paralela nos grupos em vez de limitar forte no master.
   - Use saturação leve para aumentar o volume percebido.
5. **Equilíbrio de frequências:** grave em excesso consome loudness e deixa a mix com menos presença. Confira 2 a 5 kHz, que é onde o ouvido é mais sensível.
6. **Voz:** se a voz está baixa no equilíbrio, a mix inteira parece baixa. Suba a voz antes de subir o master.
7. **Alvo:** masterize perto do alvo da plataforma (ver `referencias/entregas.md`) com true peak de −1 dBTP, em vez de bem acima dele.

Se não resolver, verifique:
- Se a plataforma está mesmo normalizando (normalização desligada pelo ouvinte, plataformas sem normalização).
- Se o true peak não está acima de −1 dBTP, causando distorção na conversão que soa "pequena".
- Se a mix não tem problema de fase que some em mono (`scripts/checar-mono.sh`).
- Se a referência usada é do mesmo gênero e da mesma época.
