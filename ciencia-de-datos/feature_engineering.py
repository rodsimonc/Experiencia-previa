#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Feature engineering y preprocesamiento reproducible.

El modelo casi nunca es el cuello de botella: lo son los datos y las variables.
Este script reúne patrones de preprocesamiento que uso, todos dentro de un
ColumnTransformer para que se ajusten SOLO con train (sin data leakage) y se
reapliquen igual en test/producción.

Uso:
    python feature_engineering.py -i datos.csv
"""

import argparse
import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.pipeline import Pipeline
from sklearn.impute import SimpleImputer
from sklearn.preprocessing import StandardScaler, OneHotEncoder, KBinsDiscretizer


def features_de_fecha(df, col):
    """Descompone una fecha en variables útiles (estacionalidad, tendencia)."""
    s = pd.to_datetime(df[col], errors="coerce")
    return pd.DataFrame({
        f"{col}_anio": s.dt.year,
        f"{col}_mes": s.dt.month,
        f"{col}_dia_semana": s.dt.dayofweek,
        f"{col}_es_finde": (s.dt.dayofweek >= 5).astype(int),
    })


def construir_preprocesador(num_cols, cat_cols):
    """Preprocesamiento estándar: imputar + escalar / imputar + one-hot."""
    return ColumnTransformer([
        ("num", Pipeline([
            ("imputar", SimpleImputer(strategy="median")),
            ("escalar", StandardScaler()),
        ]), num_cols),
        ("cat", Pipeline([
            ("imputar", SimpleImputer(strategy="most_frequent")),
            ("onehot", OneHotEncoder(handle_unknown="ignore", sparse_output=False)),
        ]), cat_cols),
    ])


def main():
    p = argparse.ArgumentParser(description="Feature engineering reproducible")
    p.add_argument("-i", required=True, help="CSV de entrada")
    args = p.parse_args()

    df = pd.read_csv(args.i)

    num_cols = df.select_dtypes(include=np.number).columns.tolist()
    cat_cols = df.select_dtypes(exclude=np.number).columns.tolist()

    # Ejemplos de variables derivadas
    # - interacción entre dos numéricas
    if len(num_cols) >= 2:
        df["interaccion"] = df[num_cols[0]] * df[num_cols[1]]
    # - binning de una numérica en cuantiles (a veces ayuda a modelos lineales)
    if num_cols:
        kb = KBinsDiscretizer(n_bins=4, encode="ordinal", strategy="quantile")
        df[f"{num_cols[0]}_bin"] = kb.fit_transform(df[[num_cols[0]]]).astype(int)

    prep = construir_preprocesador(num_cols, cat_cols)
    X = prep.fit_transform(df)
    print(f"Matriz de features lista: {X.shape[0]} filas x {X.shape[1]} columnas")
    print("El mismo 'prep' se reaplica a datos nuevos con prep.transform(...).")


if __name__ == "__main__":
    main()

# =============================================================================
# Idea clave: encapsular TODO el preprocesamiento en un objeto reutilizable
# (ColumnTransformer/Pipeline) evita el error más común y silencioso — el data
# leakage — y hace que lo que funciona en el notebook funcione igual en
# producción.
# =============================================================================
