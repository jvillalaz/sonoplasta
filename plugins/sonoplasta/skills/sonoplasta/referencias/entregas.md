# Entregas e especificações por destino

Leia este arquivo antes de responder sobre especificações de entrega (loudness, true peak, formato, sample rate, bit depth, codec e canais) para qualquer plataforma, emissora ou mídia física, e sempre que for preencher uma ficha de entrega.

## Como usar esta tabela

- **Status oficial:** o valor está publicado pela plataforma, pela norma ou pela emissora. Mesmo assim, especificações mudam: confirme na documentação oficial atual antes de entregar.
- **Status prática comum:** a plataforma não publica um alvo, ou o valor vem de medição e do uso do mercado. Apresente sempre como "prática comum" e nunca como regra da plataforma.
- Quando o cliente, a emissora, a agência ou a distribuidora mandar uma especificação própria, ela vale mais que esta tabela.
- Plataformas que normalizam abaixam masters mais altos que o alvo. Buscar loudness acima disso só tira dinâmica, sem ganho de volume para o ouvinte.

## Tabela por destino

| Destino | Loudness integrado | True peak máx. | Formato | Sample rate | Bit depth / codec | Canais | Status | Observações |
|---|---|---|---|---|---|---|---|---|
| YouTube | ~−14 LUFS | −1 dBTP | Áudio dentro do vídeo (MP4/MOV) | 48 kHz (ou 96 kHz) | AAC-LC, 384 kbps em estéreo | Estéreo (ou estéreo + 5.1) | Loudness: **prática comum**. Codec e sample rate: **oficial** (configurações de upload recomendadas pelo YouTube) | O YouTube abaixa conteúdo mais alto que a referência, mas não aumenta o mais baixo. Em voz falada, −14 a −16 LUFS soa bem no celular. |
| YouTube Shorts | ~−14 LUFS | −1 a −2 dBTP | Vídeo vertical MP4 | 48 kHz | AAC | Estéreo | **Prática comum** | Mesmas regras de upload do YouTube. Folga maior de true peak por causa da recompressão e de alto-falantes de celular. |
| Instagram Reels | ~−14 LUFS | −1 a −2 dBTP | Vídeo vertical MP4 | 48 kHz | AAC | Estéreo | **Prática comum** | A Meta não publica alvo de loudness. A recompressão gera picos acima do original, por isso a folga de −1 a −2 dBTP. |
| TikTok | ~−14 LUFS | −1 a −2 dBTP | Vídeo vertical MP4 | 48 kHz | AAC | Estéreo | **Prática comum** | O TikTok não publica alvo de loudness. Mesma lógica de recompressão do Instagram. |
| Podcast (só áudio) | −16 LUFS ±1 (estéreo); cerca de −19 LUFS em mono | −1 dBTP | MP3 ou AAC para publicação; WAV como master | 44,1 ou 48 kHz | MP3 128 a 192 kbps ou AAC; master WAV 24 bits | Mono (só voz) ou estéreo | −16 LUFS e −1 dBTP: **oficial** para Apple Podcasts. Demais plataformas: **prática comum** (alinhada à AES TD1004) | Mantenha o mesmo loudness em todos os episódios. Confira a página de requisitos do agregador ou host. |
| Podcast em vídeo | ~−14 a −16 LUFS | −1 dBTP | Vídeo MP4 (YouTube, Spotify) | 48 kHz | AAC | Estéreo | **Prática comum** | Siga o YouTube quando ele for o destino principal. Se a mesma mix for também para o feed de áudio, use −16 LUFS para atender aos dois. |
| Spotify | ~−14 LUFS (referência de normalização) | −1 dBTP; −2 dBTP se o master for mais alto que −14 LUFS | WAV ou FLAC, enviado pela distribuidora | 44,1 kHz ou mais | 16 ou 24 bits | Estéreo | **Oficial** (normalização e recomendação de true peak publicadas pelo Spotify for Artists) | Níveis que o ouvinte Premium pode escolher (oficial): Loud ~−11 LUFS, Normal ~−14 LUFS (padrão) e Quiet ~−19 LUFS. No modo Loud, o Spotify aplica ganho mesmo em masters com pouco true peak de folga, com limitação. Formato final: confirme com a distribuidora. |
| Apple Music | ~−16 LUFS (Sound Check) | −1 dBTP | WAV, enviado pela distribuidora | 44,1 kHz ou mais (até 192 kHz) | 24 bits (para Apple Digital Masters) | Estéreo | Loudness: **prática comum** (a Apple não publica alvo numérico). Formato 24 bits: **oficial** (programa Apple Digital Masters) | Evite clipping inter-sample, porque a conversão para AAC acusa esses picos. |
| Dolby Atmos (música) | −18 LKFS (no máximo) | −1 dBTP | ADM BWF (.wav) | 48 kHz | 24 bits PCM | Bed 7.1.2 + objects (renderização de monitoração em 7.1.4) | **Oficial** (especificação de Atmos para música da Apple Music e da Dolby) | Confira binaural e downmix estéreo. Confirme a especificação com a distribuidora antes de entregar. |
| TV aberta no Brasil | Definido pela ABNT NBR 16313. A referência de mercado é −23 LKFS (**prática comum**) | Conforme a norma e a emissora | WAV, ou áudio embutido no MXF/MOV da emissora | 48 kHz | 24 bits | Estéreo; 5.1 quando pedido | Norma: **oficial**. Valores e tolerâncias: confirme com a emissora | Cada emissora tem um manual técnico de recebimento de materiais. Peça antes de mixar. |
| Comercial para TV | EBU R128: −23 LUFS ±0,5 LU. ATSC A/85: −24 LKFS ±2 dB. Brasil: ABNT NBR 16313 | EBU R128: −1 dBTP. ATSC A/85: −2 dBTP | WAV, ou áudio embutido no vídeo de entrega | 48 kHz | 24 bits | Estéreo; 5.1 quando pedido | Normas: **oficial**. Formato: **prática comum**. Confirme com a agência e a emissora | Duração exata (15, 30 ou 60 s), sem cortes de áudio na borda. Entregue as versões pedidas (cheia, sem locução, trilha). |
| Master para CD | Sem alvo de norma: o loudness é decisão artística | −0,3 a −1 dBTP (**prática comum**) | Imagem DDP para fábrica, ou WAV por faixa | 44,1 kHz | 16 bits (com dither na conversão final) | Estéreo | Formato 44,1 kHz/16 bits: **oficial** (Red Book). Loudness e true peak: **prática comum** | Inclua sequência, intervalos entre faixas, ISRC e códigos no DDP. Mantenha o loudness consistente no álbum. |
| Master para vinil | Sem alvo: menos limitação que o master digital | Sem limiter agressivo; folga de picos (**prática comum**) | WAV por lado, ou por faixa com tempos de sequência | 44,1, 48 ou 96 kHz | 24 bits | Estéreo, com graves em mono (abaixo de ~100 a 150 Hz) | **Prática comum**. Confirme com o estúdio de corte | Controle a sibilância e o grave fora de fase. Tempo por lado em 12" a 33⅓ rpm: até ~18 a 22 min para manter nível e graves. |

## Ficha de entrega

Ao responder sobre uma entrega, preencha e mostre este bloco. Marque cada valor como **oficial** ou **prática comum** e termine com a orientação de confirmar a especificação.

```
FICHA DE ENTREGA: <projeto / destino>
- Destino: <plataforma, emissora ou mídia>
- Loudness integrado: <valor> (<oficial | prática comum>), tolerância <±x>
- True peak máximo: <valor> dBTP
- Loudness range (se pedido): <valor> LU
- Formato do arquivo: <WAV | AIFF | ADM BWF | MP4 | DDP>
- Sample rate: <44,1 | 48 | 96> kHz
- Bit depth / codec: <16 | 24 bits | AAC xxx kbps | MP3 xxx kbps>
- Canais: <mono | estéreo | 5.1 | 7.1.4 / bed + objects>
- Versões e stems: <mix completa, sem locução, instrumental, stems D/M/E...>
- Nome dos arquivos: <padrão combinado>
- Metadados: <ISRC, títulos, timecode inicial, slate...>
- Checagens antes de enviar: medição de loudness e true peak, escuta em mono, escuta no celular e nos fones, início e fim sem cortes
- Confirmar com: <documentação oficial, emissora, agência ou distribuidora>
```
