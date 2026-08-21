#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Análisis de experimentos A/B (test de hipótesis para decisiones de negocio).

Un A/B test bien hecho es donde mi fondo estadístico marca la diferencia: no
alcanza con "B convirtió más", hay que preguntarse si esa diferencia es real o
ruido, con qué potencia, y qué tamaño de efecto. Este script cubre el flujo
completo: tamaño de muestra, test, tamaño de efecto e intervalo de confianza.

Uso:
    python estadistica_ab_testing.py
"""

import numpy as np
from scipy import stats
from statsmodels.stats.proportion import proportions_ztest, confint_proportions_2indep
from statsmodels.stats.power import NormalIndPower


# ---- 1. Diseño: ¿cuántos usuarios necesito por grupo? -----------------------
def tamano_muestra(p_base, efecto_min, alpha=0.05, power=0.8):
    """N por grupo para detectar una mejora 'efecto_min' sobre 'p_base'."""
    p2 = p_base + efecto_min
    h = 2 * np.arcsin(np.sqrt(p2)) - 2 * np.arcsin(np.sqrt(p_base))  # effect size de Cohen
    n = NormalIndPower().solve_power(effect_size=h, alpha=alpha, power=power, alternative="two-sided")
    return int(np.ceil(n))


# ---- 2. Análisis de un test de conversión (proporciones) --------------------
def analizar_ab(conv_a, n_a, conv_b, n_b, alpha=0.05):
    tasa_a, tasa_b = conv_a / n_a, conv_b / n_b

    # Test z de dos proporciones
    stat, pval = proportions_ztest([conv_b, conv_a], [n_b, n_a], alternative="two-sided")

    # Intervalo de confianza para la diferencia B - A
    low, high = confint_proportions_2indep(conv_b, n_b, conv_a, n_a, method="wald")

    # Lift relativo
    lift = (tasa_b - tasa_a) / tasa_a

    print(f"Tasa A: {tasa_a:.3%}  |  Tasa B: {tasa_b:.3%}")
    print(f"Lift relativo: {lift:+.1%}")
    print(f"p-valor: {pval:.4f}  ->  {'significativo' if pval < alpha else 'NO significativo'} (alpha={alpha})")
    print(f"IC 95% de la diferencia (B-A): [{low:+.3%}, {high:+.3%}]")
    if low > 0:
        print("Conclusión: B es mejor con evidencia estadística.")
    elif high < 0:
        print("Conclusión: A es mejor con evidencia estadística.")
    else:
        print("Conclusión: el IC cruza 0 — no hay evidencia suficiente para decidir.")


if __name__ == "__main__":
    # Diseño previo
    n = tamano_muestra(p_base=0.10, efecto_min=0.02)
    print(f"Necesito ~{n} usuarios por grupo para detectar +2 puntos de conversión.\n")

    # Resultado del experimento (datos de ejemplo)
    analizar_ab(conv_a=520, n_a=5000, conv_b=590, n_b=5000)

# =============================================================================
# Idea clave: decidir con datos exige (1) diseñar el experimento ANTES (tamaño
# de muestra y potencia), (2) reportar tamaño de efecto e intervalo de
# confianza, no solo el p-valor, y (3) traducir el resultado a una recomendación
# de negocio clara. El p-valor solo nunca alcanza.
# =============================================================================
