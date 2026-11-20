# Instagram, Reels, TikTok, Shorts e criadores de conteúdo

Leia este arquivo antes de responder sobre áudio de Reels, TikTok, Shorts ou vídeos curtos verticais, sobre captação e edição de criadores de conteúdo, ou sobre CapCut, Edits (Meta) e o editor do Instagram. Para especificações gerais de entrega, veja também `referencias/entregas.md`. Para medir e preparar o arquivo final, veja `referencias/scripts.md` e o `scripts/preparar-reels.sh`.

Os nomes de menus, recursos e regras de música das plataformas mudam com frequência. Oriente pelo que o recurso faz e diga para confirmar na versão atual do app e na central de ajuda da plataforma.

## 1. Os primeiros segundos

- A voz começa já no primeiro quadro: corte o silêncio, a respiração e o "então..." do início. Em até ~0,5 s já deve haver fala ou um som com intenção.
- Se o vídeo abre com um corte forte ou uma revelação, coloque um "hit" (impacto, whoosh curto, batida da trilha) exatamente no primeiro corte. Use só quando combinar com o conteúdo, não em todo vídeo.
- A trilha entra no tempo da fala, não por cima dela: comece com a música já baixa ou com um fade-in curto (100 a 300 ms), nunca com um volume que depois some.
- Não deixe o início mais baixo que o resto. Quem rola o feed decide em 1 a 2 segundos, e o primeiro som precisa estar no mesmo nível da fala principal.

## 2. Voz para o alto-falante do celular

O alto-falante do celular quase não reproduz abaixo de ~150 a 200 Hz e muitas vezes é mono. A voz precisa ser entendida ali.

- **HPF:** 80 a 100 Hz (lapela e celular podem ir a 100 a 120 Hz). Grave que o celular não toca só gasta headroom.
- **Presença:** +2 a +3 dB entre 2 e 5 kHz (Q por volta de 1). É onde está a inteligibilidade. Se ficar áspero, troque por um ganho menor e mais largo.
- **Corpo sem grave:** em vez de reforçar 100 Hz, use saturação leve (tape ou válvula, mix de 10 a 20%). Os harmônicos fazem o celular "sugerir" o grave da voz.
- **Lama:** se a voz soar abafada, corte 2 a 4 dB entre 200 e 400 Hz.
- **Checagem:** ouça em mono e no próprio celular, no volume que a pessoa usaria, antes de publicar. Rode `scripts/checar-mono.sh` quando houver terminal.

## 3. Legenda como segunda trilha

- Muita gente assiste sem som. Legende sempre, com a legenda queimada no vídeo ou com a legenda automática revisada.
- A legenda automática erra menos quando a fala é clara: voz bem acima da trilha, sem música com letra competindo, ruído controlado e dicção sem atropelo.
- Revise nomes próprios, números e termos técnicos. A legenda errada passa descuido.
- Mesmo com legenda, o áudio importa: quem liga o som depois de ler continua assistindo se a voz estiver boa.

## 4. Captação de criador

- **Microfone sem fio de lapela** (sistemas tipo transmissor clip-on com receptor na câmera ou no celular): prenda a 15 a 20 cm da boca, no centro do peito, longe de roupa que roça e de colar. Esconder sob a roupa exige fita e espuma, senão o atrito estraga a fala.
- **Track de segurança ou 32-bit float:** se o sistema tiver gravação de segurança (um canal a −6 a −12 dB do principal), ligue. Se gravar em 32-bit float (interno ou em gravador), a gravação fica protegida de clipping, mas o ruído e a distância do microfone continuam valendo: ajuste a posição como sempre.
- **Gravação interna no transmissor:** ligue quando possível. Ela salva o áudio se o sinal sem fio cair.
- **Externa:** use sempre o protetor de vento (dead cat ou espuma peluda). Vento no microfone não sai na edição.
- **Room tone:** grave 10 a 20 segundos de silêncio do ambiente em cada locação, com todos parados. Ele serve para tapar buracos e os cortes.
- **Redução de ruído do próprio microfone:** ligue só em ambiente com ruído constante e baixo (ar-condicionado, ventilador) e quando não houver tempo para editar. Desligue quando for tratar na pós (RX, CapCut, Edits), porque ruído removido na captação não volta, e o processamento duplo cria artefatos ("voz de robô"). Em ambiente silencioso, deixe desligada.
- **Nível:** fala normal com picos em torno de −12 dBFS (−6 dBFS no máximo). Faça um teste de 10 s e ouça em fone antes de gravar tudo.

