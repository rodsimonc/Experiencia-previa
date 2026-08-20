#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pipeline de machine learning en Python (scikit-learn).

Flujo de punta a punta para un problema de clasificación: preprocesamiento
(numéricas + categóricas), entrenamiento con validación cruzada y evaluación
honesta en un conjunto de prueba. El uso de Pipeline evita fugas de información
(data leakage): el preprocesamiento se ajusta SOLO con los datos de train.

Uso:
    python pipeline_ml_python.py -i datos.csv -t target
"""

import argparse
import pandas as pd
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import classification_report, roc_auc_score


def construir_pipeline(num_cols, cat_cols):
    """Preprocesamiento + modelo en un solo objeto reutilizable."""
    prep = ColumnTransformer([
        ("num", Pipeline([("imp", SimpleImputer(strategy="median")),
                          ("sc", StandardScaler())]), num_cols),
        ("cat", Pipeline([("imp", SimpleImputer(strategy="most_frequent")),
                          ("oh", OneHotEncoder(handle_unknown="ignore"))]), cat_cols),
    ])
    return Pipeline([("prep", prep),
                     ("clf", RandomForestClassifier(n_estimators=300, random_state=42))])


def main():
    p = argparse.ArgumentParser(description="Pipeline de ML (clasificación)")
    p.add_argument("-i", required=True, help="CSV de entrada")
    p.add_argument("-t", required=True, help="Columna objetivo")
    args = p.parse_args()

    df = pd.read_csv(args.i)
    y = df[args.t]
    X = df.drop(columns=[args.t])

    num_cols = X.select_dtypes(include="number").columns.tolist()
    cat_cols = X.select_dtypes(exclude="number").columns.tolist()

    # Separo train/test ANTES de tocar los datos (para evaluar sin engañarme)
    X_tr, X_te, y_tr, y_te = train_test_split(
        X, y, test_size=0.25, stratify=y, random_state=42)

    modelo = construir_pipeline(num_cols, cat_cols)

    # Validación cruzada sobre el train (estimación robusta del desempeño)
    cv = cross_val_score(modelo, X_tr, y_tr, cv=5, scoring="roc_auc")
    print(f"ROC-AUC (CV 5-fold): {cv.mean():.3f} ± {cv.std():.3f}")

    # Entrenamiento final y evaluación en el test reservado
    modelo.fit(X_tr, y_tr)
    pred = modelo.predict(X_te)
    print("\nReporte de clasificación (test):")
    print(classification_report(y_te, pred))

    if len(y.unique()) == 2:
        proba = modelo.predict_proba(X_te)[:, 1]
        print(f"ROC-AUC (test): {roc_auc_score(y_te, proba):.3f}")


if __name__ == "__main__":
    main()
