#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Descarga masiva de secuencias de proteína desde NCBI a partir de una lista de IDs.

Usa NCBI EDirect (efetch) para, dado un archivo con identificadores (uno por
línea), bajar cada secuencia en formato FASTA y concatenarlas en un único
archivo de salida. Pensado para automatizar la obtención de datos cuando se
trabaja con decenas o cientos de secuencias.

Uso:
    python 01_descargar_secuencias_ncbi.py -i id_file.txt -o proteinas.fasta

Requisitos: NCBI EDirect instalado y en el PATH (efetch).

Autor original del script: Nicolas Stocchi.
Usado y adaptado por Carlos Rodríguez Simón en el marco de sus trabajos
prácticos de bioinformática (modernizado a Python 3).
"""

import os
import argparse
from datetime import datetime

start = datetime.now()

parser = argparse.ArgumentParser(description="Descarga proteínas de NCBI por lista de IDs")
parser.add_argument("-i", default="id_file", help="Archivo con IDs (uno por línea)")
parser.add_argument("-o", default="output_file", help="Archivo FASTA de salida")
args = parser.parse_args()

# ---- Leer la lista de identificadores ---------------------------------------
with open(args.i) as f:
    codes = [line.split()[0] for line in f if line.strip()]

# ---- Descargar cada secuencia y acumular ------------------------------------
out_fastas = []
for n, code in enumerate(codes, start=1):
    os.system(f"efetch -db protein -format fasta -id {code} > {code}.fa")
    out_fastas.append(f"{code}.fa")
    print(f"{code} ({n}/{len(codes)}) listo - tiempo total: {datetime.now() - start}")

# ---- Unir todo en un solo archivo y limpiar los temporales ------------------
os.system("cat " + " ".join(out_fastas) + f" > {args.o}")
for fa in out_fastas:
    os.remove(fa)

print(f"{args.o} generado - tiempo total: {datetime.now() - start}")