## 5. Jump cuts

- Aplique microfades de 5 a 20 ms em cada corte de áudio para evitar estalos (clique por corte fora do cruzamento por zero).
- Mantenha o room tone contínuo por baixo de toda a fala, em uma trilha própria. Assim o "ar" da sala não liga e desliga a cada corte, o que denuncia a edição.
- Se o ruído de fundo muda entre tomadas, iguale com redução de ruído suave ou com mais room tone, não com gate.
- Nivele as tomadas antes de comprimir: diferenças de volume entre cortes chamam mais atenção do que a falta de compressão.

## 6. Trilha e direitos

Regras de música mudam com frequência e variam por país e tipo de conta. Diga sempre ao usuário para confirmar na central de ajuda do Instagram e da Meta antes de publicar conteúdo patrocinado.

- **Música em alta:** usar áudio em alta da biblioteca do app pode ajudar a descoberta, mas a música só vale dentro do app. Baixar o vídeo com a música e postar em outro lugar pode gerar bloqueio.
- **Contas comerciais (business):** costumam ter acesso limitado à biblioteca de músicas populares por causa de licenciamento, e o acesso pode mudar. Em conteúdo comercial ou publi, use música licenciada para uso comercial.
- **Sound Collection da Meta:** biblioteca de músicas e efeitos liberados pela Meta para uso nas plataformas dela. É a opção segura para contas comerciais dentro de Instagram e Facebook. Confira os termos antes de usar fora delas.
- **Áudio original:** o som do seu Reel pode virar "áudio original" e ser reutilizado por outras pessoas. Se a trilha for sua (composta ou licenciada para você), isso divulga o trabalho. Se for de terceiros, cuidado: licenciar para você não costuma incluir o uso por outras pessoas.
- Música por baixo da fala: cerca de 15 a 20 dB abaixo da voz durante a fala, subindo nas pausas. Prefira trechos instrumentais ou sem letra enquanto alguém fala.

## 7. Exportação

- **Recompressão:** o Instagram recodifica o áudio em AAC com taxa menor. Isso cria picos acima do original e tira brilho. Exporte com qualidade alta para chegar menos degradado.
- **Alvo (prática comum):** por volta de −14 LUFS integrado e true peak de −1 a −2 dBTP. A Meta não publica um alvo oficial: apresente como prática comum.
- **Formato:** MP4 (H.264), áudio AAC 48 kHz, 256 a 320 kbps, estéreo. A mix pode ser mono no centro, mas exporte em estéreo.
- **Com terminal:** `bash scripts/preparar-reels.sh video.mp4` normaliza para −14 LUFS e −1,5 dBTP, checa a compatibilidade mono e exporta com o vídeo copiado e o áudio em AAC 48 kHz.

## 8. Consistência de série

- Salve um preset fixo de voz (cadeia na DAW, ou ajustes anotados no CapCut/Edits) e use o mesmo microfone e a mesma posição em todos os episódios.
- Meça antes de postar (`scripts/medir.sh` ou um medidor de loudness) e mantenha todos os vídeos da série no mesmo alvo, com até ±1 LU de diferença.
- Use o mesmo nível de trilha e as mesmas vinhetas: o público reconhece a série pelo som.

