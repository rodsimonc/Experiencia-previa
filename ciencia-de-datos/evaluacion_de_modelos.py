#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Evaluación de modelos: métricas correctas y datasets desbalanceados.

Elegir la métrica equivocada es como medir con la regla equivocada. Este script
muestra cómo evaluar un clasificador de forma honesta cuando las clases están
desbalanceadas (el caso más común y traicionero), donde el 'accuracy' engaña.

Uso:
    python evaluacion_de_modelos.py -i datos.csv -t target
"""

import argparse
import numpy as np
import pandas as pd
from sklearn.model_selection import StratifiedKFold, cross_val_predict
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (classification_report, confusion_matrix,
                             roc_auc_score, average_precision_score,
                             precision_recall_curve)


def evaluar(X, y):
    modelo = LogisticRegression(max_iter=1000, class_weight="balanced")

    # Validación cruzada estratificada (mantiene la proporción de clases)
    cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
    prob = cross_val_predict(modelo, X, y, cv=cv, method="predict_proba")[:, 1]
    pred = (prob >= 0.5).astype(int)

    print("Distribución de clases:", np.bincount(y), "(desbalanceada si difieren mucho)")
    print("\nMatriz de confusión:\n", confusion_matrix(y, pred))
    print("\nReporte (mirar recall/precision de la clase minoritaria, NO el accuracy):")
    print(classification_report(y, pred))

    # Con clases desbalanceadas, PR-AUC informa más que ROC-AUC
    print(f"ROC-AUC: {roc_auc_score(y, prob):.3f}")
    print(f"PR-AUC (average precision): {average_precision_score(y, prob):.3f}")

    # Elegir umbral según el costo del negocio (no siempre 0.5)
    prec, rec, thr = precision_recall_curve(y, prob)
    f1 = 2 * prec * rec / (prec + rec + 1e-9)
    mejor = np.argmax(f1)
    print(f"\nUmbral que maximiza F1: {thr[mejor]:.2f} "
          f"(precision={prec[mejor]:.2f}, recall={rec[mejor]:.2f})")


def main():
    p = argparse.ArgumentParser(description="Evaluación honesta de clasificadores")
    p.add_argument("-i", required=True, help="CSV de entrada")
    p.add_argument("-t", required=True, help="Columna objetivo (binaria 0/1)")
    args = p.parse_args()

    df = pd.read_csv(args.i)
    y = df[args.t].astype(int).values
    X = pd.get_dummies(df.drop(columns=[args.t]), drop_first=True).fillna(0).values
    evaluar(X, y)


if __name__ == "__main__":
    main()

# =============================================================================
# Idea clave: en datos desbalanceados el accuracy miente (un modelo que dice
# "siempre no" puede tener 95% de accuracy y ser inútil). Hay que mirar
# precision/recall de la clase minoritaria, PR-AUC, y elegir el umbral según el
# COSTO real de cada tipo de error en el negocio.
# =============================================================================
