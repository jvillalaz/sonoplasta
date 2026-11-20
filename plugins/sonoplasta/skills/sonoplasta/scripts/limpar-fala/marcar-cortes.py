#!/usr/bin/env python3
"""Propõe cortes de silêncios, vícios de fala e repetições a partir da transcrição.

Uso: marcar-cortes.py <arquivo.transcricao.json> [--silencio 0.6] [--respiro 0.15] [--saida <cortes.json>]

Gera <nome>.cortes.json (para revisar e passar ao aplicar-cortes.sh) e <nome>.cortes.txt
(relatório legível, também impresso na tela). Não altera nenhum áudio ou vídeo.
Usa só a biblioteca padrão do Python.
"""

import argparse
import json
import os
import re
import sys

# ---------------------------------------------------------------------------
# Listas e limites editáveis
# ---------------------------------------------------------------------------

# Vícios que sempre viram corte (expressões regulares sobre a palavra em minúsculas e sem pontuação).
VICIOS_SEMPRE = [
    r"ã+h*",        # ãh, ããh
    r"a+h+",        # ah, ahh
    r"e+h+",        # eh
    r"é{2,}h*",     # éé, ééé
    r"éh+",         # éh
    r"hu*m+",       # hum, humm, hm
    r"u+h*m+",      # uhm, um
    r"ah+m+",       # ahm
]

# Vícios que só viram corte quando aparecem isolados: entre pausas ou entre pontuações
# ("então, vamos", "aí, tipo, sabe"). Dentro da frase ("o tipo de microfone") ficam.
VICIOS_ISOLADOS = {"é", "tipo", "né", "então", "assim", "aí", "sabe", "tá", "bom", "enfim", "ok"}

# Pausa mínima (s) antes ou depois para considerar uma palavra isolada.
PAUSA_ISOLADA = 0.25

# Palavras que costumam ser repetidas de propósito ("muito, muito importante").
# Repetição dessas palavras nunca vira corte.
REPETICOES_ENFATICAS = {"muito", "bem", "nunca", "sempre", "não", "sim", "mais", "demais", "super"}

# Intervalo máximo (s) entre as duas ocorrências para considerar repetição acidental ("o o").
REPETICAO_MAX_INTERVALO = 1.0

# Padrões da linha de comando.
SILENCIO_PADRAO = 0.6
RESPIRO_PADRAO = 0.15

# ---------------------------------------------------------------------------

PONTUACAO = ".,;:!?…\"'“”()-–—"


def normalizar(palavra):
    return palavra.strip().strip(PONTUACAO).lower()


def termina_com_pausa_grafica(palavra):
    return palavra.rstrip().endswith((",", ".", "...", "…", "!", "?", ";", ":"))


def eh_vicio(i, palavras):
    p = palavras[i]
    n = normalizar(p["palavra"])
    if not n:
        return False
    if any(re.fullmatch(rx, n) for rx in VICIOS_SEMPRE):
        return True
    if n not in VICIOS_ISOLADOS:
        return False
    pausa_antes = p["inicio"] - palavras[i - 1]["fim"] if i > 0 else 99.0
    pausa_depois = palavras[i + 1]["inicio"] - p["fim"] if i + 1 < len(palavras) else 99.0
    antes_grafico = i == 0 or termina_com_pausa_grafica(palavras[i - 1]["palavra"])
    depois_grafico = termina_com_pausa_grafica(p["palavra"])
    # Isolada: pausa ou pontuação dos dois lados.
    return (pausa_antes >= PAUSA_ISOLADA or antes_grafico) and (pausa_depois >= PAUSA_ISOLADA or depois_grafico)


def eh_repeticao(i, palavras):
    """Verdadeiro se a palavra i é repetida logo em seguida (corta a primeira ocorrência)."""
    if i + 1 >= len(palavras):
        return False
    a, b = palavras[i], palavras[i + 1]
    na, nb = normalizar(a["palavra"]), normalizar(b["palavra"])
    if not na or na != nb or na in REPETICOES_ENFATICAS:
        return False
    if a["palavra"].rstrip().endswith(","):
        return False  # "muito, muito": vírgula indica ênfase
    return b["inicio"] - a["fim"] <= REPETICAO_MAX_INTERVALO


def seg(x):
    return f"{x:.2f}".replace(".", ",")


def tempo(s):
    m, seg = divmod(max(s, 0.0), 60)
    return f"{int(m):02d}:{seg:05.2f}"


def contexto(palavras, ini, fim, n=3):
    """Trecho de texto em volta das palavras [ini, fim], com as removidas entre colchetes."""
    antes = " ".join(p["palavra"] for p in palavras[max(0, ini - n):ini])
    meio = " ".join(p["palavra"] for p in palavras[ini:fim + 1])
    depois = " ".join(p["palavra"] for p in palavras[fim + 1:fim + 1 + n])
    return f"...{antes} [{meio}] {depois}...".replace("  ", " ")


