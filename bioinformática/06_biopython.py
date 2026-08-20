#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Manejo de secuencias con Biopython.

Demuestra tareas frecuentes cuando se trabaja con secuencias en Python:
descargar desde NCBI, leer/escribir FASTA, traducir, calcular composición y
filtrar por criterios. Biopython evita reinventar parsers y da acceso directo a
las bases de datos.

Uso de ejemplo:
    python 06_biopython.py -i secuencias.fasta -o filtradas.fasta

(La descarga desde NCBI requiere conexión y un email válido para Entrez.)
"""

import argparse
from Bio import SeqIO, Entrez
from Bio.SeqUtils import gc_fraction


def descargar_ncbi(ids, email):
    """Descarga secuencias de proteína de NCBI a partir de una lista de IDs."""
    Entrez.email = email  # NCBI lo exige para usar E-utilities
    handle = Entrez.efetch(db="protein", id=ids, rettype="fasta", retmode="text")
    registros = list(SeqIO.parse(handle, "fasta"))
    handle.close()
    return registros


def analizar(record):
    """Devuelve estadísticas básicas de una secuencia."""
    seq = record.seq
    return {
        "id": record.id,
        "largo": len(seq),
        "gc": round(gc_fraction(seq) * 100, 1) if set(seq) <= set("ACGTNacgtn") else None,
    }


def main():
    parser = argparse.ArgumentParser(description="Manejo de secuencias con Biopython")
    parser.add_argument("-i", required=True, help="FASTA de entrada")
    parser.add_argument("-o", default="filtradas.fasta", help="FASTA de salida (filtrado)")
    parser.add_argument("--min-len", type=int, default=100, help="Largo mínimo a conservar")
    args = parser.parse_args()

    # Leer todas las secuencias del archivo
    registros = list(SeqIO.parse(args.i, "fasta"))
    print(f"Leídas {len(registros)} secuencias")

    # Estadísticas por secuencia
    for r in registros[:5]:
        print(analizar(r))

    # Traducción de nucleótidos a proteína (si aplica)
    for r in registros[:3]:
        if set(str(r.seq).upper()) <= set("ACGTN"):
            print(f"{r.id} traducida: {r.seq.translate()[:30]}...")

    # Filtrar por largo mínimo y guardar
    filtradas = [r for r in registros if len(r.seq) >= args.min_len]
    SeqIO.write(filtradas, args.o, "fasta")
    print(f"Guardadas {len(filtradas)} secuencias (>= {args.min_len} aa/nt) en {args.o}")


if __name__ == "__main__":
    main()
