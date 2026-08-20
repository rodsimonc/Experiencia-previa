#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Convierte un multiFASTA (secuencia repartida en varias líneas) a formato de
UNA línea por secuencia.

Muchas herramientas esperan la secuencia completa en una sola línea. Este script
recorre el archivo, junta los fragmentos de cada secuencia y los reescribe con
la cabecera (>) seguida de la secuencia entera en una línea.

Uso:
    python 03_multifasta_a_singlefasta.py -i entrada.fasta -o salida.fasta

Autores originales del script: Agustín Amalfitano, Arjen ten Have.
Usado y adaptado por Carlos Rodríguez Simón (modernizado a Python 3).
"""

import argparse

parser = argparse.ArgumentParser(description="MultiFASTA -> una línea por secuencia")
parser.add_argument("-i", default="entrada.fasta", help="FASTA de entrada (multilínea)")
parser.add_argument("-o", default="salida.fasta", help="FASTA de salida (una línea)")
args = parser.parse_args()

# ---- Leer y reconstruir cada secuencia --------------------------------------
names, sequences, current = [], [], ""
with open(args.i) as f:
    for line in f:
        line = line.strip()
        if line.startswith(">"):
            if current:                 # guardar la secuencia anterior ya completa
                sequences.append(current)
            names.append(line)          # nueva cabecera
            current = ""                # reiniciar acumulador
        else:
            current += line             # concatenar fragmento de secuencia
sequences.append(current)               # guardar la última

# ---- Escribir la salida -----------------------------------------------------
with open(args.o, "w") as f:
    for name, seq in zip(names, sequences):
        f.write(f"{name}\n{seq}\n")

print(f"Listo: {len(names)} secuencias escritas en {args.o}")
