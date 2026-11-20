# Modos de trabalho: o que cada etapa faz e não faz

Leia este arquivo para decidir em qual etapa o pedido está e o que cabe nela. Cada etapa resolve um tipo de problema. Corrigir na etapa errada custa qualidade: loudness na mix tira headroom do master, EQ de mix no master mexe em tudo ao mesmo tempo, limpeza depois da compressão realça o ruído.

## Como usar

1. Identifique o modo do pedido pelas palavras e pelo material: "vou gravar" é captação, "tem um chiado" é edição e limpeza, "a voz some na música" é mixagem, "está baixo no Spotify" é masterização, "que formato mando" é entrega.
2. Responda dentro do modo, seguindo o "faz" e respeitando o "não faz".
3. Se o problema nasceu numa etapa anterior, diga isso e indique onde resolver. Exemplos:
   - Reverb de sala na voz gravada: é captação. A limpeza reduz, mas não remove sem artefato. Sugira a correção possível e como gravar na próxima vez.
   - Voz embolada com o violão num master estéreo: é mixagem. Peça os stems ou a sessão.
   - Clipping no arquivo bruto: é captação (ganho alto demais). Nenhum limiter desfaz.
4. Se o usuário pedir conscientemente algo fora da etapa (ex.: "não tenho os stems, faz o que der no master"), ajude e deixe claro o limite do resultado.

## Princípio geral

**Processar remove defeitos, não caráter: na dúvida, processe menos.** Cada processador precisa ter um motivo audível. Compare sempre com o original no mesmo volume (bypass com ganho compensado), porque "mais alto" engana como "melhor". Passar no medidor não basta: só está pronto depois de ouvido.

Quando a queixa citar um elemento ("a voz está estranha"), isole esse elemento primeiro: escute-o solo, cru e depois de cada etapa da cadeia, antes de mexer em qualquer outra coisa.

## Captação

**Faz**
- Escolhe microfone, posição e distância (ver `referencias/gravacao-fase.md`).
- Trata o ambiente com o que houver: cobertores, sofá, closet, distância das paredes, desligar ar-condicionado e geladeira.
- Ajusta o ganho de entrada com folga: picos entre −12 e −6 dBFS em 24 bits.
- Confere fase entre microfones e faz um take de teste ouvido em fone fechado.
- Grava um trecho de ruído de sala (room tone) de 10 a 30 s para a limpeza.

**Não faz**
- Não grava com processamento destrutivo "para economizar tempo" (compressão forte, redução de ruído ou EQ agressiva na entrada), salvo se o usuário souber exatamente o que quer.
- Não corrige depois o que dá para corrigir agora: se a sala ressoa, mude a posição antes de apertar o REC.

## Edição e limpeza

**Faz**
- Cortes, emendas com crossfade, ordem dos takes e comping.
- Remove ruído de fundo, cliques, estalos de boca, zumbido (hum) e respirações exageradas (atenuar 6 a 10 dB costuma soar melhor que apagar).
- Ajusta silêncios e pausas (ver `referencias/edicao-fala.md`).
- Alinha tempo e fase entre faixas quando necessário.

**Não faz**
- Não mexe em timbre (EQ de cor) nem em dinâmica para soar "pronto".
- Não define o loudness final.
- Não aplica redução de ruído até o limite: se começar a soar metálico ou "debaixo d'água", volte 3 a 6 dB de redução.

## Mixagem

**Faz**
- Equilíbrio entre os elementos, panorama e profundidade.
- EQ corretiva e de cor, compressão, de-esser, saturação, automação.
- Espaço: reverb e delay em envios (sends), sem afogar a voz.
- Resolve mascaramento, incluindo no arranjo (ver `referencias/mixagem.md` e `referencias/frequencias.md`).
- Entrega o premaster com headroom: picos por volta de −6 a −3 dBFS, sem limiter no master bus (ou com ele em bypass na exportação, se for usado só como referência).

**Não faz**
- Não faz o loudness final nem limita para competir em volume.
- Não exporta com dither ou sample rate de entrega: exporta na resolução da sessão (24 ou 32 bits float).

## Masterização

**Faz**
- Loudness integrado, true peak e LRA de acordo com o destino (ver `referencias/entregas.md`).
- Tonalidade geral em ajustes amplos (EQ de ±1 a 2 dB em bandas largas), compressão de bus suave e limiter.
- Consistência entre faixas de um álbum ou série: diferença de loudness percebido pequena e timbre coerente.
- Sequência, espaços entre faixas, fades finais, metadados (ISRC) e checagem em vários sistemas.
- Cadeia típica de partida: EQ corretiva → compressão de bus (ratio 1,5:1 a 2:1, 1 a 2 dB de redução) → EQ de cor → limiter (true peak −1 dBTP). Ver `referencias/masterizacao.md`.

**Não faz**
- Não corrige problema de mix que exige mexer num elemento só (voz alta demais, bumbo que some, sibilância de um instrumento). Nesse caso, pede os stems ou uma nova versão da mix.
- Com stems, usa-os para equilíbrio (subir ou baixar um grupo), não para cirurgia. Em stems separados por IA, de-esser e notches atingem o vazamento junto e criam artefatos.
- Não empurra o loudness além do que a música aguenta: se o limiter passa de 3 a 4 dB de redução e os transientes somem, aceite um alvo mais baixo.

## Entrega

**Faz**
- Define formato, codec, sample rate, bit depth, canais, loudness e true peak de cada destino (ver `referencias/entregas.md` e `referencias/codecs.md`).
- Gera as versões necessárias (estéreo, stems, M&E, versões limpas) com nomes claros.
- Mede o arquivo final, já no formato de entrega (ver `referencias/scripts.md`), e confere com a especificação.
- Preenche a ficha de entrega.

**Não faz**
- Não reabre decisões de mix ou master: se o arquivo não passa na especificação por um problema de som, volte à etapa certa.
- Não converte várias vezes: uma conversão de sample rate ou de codec, a partir do arquivo de maior qualidade.

## Quem decide o quê

| A skill faz | O usuário decide |
|---|---|
| Diagnostica, mede e explica | A direção criativa e a referência sonora |
| Sugere cadeias e valores de partida | O que soa certo no fim (o ouvido tem a palavra final) |
| Avisa sobre riscos técnicos e de especificação | Equipamento, plugins e orçamento |
| Propõe correções e mostra antes de aplicar | O padrão de qualidade e o prazo |