## 9. Ferramentas

Os nomes abaixo são os mais comuns no momento. Se o usuário não encontrar, peça para procurar pelo que o recurso faz e confirme na versão dele.

**CapCut (celular e computador)**
1. Separe o áudio do vídeo se precisar editar a voz sozinha (opção de extrair ou separar áudio no clipe).
2. Selecione o clipe de voz e abra **Áudio**: ligue a **redução de ruído** só se houver ruído constante e ouça o resultado.
3. Use **realçar voz** (quando disponível) com moderação: ouça se não ficou metálico.
4. Ligue a **normalização de loudness** do clipe de voz, se existir na sua versão, para igualar os trechos.
5. Ajuste o **volume** da música: comece entre 10 e 20% no celular (100% é o volume original) ou entre −15 e −20 dB no computador, e ajuste ouvindo.
6. Use **fade** de entrada e de saída na música (0,3 a 1 s) e evite efeitos de voz (voice changer) em fala.
7. Exporte em 1080p, 30 fps, com a maior qualidade disponível.

**Edits (Meta)**
1. Importe o vídeo e selecione o clipe com a voz.
2. Nos controles de áudio, use **volume** para igualar os clipes e o recurso de **melhoria de voz / redução de ruído** quando houver ruído de fundo. Compare ligado e desligado.
3. Adicione música e baixe o volume dela até a fala ficar clara no celular.
4. Gere as legendas automáticas e revise.
5. Exporte na maior qualidade e publique direto ou salve o arquivo.

**Editor do Instagram**
1. Depois de escolher o vídeo e a música, abra os **controles de áudio**.
2. Ajuste o volume do áudio da câmera (a voz) e o da música: voz no máximo e música bem mais baixa. Comece com a música por volta de 15 a 25% e ouça.
3. Se houver opção de **realçar voz** ou **reduzir ruído**, compare antes e depois.
4. Ative as legendas e revise.

**DAW (Reaper, Logic, Pro Tools, Resolve/Fairlight)**
1. Grave ou importe a voz e o room tone em trilhas separadas.
2. Limpe (RX, Clarity, Acon), edite com microfades e aplique o preset abaixo.
3. Mixe a trilha com ducking (sidechain da voz, 4 a 8 dB de redução na música) e exporte o WAV.
4. Junte o áudio ao vídeo no editor ou use `scripts/preparar-reels.sh` no vídeo exportado.

## Presets de voz para Reels

Valores de partida. O ouvido decide, e o teste final é no celular.

### Lapela sem fio

**DAW (ordem do sinal)**
1. HPF a 90 a 100 Hz, 12 a 18 dB/oitava.
2. Redução de ruído leve (6 a 10 dB de redução no máximo), só se houver ruído constante.
3. EQ corretiva: −2 a −4 dB entre 150 e 300 Hz (ressonância do peito e da roupa), Q por volta de 1,5.
4. Compressor: ratio 3:1, attack 10 a 20 ms, release 80 a 150 ms, 4 a 6 dB de redução.
5. EQ de cor: +2 a +3 dB em 3 a 4 kHz (presença) e shelf de +2 a +3 dB a partir de 8 a 10 kHz (a lapela no peito perde agudo).
6. De-esser: 5 a 8 kHz, 3 a 4 dB de redução.
7. Saturação leve: mix de 10 a 20%.
8. Limiter: teto de −1,5 dBTP. Depois normalize o vídeo final para ~−14 LUFS.

**CapCut / Edits**
- Redução de ruído: ligada só se houver ruído constante (ar-condicionado, rua). Ouça para não ficar "robótico".
- Realçar voz: ligado, conferindo se não ficou metálico.
- Normalização de loudness (CapCut): ligada no clipe de voz.
- Volume da voz: em 100% (ou 0 dB). Suba só se, mesmo normalizada, ainda ficar baixa.
- Música: 10 a 20%, com fade de entrada e saída.

