# Presets da sonoplasta

<!--
Modelo de presets do usuário para a skill sonoplasta.

Como usar:
1. Os valores deste modelo são exemplos: troque pelos seus.
2. Copie este arquivo para a pasta do seu projeto (a pasta onde você abre o Claude Code),
   com o nome exato `sonoplasta-presets.md`.
3. Preencha só o que quiser. Apague as seções que não usar.
4. O que você escrever aqui tem prioridade sobre os presets genéricos da skill.
   O que você não escrever continua vindo dos presets genéricos.

A skill procura este arquivo só na pasta de trabalho. Ela não lê pastas pessoais ocultas
nem outros locais do computador.

Os avisos de segurança (audição, true peak, direitos autorais) e as especificações
oficiais de plataformas e emissoras continuam valendo mesmo que este arquivo diga outra coisa.
Se um alvo seu ficar fora da especificação de um destino, a skill avisa antes de seguir.

No claude.ai, sem acesso à pasta, cole o conteúdo deste arquivo na conversa.
-->

## Meu contexto

<!-- Ajuda a skill a calibrar o nível das respostas e as sugestões de equipamento. -->

- **Trabalho principal:** vídeos para YouTube e Reels de um canal de culinária
- **Nível técnico:** intermediário
- **DAW / editor:** Reaper; DaVinci Resolve para vídeo
- **Monitoração:** Yamaha HS5 em sala parcialmente tratada; fones Sony MDR-7506
- **Microfones:** Shure SM7B (voz), Rode NT-USB Mini (backup)
- **Interface:** Focusrite Scarlett 2i2

## Plugins disponíveis

<!-- Liste o que você tem. A skill passa a sugerir esses plugins nas cadeias,
     em vez de descrever só o tipo de processador. -->

- **EQ:** ReaEQ, TDR Nova
- **Compressor:** ReaComp, (estilo 1176) Arturia Comp FET-76
- **De-esser:** TDR Nova (banda dinâmica)
- **Redução de ruído:** ReaFIR, iZotope RX Elements
- **Limiter:** LoudMax
- **Medidor:** Youlean Loudness Meter (gratuito)

## Alvos preferidos

<!-- Substituem os alvos genéricos apenas onde você preencher.
     Use os valores da especificação do destino quando houver uma (TV, comerciais). -->

| Destino | Loudness integrado | True peak | Observação |
|---|---|---|---|
| YouTube | −14 LUFS | −1 dBTP | |
| Reels / TikTok / Shorts | −14 LUFS | −1,5 dBTP | |
| Podcast | −16 LUFS | −1 dBTP | estéreo |

## Cadeias

<!-- Escreva as cadeias na ordem do sinal, com os valores que você já usa.
     Use o mesmo nome de fonte dos presets genéricos (voz falada, voz cantada, violão,
     bateria, baixo) para substituir aquela cadeia, ou crie uma fonte nova. -->

### Voz falada

1. ReaFIR em modo subtract, com o room tone capturado (redução de no máximo 8 dB)
2. ReaEQ: HPF 80 Hz; −3 dB em 250 Hz, Q 1,5
3. Comp FET-76: ratio 4:1, attack lento, release rápido, 3 a 4 dB de GR
4. ReaComp: ratio 2:1, 2 dB de GR constante
5. TDR Nova: banda dinâmica em 6,5 kHz, 3 dB de GR
6. LoudMax: teto em −1,5 dB

## Preferências

<!-- Gostos e regras do seu trabalho. -->

- Prefiro voz mais escura, sem brilho exagerado.
- Exportar sempre WAV 48 kHz / 24 bits antes de gerar o MP4.
- Explicar o porquê só quando eu perguntar.
