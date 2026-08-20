#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Descarga masiva de secuencias CODIFICANTES (CDS nucleotídicas) desde NCBI.

Variante del script de descarga: en lugar de la proteína, recupera la secuencia
de ADN codificante (formato fasta_cds_na). Útil cuando se necesita trabajar a
nivel de nucleótidos (p. ej. análisis de codones o retrotraducción).

Uso:
    python 02_descargar_cds_ncbi.py -i id_file.txt -o cds.fasta

Requisitos: NCBI EDirect instalado y en el PATH (efetch).

Autor original del script: Nicolas Stocchi.
Usado y adaptado por Carlos Rodríguez Simón (modernizado a Python 3).
"""

import os
import argparse
from datetime import datetime

start = datetime.now()

parser = argparse.ArgumentParser(description="Descarga CDS de NCBI por lista de IDs")
parser.add_argument("-i", default="id_file", help="Archivo con IDs (uno por línea)")
parser.add_argument("-o", default="output_file", help="Archivo FASTA de salida")
args = parser.parse_args()

with open(args.i) as f:
    codes = [line.split()[0] for line in f if line.strip()]

out_fastas = []
for n, code in enumerate(codes, start=1):
    # fasta_cds_na = secuencia codificante en nucleótidos
    os.system(f"efetch -db protein -format fasta_cds_na -id {code} > {code}.fa")
    out_fastas.append(f"{code}.fa")
    print(f"{code} ({n}/{len(codes)}) listo - tiempo total: {datetime.now() - start}")

os.system("cat " + " ".join(out_fastas) + f" > {args.o}")
for fa in out_fastas:
    os.remove(fa)

print(f"{args.o} generado - tiempo total: {datetime.now() - start}")
