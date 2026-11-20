# Frequências por fonte sonora

Leia este arquivo antes de indicar frequências de EQ para uma fonte específica, explicar por que dois instrumentos se mascaram ou avaliar o que vai sobrar de um som no alto-falante do celular. Para cadeias completas, veja `referencias/presets.md`. Para problemas, veja `referencias/troubleshooting.md`.

Os valores são faixas de partida. A frequência exata muda com o instrumento, a afinação, o microfone e a sala: encontre-a varrendo com um boost estreito e ouvindo onde soa pior (para cortar) ou melhor (para realçar). Faça cortes com Q mais alto e realces com Q mais baixo.

## Regiões do espectro

| Região | Faixa | Caráter | Excesso causa | Falta causa |
|---|---|---|---|---|
| Sub-grave | 20 a 60 Hz | Sentido mais que ouvido, impacto físico | Ronco, consumo de headroom, distorção em caixas pequenas | Falta de peso em sistemas grandes |
| Grave | 60 a 250 Hz | Base, calor, corpo | Som "inchado" e boomy | Som magro |
| Médio-grave | 250 a 500 Hz | Corpo e espessura; zona de embolamento | Lama, som abafado e "de caixa" | Som oco |
| Médio | 500 Hz a 2 kHz | Definição e "honk" | Som nasal, de telefone ou de buzina | Som distante e sem foco |
| Médio-agudo | 2 a 4 kHz | Inteligibilidade, ataque; o ouvido é mais sensível aqui | Aspereza e fadiga | Voz pouco clara |
| Presença | 4 a 6 kHz | Definição e proximidade | Som duro, início de sibilância | Som apagado |
| Brilho | 6 a 10 kHz | Sibilância, ataque de pratos e cordas | "S" ardido, chiado | Som opaco |
| Ar | 10 a 20 kHz | Abertura, respiração, "brilho caro" | Chiado, ruído realçado | Som fechado (mas quase ninguém sente falta só disso) |

## Tabela por fonte

Fundamental = faixa das notas tocadas ou cantadas. As outras colunas indicam onde costuma estar cada característica.

| Fonte | Fundamental | Corpo | Embolamento | Presença / ataque | Sibilância / brilho | Ar | Costuma cortar | Costuma realçar |
|---|---|---|---|---|---|---|---|---|
| Voz masculina (fala) | ~85 a 180 Hz | 120 a 250 Hz | 200 a 400 Hz | 2 a 4 kHz | 5 a 8 kHz | 10 a 12 kHz+ | Abaixo de 70 a 90 Hz; 200 a 400 Hz se embolar | 2 a 4 kHz (clareza); ar com cuidado |
| Voz feminina (fala) | ~165 a 255 Hz | 200 a 350 Hz | 250 a 500 Hz | 3 a 5 kHz | 6 a 10 kHz | 12 kHz+ | Abaixo de 100 a 120 Hz; 300 a 500 Hz | 3 a 5 kHz; ar |
| Voz infantil | ~250 a 400 Hz | 300 a 500 Hz | 400 a 700 Hz | 3 a 6 kHz | 7 a 10 kHz | 12 kHz+ | Abaixo de 150 Hz; pico agudo estridente entre 2 e 4 kHz | Pouco: a voz já é brilhante |
| Coral (conjunto) | Baixos ~80 a 330 Hz; sopranos ~260 Hz a 1 kHz | 150 a 300 Hz | 200 a 500 Hz (sala) | 2 a 5 kHz | 5 a 9 kHz (sibilância coletiva) | 10 kHz+ | Abaixo de 60 a 80 Hz; 200 a 400 Hz se a sala embolar | Ar suave; evite realçar 2 a 5 kHz em massa |
| Violão | ~82 Hz a 1 kHz | 80 a 200 Hz | 150 a 300 Hz (ronco do corpo) | 2 a 5 kHz (dedilhado e palheta) | 5 a 10 kHz (cordas) | 12 kHz+ | Abaixo de 80 a 150 Hz em mix cheia; 150 a 300 Hz; ressonância entre 800 Hz e 1,2 kHz | 5 a 10 kHz; 2 a 3 kHz para definição |
| Piano | ~27 Hz a 4,2 kHz | 80 a 250 Hz | 200 a 500 Hz | 2 a 5 kHz (martelos) | 5 a 8 kHz | 10 kHz+ | Abaixo de 60 a 150 Hz em mix cheia; 200 a 500 Hz | 2 a 5 kHz para aparecer; ar |
| Baixo elétrico | ~41 Hz a 400 Hz (31 Hz no de 5 cordas) | 60 a 100 Hz | 200 a 300 Hz | 700 Hz a 1,5 kHz (definição); 2 a 4 kHz (dedo e palheta) | Ruído de traste 3 a 5 kHz | Pouco útil | Abaixo de 30 a 40 Hz; 200 a 300 Hz | 700 Hz a 1,5 kHz (aparece no celular) |
| Bumbo | ~40 a 100 Hz | 50 a 80 Hz | 250 a 450 Hz ("papelão") | 2 a 5 kHz (beater) | — | — | Abaixo de 30 a 40 Hz; 250 a 450 Hz | 50 a 80 Hz; 2 a 5 kHz |
| Caixa | ~150 a 250 Hz | 180 a 250 Hz | 400 a 900 Hz (ring) | 4 a 6 kHz (estalo) | Esteira 6 a 10 kHz | 10 kHz+ | Abaixo de 80 a 100 Hz; ring estreito | 180 a 250 Hz; 4 a 6 kHz |
| Pratos e chimbal | Corpo ~300 a 600 Hz | — | 300 a 600 Hz (gongo) | 3 a 5 kHz | 6 a 12 kHz | 12 a 16 kHz+ | Abaixo de 200 a 400 Hz; 2 a 4 kHz se agredir | Ar com cuidado |
| Guitarra elétrica | ~82 Hz a 1,2 kHz | 100 a 250 Hz | 200 a 500 Hz | 1,5 a 4 kHz (mordida) | 4 a 6 kHz (fizz da distorção) | Pouco útil acima de ~8 kHz em guitarra distorcida | Abaixo de 80 a 120 Hz; acima de 6 a 8 kHz na distorcida | 1,5 a 3 kHz para aparecer |
| Metais (trompete, trombone, sax) | Trompete ~165 Hz a 1,2 kHz; trombone ~80 a 600 Hz; sax alto ~140 a 830 Hz | 150 a 400 Hz | 300 a 600 Hz | 1 a 3 kHz (brilho do metal) | 5 a 8 kHz (ar e sopro) | 10 kHz+ | Abaixo de 80 a 150 Hz; aspereza entre 2 e 4 kHz em naipe alto | 1 a 3 kHz com cuidado |

