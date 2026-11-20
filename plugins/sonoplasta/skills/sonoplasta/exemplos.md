# Exemplos de respostas

Leia este arquivo para calibrar o formato e o nível de detalhe das respostas. São modelos, não respostas fixas: adapte ao contexto, ao destino e ao nível técnico de cada usuário. Os valores seguem `referencias/` e devem ser conferidos lá.

## Exemplo 1: vídeo para redes sociais

**Pergunta**

> Gravo Reels falando com um microfone de lapela sem fio no celular. A voz fica baixa perto de outros vídeos e às vezes tem um chiado de ar-condicionado. Edito no CapCut. Como melhoro?

**Resposta ideal**

O mais provável é que o vídeo esteja abaixo de −14 LUFS e que a redução de ruído esteja ausente ou em dobro. Vamos resolver na ordem.

**Na gravação**
1. Desligue o ar-condicionado durante as tomadas, ou grave longe da saída de ar. Ruído que não é gravado não precisa ser removido.
2. Lapela no centro do peito, a 15 a 20 cm da boca, sem encostar na roupa.
3. Ligue a gravação interna do transmissor, se ele tiver, como segurança.
4. Grave 10 a 20 s de room tone no início.

**No CapCut**
1. Selecione o clipe de voz e ligue a **redução de ruído**. Ouça antes e depois: se a voz ficar "metálica", a redução está forte demais, e o melhor é tirar o ruído na origem.
2. Se o microfone já tiver redução de ruído ligada, use só uma das duas. Redução em dobro cria artefatos.
3. Ligue **realçar voz** e confira se não ficou áspero.
4. Ligue a **normalização de loudness** no clipe de voz.
5. Música entre 10 e 20% do volume, com fade de entrada e saída.

**Para chegar ao nível dos outros vídeos**
- Prática comum para Reels: cerca de −14 LUFS integrado e true peak entre −1 e −2 dBTP. A Meta não publica um alvo oficial.
- Se você tiver um computador com ffmpeg, rode `bash scripts/preparar-reels.sh video.mp4`. Ele mede, normaliza para −14 LUFS e −1,5 dBTP e exporta em AAC 48 kHz.

Antes de postar, ouça no alto-falante do celular e com o celular em mono.

Se não resolver, verifique:
- Se a lapela não está coberta pela roupa (abafa e perde volume percebido).
- Se o receptor não está com ganho baixo demais (o chiado sobe quando o volume é compensado depois).
- Se a música não está com letra competindo com a fala.

## Exemplo 2: mixagem musical

**Pergunta**

> Estou mixando uma música pop com voz, violão, piano, baixo e bateria. A mix está embolada e a voz não aparece, mesmo alta. Uso Reaper.

**Resposta ideal**

Voz alta que não aparece quase sempre é mascaramento em 200 a 500 Hz e em 2 a 5 kHz, e muitas vezes começa no arranjo: violão e piano tocando acordes na mesma região que a voz.

1. **Arranjo:** no verso, teste o piano uma oitava acima ou tocando só notas soltas, e deixe o violão como base rítmica. Dois instrumentos harmônicos no mesmo registro da voz raramente se resolvem com EQ.
2. **HPF em tudo que não é grave:**
   - Violão a 120 a 150 Hz, piano a 100 a 150 Hz (ouça em contexto), voz a 80 a 100 Hz.
   - Retornos de reverb a 300 a 500 Hz.
3. **Lama:** corte de 2 a 4 dB entre 250 e 400 Hz no violão e no piano (Q por volta de 1). Na voz, só se ela própria estiver embolada.
4. **Espaço para a voz:** no bus de violão e piano, use EQ dinâmica em 2 a 4 kHz com sidechain da voz (2 a 3 dB de redução só quando a voz canta).
5. **Voz:** cadeia na ordem do sinal:
   - FET com ratio 4:1 a 8:1, 3 a 5 dB de GR.
   - Óptico com 2 a 4 dB de GR.
   - EQ de cor: +2 dB entre 3 e 5 kHz e shelf de +2 a +3 dB a partir de 10 kHz.
   - De-esser entre 5 e 9 kHz.
   - Envios: plate curto (decay de 1,2 s, pre-delay de 80 ms) e delay de 1/8 filtrado.
6. **Pan:** violão e piano levemente para os lados (30 a 60%), deixando o centro para voz, bumbo, caixa e baixo.
7. **Conferência:** compare com uma referência comercial do mesmo gênero, nivelada no mesmo loudness, e ouça em mono.

No Reaper, o ReaEQ não tem banda dinâmica. Use o ReaXcomp em uma faixa (multibanda com sidechain) ou um EQ dinâmico de terceiros.

Se não resolver, verifique:
- Se a mix não está sendo julgada em volume alto demais (abaixo de ~80 dB SPL é mais fácil ouvir o equilíbrio).
- Se não há problema de fase entre microfones do violão ou da bateria.
- Se o master não tem um limiter pesado achatando a profundidade (desligue e compare).

## Exemplo 3: entrega para TV

**Pergunta**

> Uma agência pediu o áudio de um comercial de 30 segundos para TV aberta no Brasil. O que preciso entregar?

**Resposta ideal**

O primeiro passo é pedir à agência o manual técnico de recebimento da emissora. Cada emissora define loudness, formato e slate, e a especificação dela vale mais que qualquer referência genérica. Enquanto isso, prepare com estes pontos de partida:

```
FICHA DE ENTREGA: comercial 30 s / TV aberta (Brasil)
- Destino: TV aberta no Brasil (confirmar emissora)
- Loudness integrado: conforme ABNT NBR 16313 e emissora; referência de mercado −23 LKFS (prática comum), tolerância a confirmar
- True peak máximo: conforme emissora (−1 a −2 dBTP é prática comum)
- Formato do arquivo: WAV, ou áudio embutido no vídeo de entrega (MXF/MOV, conforme a emissora)
- Sample rate: 48 kHz
- Bit depth / codec: 24 bits PCM
- Canais: estéreo (5.1 se pedido)
- Versões e stems: mix completa, versão sem locução, trilha e efeitos separados (conforme o pedido)
- Nome dos arquivos: padrão da agência
- Metadados: duração exata de 30 s, timecode e slate conforme o manual da emissora
- Checagens antes de enviar: medição de loudness e true peak no programa inteiro, escuta em mono, início e fim sem cortes
- Confirmar com: manual técnico da emissora e agência
```

Cuidados específicos de comercial:
1. **Duração exata:** 30 s certos, sem cortar a cauda da trilha nem da locução. Termine com fade ou com um final de trilha que caiba no tempo.
2. **Locução clara:** a voz manda. Faça ducking da trilha e coloque a locução cerca de 6 a 10 dB acima da música na percepção.
3. **Loudness:** meça o comercial inteiro. Comercial "estourado" não passa no controle de qualidade da emissora.
4. **Versões:** pergunte quais versões e cortes (15 s, 30 s, 60 s) a agência vai precisar e se haverá veiculação em rádio ou internet, com outro alvo.

Se não resolver, verifique:
- Se a emissora pede tom de referência (1 kHz) e slate antes do programa.
- Se o vídeo de entrega exige o áudio em canais específicos (ex.: canais 1 e 2 estéreo, 3 a 8 para 5.1).
- Se o loudness foi medido com o medidor e o padrão corretos (BS.1770, integrado no programa inteiro).
