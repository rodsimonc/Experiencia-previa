#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Evaluación estructurada de salidas de LLMs.

Este es el tipo de trabajo que hice como AI Trainer / evaluador (Turing,
Outlier): tomar respuestas generadas por un modelo y puntuarlas de forma
consistente y reproducible según una rúbrica, validando además que el formato
(p. ej. JSON) sea correcto. Acá está el esqueleto de ese proceso.

Uso:
    python llm_evaluation.py -i respuestas.jsonl
    (cada línea: {"id":..., "prompt":..., "respuesta":..., "referencia":...})
"""

import argparse
import json
import re
from statistics import mean


# ---- 1. Validación de formato (¿la salida es JSON válido y completo?) --------
def validar_json(texto, claves_requeridas):
    """Devuelve (ok, motivo). Un fallo de formato es un fallo, aunque el texto suene bien."""
    try:
        obj = json.loads(texto)
    except json.JSONDecodeError as e:
        return False, f"JSON inválido: {e}"
    faltan = [k for k in claves_requeridas if k not in obj]
    if faltan:
        return False, f"Faltan claves: {faltan}"
    return True, "ok"


# ---- 2. Rúbrica de puntuación (0-1 por dimensión) ---------------------------
def puntuar(respuesta, referencia):
    """
    Rúbrica simple y transparente. En un caso real cada dimensión puede ser
    revisada por un humano o por un modelo juez; lo importante es que los
    criterios sean explícitos y consistentes entre evaluadores.
    """
    dims = {}

    # Corrección aproximada: solapamiento de tokens con la referencia
    r = set(re.findall(r"\w+", respuesta.lower()))
    ref = set(re.findall(r"\w+", referencia.lower()))
    dims["correccion"] = len(r & ref) / len(ref) if ref else 0.0

    # Concisión: penaliza respuestas excesivamente largas
    dims["concision"] = 1.0 if len(respuesta.split()) <= 2 * len(referencia.split()) else 0.5

    # Seguridad/rechazo indebido: marca respuestas vacías o evasivas
    dims["completitud"] = 0.0 if len(respuesta.strip()) < 3 else 1.0

    score = mean(dims.values())
    return score, dims


# ---- 3. Evaluación de un lote y reporte agregado ----------------------------
def evaluar_lote(registros):
    resultados = []
    for reg in registros:
        score, dims = puntuar(reg.get("respuesta", ""), reg.get("referencia", ""))
        resultados.append({"id": reg.get("id"), "score": round(score, 3), **dims})

    print(f"Evaluados: {len(resultados)} ejemplos")
    print(f"Score promedio: {mean(r['score'] for r in resultados):.3f}")
    for dim in ("correccion", "concision", "completitud"):
        print(f"  {dim}: {mean(r[dim] for r in resultados):.3f}")
    # Casos peores (para revisión humana dirigida)
    peores = sorted(resultados, key=lambda r: r["score"])[:5]
    print("\nCasos a revisar (score más bajo):", [r["id"] for r in peores])
    return resultados


def main():
    p = argparse.ArgumentParser(description="Evaluación estructurada de salidas de LLM")
    p.add_argument("-i", required=True, help="Archivo .jsonl con las respuestas")
    args = p.parse_args()

    registros = []
    with open(args.i) as f:
        for linea in f:
            linea = linea.strip()
            if linea:
                registros.append(json.loads(linea))
    evaluar_lote(registros)


if __name__ == "__main__":
    main()

# =============================================================================
# Idea clave: evaluar LLMs de forma seria es un problema de DATOS, no de
# opinión. Requiere rúbricas explícitas, validación de formato (JSON), métricas
# agregadas, y dirigir la revisión humana hacia los peores casos. La
# consistencia entre evaluadores es tan importante como el puntaje mismo.
# =============================================================================
