#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Plantilla reutilizable de Análisis Exploratorio de Datos (EDA).

Primeros pasos cuando llega un dataset nuevo: cargarlo, entender su estructura,
detectar problemas de calidad y mirar distribuciones y relaciones antes de
modelar. Pensada como punto de partida, se adapta a cualquier CSV.

Uso:
    python plantilla_EDA.py -i datos.csv -t target
"""

import argparse
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


def resumen(df):
    """Vista rápida de estructura, tipos y calidad del dataset."""
    print("Dimensiones:", df.shape)
    print("\nTipos y no-nulos:")
    print(df.dtypes)
    print("\nFaltantes por columna (%):")
    print((df.isna().mean() * 100).round(1).sort_values(ascending=False))
    print("\nDuplicados:", df.duplicated().sum())
    print("\nEstadísticos (numéricas):")
    print(df.describe().T)


def graficos(df, target=None):
    """Distribuciones de las variables numéricas y matriz de correlación."""
    num = df.select_dtypes(include=np.number)

    # Histogramas
    num.hist(figsize=(12, 8), bins=30)
    plt.tight_layout(); plt.savefig("eda_histogramas.png", dpi=120); plt.close()

    # Matriz de correlación
    if num.shape[1] > 1:
        corr = num.corr()
        fig, ax = plt.subplots(figsize=(8, 6))
        im = ax.imshow(corr, cmap="coolwarm", vmin=-1, vmax=1)
        ax.set_xticks(range(len(corr))); ax.set_xticklabels(corr.columns, rotation=90)
        ax.set_yticks(range(len(corr))); ax.set_yticklabels(corr.columns)
        fig.colorbar(im); plt.title("Matriz de correlación")
        plt.tight_layout(); plt.savefig("eda_correlacion.png", dpi=120); plt.close()

    # Relación de cada numérica con el target (si es categórico)
    if target and target in df.columns and df[target].nunique() < 15:
        for col in num.columns:
            if col == target:
                continue
            df.boxplot(column=col, by=target)
            plt.title(f"{col} por {target}"); plt.suptitle("")
            plt.savefig(f"eda_{col}_por_{target}.png", dpi=120); plt.close()


def main():
    p = argparse.ArgumentParser(description="EDA reutilizable")
    p.add_argument("-i", required=True, help="CSV de entrada")
    p.add_argument("-t", default=None, help="Nombre de la columna objetivo (opcional)")
    args = p.parse_args()

    df = pd.read_csv(args.i)
    resumen(df)
    graficos(df, args.t)
    print("\nListo. Figuras guardadas como eda_*.png")


if __name__ == "__main__":
    main()