def marcar(palavras, duracao, silencio, respiro):
    meio_respiro = respiro / 2
    remover = [None] * len(palavras)
    for i in range(len(palavras)):
        if eh_vicio(i, palavras):
            remover[i] = f'vício: "{normalizar(palavras[i]["palavra"])}"'
    for i in range(len(palavras)):
        if remover[i] is None and eh_repeticao(i, palavras) and remover[i + 1] is None:
            remover[i] = f'repetição: "{normalizar(palavras[i]["palavra"])}"'

    cortes = []
    mantidas = [i for i in range(len(palavras)) if remover[i] is None]

    def adicionar(inicio, fim, motivo, texto):
        if fim - inicio >= 0.02:
            cortes.append({"inicio": round(inicio, 3), "fim": round(fim, 3), "motivo": motivo, "texto": texto})

    # Pares de palavras mantidas consecutivas (com as removidas entre elas), mais início e fim do arquivo.
    limites = [None] + mantidas + [None]
    for a, b in zip(limites, limites[1:]):
        fim_a = palavras[a]["fim"] if a is not None else 0.0
        ini_b = palavras[b]["inicio"] if b is not None else duracao
        primeira = (a + 1) if a is not None else 0
        ultima = (b - 1) if b is not None else len(palavras) - 1
        removidas = list(range(primeira, ultima + 1))
        motivos = [remover[k] for k in removidas]
        texto = contexto(palavras, primeira, ultima) if removidas else ""
        pausa = ini_b - fim_a
        if pausa > silencio:
            ini_corte = 0.0 if a is None else fim_a + meio_respiro
            fim_corte = duracao if b is None else ini_b - meio_respiro
            if a is None:
                rotulo = "silêncio no início"
            elif b is None:
                rotulo = "silêncio no fim"
            else:
                rotulo = f"silêncio de {seg(pausa)} s"
            adicionar(ini_corte, fim_corte, " + ".join(motivos + [rotulo]), texto)
        elif removidas:
            # Pausa curta: corta só as palavras removidas, sem mexer no ritmo em volta.
            adicionar(palavras[removidas[0]]["inicio"], palavras[removidas[-1]]["fim"], " + ".join(motivos), texto)

    for n, c in enumerate(cortes, 1):
        c["id"] = n
        c["aplicar"] = True
    return cortes


def main():
    parser = argparse.ArgumentParser(description="Propõe cortes a partir da transcrição.")
    parser.add_argument("transcricao", help="arquivo .transcricao.json do transcrever.py")
    parser.add_argument("--silencio", type=float, default=SILENCIO_PADRAO,
                        help=f"pausa mínima (s) para virar corte (padrão: {SILENCIO_PADRAO})")
    parser.add_argument("--respiro", type=float, default=RESPIRO_PADRAO,
                        help=f"tempo de pausa mantido em cada corte de silêncio (padrão: {RESPIRO_PADRAO})")
    parser.add_argument("--saida", help="arquivo de cortes (padrão: <nome>.cortes.json)")
    args = parser.parse_args()

    try:
        with open(args.transcricao, encoding="utf-8") as f:
            dados = json.load(f)
        palavras = sorted(dados["palavras"], key=lambda p: p["inicio"])
        duracao = float(dados["duracao"])
    except (OSError, ValueError, KeyError) as erro:
        print(f"Erro: não foi possível ler a transcrição {args.transcricao}: {erro}", file=sys.stderr)
        return 2
    if args.respiro * 2 >= args.silencio:
        print("Erro: o respiro precisa ser menor que metade do limite de silêncio.", file=sys.stderr)
        return 2

    cortes = marcar(palavras, duracao, args.silencio, args.respiro)

    base = args.transcricao
    for sufixo in (".transcricao.json", ".json"):
        if base.endswith(sufixo):
            base = base[: -len(sufixo)]
            break
    saida = args.saida or base + ".cortes.json"
    relatorio_arq = os.path.splitext(saida)[0] + ".txt"

    resultado = {
        "arquivo": dados.get("arquivo", ""),
        "duracao": duracao,
        "parametros": {"silencio": args.silencio, "respiro": args.respiro},
        "cortes": [
            {"id": c["id"], "aplicar": True, "inicio": c["inicio"], "fim": c["fim"],
             "motivo": c["motivo"], "texto": c["texto"].replace("{", "(").replace("}", ")")}
            for c in cortes
        ],
    }
    with open(saida, "w", encoding="utf-8") as f:
        f.write("{\n")
        f.write(f' "arquivo": {json.dumps(resultado["arquivo"], ensure_ascii=False)},\n')
        f.write(f' "duracao": {duracao},\n')
        f.write(f' "parametros": {json.dumps(resultado["parametros"])},\n')
        f.write(' "cortes": [\n')
        linhas = [" " + json.dumps(c, ensure_ascii=False) for c in resultado["cortes"]]
        f.write(",\n".join(linhas))
        f.write("\n ]\n}\n")

    total = sum(c["fim"] - c["inicio"] for c in cortes)
    linhas = [f"Cortes propostos para {resultado['arquivo'] or args.transcricao} (duração {seg(duracao)} s)", ""]
    if not cortes:
        linhas.append("Nenhum corte proposto.")
    for c in cortes:
        linhas.append(f"{c['id']:>3}. {tempo(c['inicio'])} → {tempo(c['fim'])}  ({seg(c['fim'] - c['inicio'])} s)  {c['motivo']}")
        if c["texto"]:
            linhas.append(f"      {c['texto']}")
    linhas += [
        "",
        f"Total: {len(cortes)} corte(s), {seg(total)} s removidos"
        + (f" ({100 * total / duracao:.0f}% do arquivo), duração final de cerca de {seg(duracao - total)} s." if duracao else "."),
        "",
        f"Revise antes de aplicar. Para manter um trecho, apague o corte em {saida}",
        'ou troque "aplicar": true por "aplicar": false. Os tempos também podem ser ajustados.',
    ]
    relatorio = "\n".join(linhas)
    with open(relatorio_arq, "w", encoding="utf-8") as f:
        f.write(relatorio + "\n")
    print(relatorio)
    print(f"\nCortes: {saida}\nRelatório: {relatorio_arq}")
    return 0


if __name__ == "__main__":
    for fluxo in (sys.stdout, sys.stderr):
        if hasattr(fluxo, "reconfigure"):
            fluxo.reconfigure(encoding="utf-8")
    sys.exit(main())
