# Glossário

Leia este arquivo quando o usuário perguntar o significado de um termo ou quando precisar explicar um conceito a quem está aprendendo. Use a definição curta e, se ajudar, o exemplo prático.

## Loudness e níveis

- **dBFS (decibels full scale):** nível digital em relação ao máximo possível (0 dBFS). Tudo fica abaixo de zero. Acima disso, há clipping.
- **LUFS (Loudness Units relative to Full Scale):** unidade de loudness percebido medida pela ITU-R BS.1770, com filtro de ponderação K e gate. É a unidade dos alvos de plataformas (ex.: −14 LUFS).
- **LKFS:** o mesmo que LUFS, com o nome usado pela ATSC e pela ITU. −24 LKFS = −24 LUFS.
- **LU (Loudness Unit):** diferença entre dois valores de loudness. 1 LU = 1 dB. Usado em tolerâncias (±1 LU) e no LRA.
- **Loudness integrado (I):** loudness médio do programa inteiro, com gate (ignora silêncios). É o valor comparado com o alvo de entrega.
- **Momentary (M) e short-term (S):** loudness em janelas de 400 ms e 3 s. Servem para acompanhar trechos durante a mix.
- **LRA (Loudness Range):** variação de loudness ao longo do programa, em LU. Voz bem nivelada: 3 a 6 LU. Música clássica pode passar de 15 LU.
- **True peak (dBTP):** pico estimado do sinal analógico reconstruído, incluindo os picos entre amostras (inter-sample peaks). É mais confiável que o sample peak para evitar distorção na conversão para AAC/MP3. Alvo comum: −1 dBTP.
- **Sample peak:** maior valor de amostra digital. Pode ficar abaixo de 0 dBFS enquanto o true peak passa de zero.
- **PLR (Peak to Loudness Ratio):** true peak menos o loudness integrado, em dB. Indica quanta dinâmica de pico sobrou. Abaixo de ~8 dB, o master está muito limitado.
- **Headroom:** espaço entre o nível de trabalho e o 0 dBFS. Deixe folga na gravação e na mix (picos de −6 a −3 dBFS na mix antes do master).
- **Gain staging:** acertar o nível em cada etapa da cadeia (pré, plugins, bus, master) para não saturar nem trabalhar baixo demais. Referência comum: ~−18 dBFS RMS na entrada de plugins que emulam hardware.
- **Normalização:** ajuste de ganho para chegar a um alvo de loudness (o que as plataformas fazem automaticamente) ou de pico.

## Dinâmica

- **Compressor:** reduz a diferença entre partes fortes e fracas.
  - **Threshold:** nível a partir do qual o compressor age.
  - **Ratio:** quanto ele reduz acima do threshold (4:1 = cada 4 dB acima vira 1 dB).
  - **Attack e release:** tempo para começar a comprimir e para soltar.
  - **GR (gain reduction):** quanto ele está reduzindo.
- **Limiter:** compressor de ratio muito alto que impede o sinal de passar de um teto. Usado no fim da cadeia e no master.
- **Clipper:** corta os picos de forma instantânea. Pode soar mais transparente que um limiter em picos curtos, mas distorce se for exagerado.
- **Compressão paralela:** mistura de um sinal muito comprimido por baixo do sinal original. Ganha densidade sem perder os ataques.
- **Compressão em série:** dois ou mais compressores leves em sequência (ex.: FET para picos e óptico para nivelar) no lugar de um só trabalhando pesado.
- **Gate e expander:** reduzem o sinal abaixo de um nível. O gate fecha por completo e o expander atenua de forma suave. Servem para diminuir vazamento e ruído entre falas.
- **De-esser:** compressor que age só na faixa da sibilância (5 a 10 kHz).
- **Sidechain:** usar um sinal para controlar o processador de outro (ex.: a voz controla o compressor da música).
- **Ducking:** abaixar automaticamente a música ou o fundo quando a voz entra, normalmente com sidechain.
- **EQ dinâmica:** equalizador que só corta ou realça uma faixa quando ela passa de um nível. É bom para ressonâncias que aparecem em algumas notas.

