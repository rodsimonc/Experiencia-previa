#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Segmentación no supervisada (clustering) + reducción de dimensiones.

Caso típico de negocio: "agrupá a los clientes/usuarios en segmentos". Sin
etiquetas, hay que (1) elegir bien la cantidad de grupos, (2) validar que los
grupos sean reales y (3) interpretarlos. Combino KMeans con PCA para visualizar.

Uso:
    python clustering_y_segmentacion.py -i datos.csv
"""

import argparse
import numpy as np
import pandas as pd
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt


def elegir_k(X, k_max=8):
    """Método del codo (inercia) + silhouette para elegir el número de grupos."""
    inercias, sils = [], []
    ks = range(2, k_max + 1)
    for k in ks:
        km = KMeans(n_clusters=k, n_init=10, random_state=42).fit(X)
        inercias.append(km.inertia_)
        sils.append(silhouette_score(X, km.labels_))
    fig, ax = plt.subplots(1, 2, figsize=(11, 4))
    ax[0].plot(ks, inercias, "o-"); ax[0].set_title("Codo (inercia)"); ax[0].set_xlabel("k")
    ax[1].plot(ks, sils, "o-"); ax[1].set_title("Silhouette (mayor = mejor)"); ax[1].set_xlabel("k")
    plt.tight_layout(); plt.savefig("clustering_seleccion_k.png", dpi=120); plt.close()
    k_opt = ks[int(np.argmax(sils))]
    print(f"k sugerido por silhouette: {k_opt}")
    return k_opt


def main():
    p = argparse.ArgumentParser(description="Segmentación con KMeans + PCA")
    p.add_argument("-i", required=True, help="CSV de entrada (solo numéricas relevantes)")
    args = p.parse_args()

    df = pd.read_csv(args.i)
    X = StandardScaler().fit_transform(df.select_dtypes(include=np.number).fillna(0))

    k = elegir_k(X)
    km = KMeans(n_clusters=k, n_init=10, random_state=42).fit(X)
    df["segmento"] = km.labels_

    # Visualizar los grupos en 2D con PCA
    pcs = PCA(n_components=2).fit_transform(X)
    plt.figure(figsize=(7, 6))
    plt.scatter(pcs[:, 0], pcs[:, 1], c=km.labels_, cmap="tab10", s=15, alpha=0.7)
    plt.title(f"Segmentos (KMeans, k={k}) sobre PCA"); plt.xlabel("PC1"); plt.ylabel("PC2")
    plt.tight_layout(); plt.savefig("clustering_pca.png", dpi=120); plt.close()

    # Perfil de cada segmento (para interpretarlos)
    print("\nPerfil medio por segmento:")
    print(df.groupby("segmento").mean(numeric_only=True).round(2))


if __name__ == "__main__":
    main()

# =============================================================================
# Idea clave: clustering no es apretar un botón. Hay que estandarizar las
# variables, elegir k con criterio (codo + silhouette), validar que los grupos
# se sostengan y —lo más importante— PERFILAR cada segmento para que signifique
# algo para el negocio.
# =============================================================================
