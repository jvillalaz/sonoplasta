#!/usr/bin/env python3
"""Transcreve a fala de um vídeo ou áudio com marcação de tempo por palavra.

Uso: transcrever.py <arquivo> [--modelo small] [--idioma pt] [--saida <arquivo.transcricao.json>]

Gera <nome>.transcricao.json ao lado do arquivo, com a lista de palavras
(início, fim, palavra e probabilidade), para o marcar-cortes.py.
Precisa da biblioteca faster-whisper (pip install faster-whisper). O modelo é baixado
na primeira execução (o "small" tem cerca de 500 MB) e roda localmente: o áudio não sai do computador.
"""

import argparse
import json
import os
import sys


def main():
    parser = argparse.ArgumentParser(description="Transcrição com tempo por palavra (faster-whisper).")
    parser.add_argument("arquivo", help="vídeo ou áudio de entrada")
    parser.add_argument("--modelo", default="small", help="tiny, base, small, medium ou large-v3 (padrão: small)")
    parser.add_argument("--idioma", default="pt", help="código do idioma (padrão: pt)")
    parser.add_argument("--saida", help="arquivo JSON de saída (padrão: <nome>.transcricao.json)")
    args = parser.parse_args()

    if not os.path.isfile(args.arquivo):
        print(f"Erro: arquivo não encontrado: {args.arquivo}", file=sys.stderr)
        return 2

    try:
        from faster_whisper import WhisperModel
    except ImportError:
        print(
            "Erro: a biblioteca faster-whisper não está instalada.\n"
            "Instale e rode de novo:\n"
            "  pip install faster-whisper\n"
            "(no Windows, se o pip não for encontrado: py -m pip install faster-whisper)\n"
            "O ffmpeg também precisa estar instalado.",
            file=sys.stderr,
        )
        return 127

    saida = args.saida or os.path.splitext(args.arquivo)[0] + ".transcricao.json"

    print(f"Carregando o modelo '{args.modelo}' (a primeira vez baixa o modelo)...", file=sys.stderr)
    modelo = WhisperModel(args.modelo, device="auto", compute_type="auto")

    print(f"Transcrevendo {args.arquivo}...", file=sys.stderr)
    # Sem VAD: as pausas e os vícios precisam continuar na transcrição para serem marcados.
    # O prompt inicial com vícios ajuda o modelo a transcrevê-los em vez de omiti-los.
    segmentos, info = modelo.transcribe(
        args.arquivo,
        language=args.idioma,
        word_timestamps=True,
        vad_filter=False,
        condition_on_previous_text=False,
        initial_prompt="Ãh, é... então, tipo, né, hum, assim, a gente vai, vai começar.",
    )

    palavras = []
    texto = []
    for seg in segmentos:
        texto.append(seg.text.strip())
        for p in seg.words or []:
            palavras.append({
                "inicio": round(p.start, 3),
                "fim": round(p.end, 3),
                "palavra": p.word.strip(),
                "prob": round(p.probability, 3),
            })

    resultado = {
        "arquivo": os.path.basename(args.arquivo),
        "duracao": round(info.duration, 3),
        "idioma": info.language,
        "modelo": args.modelo,
        "texto": " ".join(texto),
        "palavras": palavras,
    }
    with open(saida, "w", encoding="utf-8") as f:
        json.dump(resultado, f, ensure_ascii=False, indent=1)

    print(f"{len(palavras)} palavras em {info.duration:.1f} s. Transcrição salva em: {saida}")
    return 0


if __name__ == "__main__":
    for fluxo in (sys.stdout, sys.stderr):
        if hasattr(fluxo, "reconfigure"):
            fluxo.reconfigure(encoding="utf-8")
    sys.exit(main())