### Voz gravada no celular

**DAW (ordem do sinal)**
1. HPF a 100 a 120 Hz.
2. Redução de ruído e de reverb da sala, moderada (o microfone do celular capta muito ambiente). Cuidado com artefatos: prefira menos redução.
3. EQ corretiva: −3 dB entre 300 e 500 Hz (som de caixa da sala), Q por volta de 1.
4. Compressor: ratio 3:1, attack 5 a 15 ms, release 100 ms, 4 a 6 dB de redução.
5. EQ de cor: +2 dB entre 2,5 e 4 kHz. Evite reforçar acima de 8 kHz, porque realça o ruído e a compressão do celular.
6. De-esser: 5 a 7 kHz, 2 a 4 dB de redução.
7. Saturação leve: mix de 10 a 15%.
8. Limiter: teto de −1,5 dBTP.

**CapCut / Edits**
- Redução de ruído: ligada (o celular quase sempre capta ruído). Compare antes e depois.
- Realçar voz: ligado. É onde ele mais ajuda.
- Normalização de loudness: ligada.
- Música: 8 a 15%, mais baixa que nos outros casos, porque a voz do celular tem menos presença.
- Na próxima gravação: celular a 20 a 30 cm da boca, em um cômodo com cortinas, tapete ou roupas, longe de paredes nuas.

### Voice-over em microfone de estúdio

**DAW (ordem do sinal)**
1. HPF a 70 a 80 Hz.
2. EQ corretiva: −2 dB entre 200 e 300 Hz se houver efeito de proximidade, e corte estreito em ressonâncias da sala, se houver.
3. Compressão em série: FET (estilo 1176) com ratio 4:1, attack rápido e 3 a 5 dB de redução, seguido de óptico (estilo LA-2A) com 2 a 3 dB de redução.
4. EQ de cor: +1,5 a +2 dB entre 3 e 5 kHz e shelf de +2 dB a partir de 10 a 12 kHz (ar).
5. De-esser: 6 a 8 kHz, 3 a 5 dB de redução.
6. Saturação leve: mix de 10 a 20%.
7. Limiter: teto de −1,5 dBTP.

**CapCut / Edits** (quando a voz chega pronta da DAW, use o mínimo)
- Redução de ruído: desligada (a voz já está limpa).
- Realçar voz: desligado. Pode deixar a voz tratada áspera.
- Normalização de loudness: ligada, ou desligada se a voz já veio no nível final.
- Música: 10 a 20%, com ducking feito na DAW sempre que possível.

## Checklist de gravação

```
[ ] Bateria carregada (microfones, receptor, celular/câmera) e espaço livre
[ ] Microfone a 15–20 cm da boca, sem roçar em roupa ou cabelo
[ ] Protetor de vento em externa
[ ] Gravação interna ou track de segurança ligada (ou 32-bit float)
[ ] Redução de ruído do microfone: decidida (ligada só com ruído constante e sem pós)
[ ] Nível: picos de fala em torno de −12 dBFS
[ ] Teste de 10 s ouvido em fone
[ ] Ar-condicionado, ventilador e notificações desligados
[ ] Room tone gravado: 10–20 s de silêncio em cada locação
```

## Checklist pré-publicação

```
[ ] Fala começa no primeiro segundo, sem silêncio nem respiração
[ ] Cortes com microfade e room tone contínuo, sem estalos
[ ] Voz clara sobre a música no alto-falante do celular
[ ] Escutado em mono (ou checar-mono.sh sem ALERTA)
[ ] Loudness por volta de −14 LUFS e true peak entre −1 e −2 dBTP (prática comum)
[ ] Exportado em MP4, H.264, AAC 48 kHz
[ ] Legenda gerada e revisada
[ ] Música com direito de uso para este tipo de conta e de conteúdo
[ ] Mesmo preset e mesmo nível dos vídeos anteriores da série
```
