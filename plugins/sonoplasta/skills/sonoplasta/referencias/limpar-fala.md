# Limpeza automática de fala (silêncios, vícios e repetições)

Leia este arquivo quando o usuário pedir para tirar silêncios, "ãh", "né", "tipo" ou gaguejadas de um vídeo falado (Reels, TikTok, Shorts, YouTube, podcast em vídeo) e for possível rodar comandos. No claude.ai sem terminal, oriente a edição manual (ver `referencias/edicao-fala.md`).

Os scripts ficam em `scripts/limpar-fala/`. Eles só propõem cortes; quem aprova é o usuário.

## Regra principal

**Nunca aplique cortes sem aprovação.** O fluxo é sempre: transcrever → marcar → mostrar o relatório e esperar a aprovação ou as edições do usuário → aplicar. Só rode o `aplicar-cortes.sh` com `--aprovado` depois que o usuário disser explicitamente que aprova (todos os cortes ou a lista editada). Sem `--aprovado`, o script só lista os cortes e não grava nada.

## Requisitos

- `ffmpeg` e `awk` (os mesmos dos outros scripts, ver `referencias/scripts.md`).
- Python 3 para os scripts `.py`. No Windows, use `py` no lugar de `python3` se o `python3` abrir a Microsoft Store.
- Para transcrever: a biblioteca `faster-whisper` (`pip install faster-whisper`, ou `py -m pip install faster-whisper` no Windows). Na primeira vez, ela baixa o modelo (o `small` tem cerca de 500 MB). A transcrição roda no computador: o áudio não é enviado para nenhum serviço. Peça autorização ao usuário antes de instalar.
- O `marcar-cortes.py` usa só a biblioteca padrão do Python.

## Fluxo

1. **Diagnóstico (opcional, recomendado):** `bash scripts/diagnosticar.sh video.mp4`.
2. **Transcrever:** `python3 scripts/limpar-fala/transcrever.py video.mp4`
   - Gera `video.transcricao.json` com cada palavra, início e fim.
   - Opções: `--modelo` (`tiny`, `base`, `small`, `medium`, `large-v3`; padrão `small`) e `--idioma` (padrão `pt`). Modelos maiores erram menos e demoram mais.
3. **Marcar:** `python3 scripts/limpar-fala/marcar-cortes.py video.transcricao.json`
   - Gera `video.cortes.json` (lista de cortes) e `video.cortes.txt` (relatório), e mostra o relatório na tela.
   - Opções: `--silencio` (pausa mínima para virar corte, padrão 0,6 s) e `--respiro` (pausa mantida em cada corte de silêncio, padrão 0,15 s).
4. **Aprovação:** mostre o relatório inteiro ao usuário, com o total de tempo removido, e pergunte o que manter. Para manter um trecho, apague o corte do `cortes.json` ou troque `"aplicar": true` por `"aplicar": false`. Os tempos também podem ser ajustados à mão.
5. **Aplicar:** `bash scripts/limpar-fala/aplicar-cortes.sh video.mp4 video.cortes.json --aprovado`
   - Gera `video_limpo.mp4` (ou `_limpo.wav` para áudio), com imagem e som cortados juntos e microfades de 10 ms em cada emenda.
   - Confere a sincronia entre imagem e som e roda o `diagnosticar.sh` na saída.
   - Opções: `--fade <ms>` (padrão 10) e `--saida <arquivo>`.
6. **Escuta:** peça ao usuário para ouvir cada emenda. Se alguma soar cortada no meio de uma palavra, ajuste os tempos daquele corte no `cortes.json` e aplique de novo a partir do original.
7. **Loudness:** depois da limpeza, normalize para o destino (`preparar-reels.sh` ou `normalizar.sh`).

## O que o marcar-cortes.py procura

- **Silêncios:** pausas acima de `--silencio` entre palavras, no início e no fim. O corte mantém `--respiro` de pausa (metade antes e metade depois), para a fala não ficar sem ar.
- **Vícios sempre cortados:** "ãh", "ah", "eh", "éé", "hum", "hm", "uhm".
- **Vícios cortados só quando isolados:** "é", "tipo", "né", "então", "assim", "aí", "sabe", "tá", "bom", "enfim", "ok". Isolado quer dizer com pausa (0,25 s ou mais) ou pontuação dos dois lados, como em "Então, vamos lá". Dentro da frase ("o tipo de cabo", "isso é bom"), ficam.
- **Repetições acidentais:** a mesma palavra duas vezes seguidas ("o o microfone"). Corta a primeira ocorrência. Repetições enfáticas ficam: "muito, muito", "nunca nunca" e outras palavras da lista de ênfase, e qualquer repetição separada por vírgula.

Quando um vício cai numa pausa longa, o corte é um só e cobre os dois.

## Como ajustar

As listas e os limites ficam no topo do `marcar-cortes.py`, em "Listas e limites editáveis":

- `VICIOS_SEMPRE`: expressões regulares dos vícios que sempre saem.
- `VICIOS_ISOLADOS`: palavras que saem só quando isoladas. Tire "então" ou "assim" se o estilo do apresentador depender delas.
- `PAUSA_ISOLADA`: pausa mínima para considerar uma palavra isolada.
- `REPETICOES_ENFATICAS`: palavras cuja repetição nunca é cortada.
- `REPETICAO_MAX_INTERVALO`: distância máxima entre as duas ocorrências.

Valores de partida para `--silencio`:

| Estilo | `--silencio` | `--respiro` |
|---|---|---|
| Reels, TikTok, Shorts (ritmo rápido) | 0,4 a 0,6 s | 0,10 a 0,15 s |
| YouTube explicativo | 0,6 a 0,8 s | 0,15 a 0,20 s |
| Podcast, entrevista, conteúdo emotivo | 1,0 a 1,5 s | 0,25 a 0,40 s |

Cortar todas as pausas deixa a fala atropelada e cansativa. Pausas dramáticas e de respiração fazem parte do ritmo: na dúvida, corte menos.

## Limitações

- **Transcrição:** sotaques fortes, fala rápida, várias pessoas falando juntas e música alta por baixo aumentam os erros. O Whisper às vezes omite vícios ou junta palavras. Um modelo maior (`medium`) ajuda, mas o relatório sempre precisa de revisão.
- **Tempos das palavras:** a marcação por palavra tem precisão de algumas dezenas de milissegundos. Um corte pode pegar o começo ou o fim de uma palavra vizinha; ajuste os tempos no `cortes.json`.
- **Imagem:** os cortes geram jump cuts. Em vídeo com a pessoa falando para a câmera, isso costuma ser aceito em Reels. Em entrevistas com mais de uma câmera, prefira editar no editor de vídeo.
- **Recodificação:** o vídeo é recodificado em H.264 (CRF 18) e o áudio em AAC 320 kbps, porque cortar fora dos quadros-chave exige recodificar. Aplique sempre a partir do arquivo original, nunca sobre um `_limpo` anterior.
- **Música por baixo:** a trilha também é cortada a cada emenda. Prefira limpar a voz antes de pôr a música, ou corte no editor com a trilha numa faixa separada.