Os harmônicos de quase todas essas fontes vão bem acima da fundamental, até 8 a 15 kHz. É por isso que um instrumento continua reconhecível mesmo com a fundamental cortada.

## Mascaramento: quem briga com quem

- **Voz × violão, piano, guitarras e teclados:** brigam em 200 a 500 Hz (corpo) e em 2 a 5 kHz (clareza). Resolva no arranjo (oitava, voicing) antes da EQ. Depois, corte 2 a 3 dB nos instrumentos nessas faixas, ou use EQ dinâmica com sidechain da voz.
- **Bumbo × baixo:** brigam em 50 a 100 Hz. Escolha quem fica com o sub e quem fica com o corpo, e use sidechain leve do bumbo no baixo (ver `referencias/presets.md`).
- **Caixa × voz:** brigam em 2 a 5 kHz. Mantenha o estalo da caixa mais perto de 4 a 6 kHz e a presença da voz mais perto de 2 a 4 kHz, ou o contrário, conforme a música.
- **Pratos × sibilância:** brigam em 6 a 10 kHz. Pratos muito brilhantes realçam os "s" da voz na percepção.
- **Trilha × voz falada:** música com letra ou com melodia na região de 1 a 4 kHz compete com a fala. Corte essa faixa na trilha durante a fala ou faça ducking (ver `referencias/edicao-fala.md`).

## O que o alto-falante do celular reproduz

- **Abaixo de ~150 a 200 Hz:** quase nada. O grave fundamental do bumbo, do baixo e do 808 some. A percepção de grave vem dos harmônicos (100 a 1.500 Hz), por isso a saturação ajuda.
- **200 Hz a 1 kHz:** reproduz, mas sem peso. O excesso de 200 a 500 Hz soa como "caixa" no celular.
- **1 a 5 kHz:** é onde o celular é mais forte e onde a inteligibilidade mora. A voz precisa estar clara aqui. Excesso aqui cansa rápido em alto-falante pequeno.
- **Acima de ~10 a 12 kHz:** cai bastante e varia muito entre aparelhos. Ar e brilho extremo quase não fazem diferença no celular, mas o chiado realçado aparece em fones.
- **Mono:** muitos celulares tocam em mono, ou com os alto-falantes muito próximos. Elementos com fase ruim ou largura exagerada somem (ver `scripts/checar-mono.sh`).

Consequência prática: confira a mix no celular, garanta a clareza em 1 a 5 kHz, dê harmônicos ao grave e não use o grave fundamental para carregar a música. Detalhes em "Grave que some no celular" (`referencias/troubleshooting.md`) e em `referencias/instagram-criadores.md`.

Fontes: tabela de fundamentais e guia de regiões adaptados e traduzidos de `audio-engineering-patterns` (4444J99/a-i--skills, Apache-2.0), cruzados com as referências da sonoplasta. Os avisos de licença estão em `LICENCAS-TERCEIROS.md`.