## Frequência e espaço

- **HPF / LPF:** filtro passa-altas (corta graves abaixo da frequência) e passa-baixas (corta agudos acima dela).
- **Q:** largura de uma banda de EQ. Q alto é estreito (correção cirúrgica) e Q baixo é largo (ajuste de cor).
- **Shelf:** realce ou corte de tudo acima (high shelf) ou abaixo (low shelf) de uma frequência.
- **Fase linear / fase mínima:** tipos de EQ. A fase linear não desloca a fase, mas pode criar pré-ringing. A mínima soa mais "analógica" e desloca a fase perto das bandas mexidas.
- **Pre-delay:** tempo entre o som direto e o início do reverb. Separa a voz da ambiência.
- **Early reflections:** primeiras reflexões da sala. Dão a sensação de tamanho e de distância.
- **Efeito Haas:** atraso curto (10 a 30 ms) em um lado para abrir o estéreo. Cuidado com a soma em mono.
- **Mascaramento:** quando um som esconde outro na mesma região de frequência.

## Fase e captação

- **Polaridade:** inversão do sinal (o positivo vira negativo). É o botão "Ø" da DAW ou da mesa.
- **Fase:** relação de tempo entre dois sinais parecidos. Diferenças de tempo entre microfones causam cancelamentos em algumas frequências.
- **Filtro pente (comb filtering):** cancelamentos e reforços em série causados pela soma de sinais com atraso. Soa oco ou "flanger".
- **Regra 3:1:** o segundo microfone deve estar a pelo menos 3 vezes a distância do primeiro à fonte, para reduzir o filtro pente.
- **Efeito de proximidade:** aumento de grave quando um microfone direcional fica muito perto da fonte.
- **32-bit float:** formato de gravação com faixa dinâmica enorme, que protege de clipping na gravação. Não protege de ruído nem de microfone mal posicionado.
- **Room tone:** gravação do "silêncio" do ambiente, usada para tapar buracos e emendar cortes.
- **Latência / PDC:** atraso causado por conversão e plugins. O PDC (compensação de latência) da DAW realinha as faixas.

## Broadcast, vídeo e entrega

- **Mix-minus:** retorno com tudo menos a própria voz de quem recebe. Usado com convidados remotos e em transmissões para evitar eco.
- **Stems:** submixes por grupo (bateria, baixo, harmonia, voz, efeitos) exportados separados para masterização, remix ou entrega.
- **D/M/E (Dialogue, Music, Effects):** stems de diálogo, música e efeitos, comuns em entregas para TV e cinema.
- **Slate:** identificação no início do arquivo ou vídeo (claquete, tom e informações) usada em entregas para TV.
- **Timecode:** marcação de tempo (horas:minutos:segundos:quadros) que sincroniza áudio e vídeo.
- **OMF / AAF:** formatos de troca de sessão entre editores de vídeo e DAWs, com as mídias e as posições dos clipes.
- **Dither:** ruído muito baixo adicionado ao reduzir o bit depth (ex.: 24 para 16 bits) para evitar distorção de quantização. Aplique uma vez, no último passo.
- **DDP:** formato de imagem de CD entregue à fábrica, com sequência, intervalos, ISRC e códigos.
- **ISRC:** código internacional que identifica cada gravação. É necessário para distribuição e royalties.

## Áudio imersivo

- **Dolby Atmos:** formato imersivo baseado em canais (bed) e objetos, renderizado para o sistema de quem ouve (fones, soundbar, salas 7.1.4).
- **Bed:** base de canais fixos (até 7.1.2) da mix Atmos. Recebe elementos que não precisam de posição precisa.
- **Objects (objetos):** sons com posição e movimento definidos por metadados, renderizados conforme o sistema de reprodução.
- **Binaural:** renderização para fones que simula a escuta espacial. É como a maioria ouve Atmos.
- **ADM BWF:** arquivo WAV com os metadados de Atmos (canais, objetos e posições). É o formato de entrega de Atmos para música.
- **Downmix:** redução de uma mix multicanal para menos canais (ex.: 7.1.4 para estéreo). Confira sempre.
