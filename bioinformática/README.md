# Bioinformática

Esto es lo que sé hacer cuando me llegan **secuencias biológicas** (ADN o proteínas) o
una lista de identificadores: obtenerlas, limpiarlas, analizarlas, alinearlas e inferir
relaciones evolutivas. El trabajo combina **Python** (para automatizar) con herramientas
estándar de línea de comandos (**EMBOSS**, **PhyML**, alineadores).

---

## Qué hago cuando recibo datos (secuencias / IDs)

1. **Obtención**: si tengo IDs, descargo las secuencias de NCBI en lote con EDirect.
2. **Limpieza y formato**: normalizo FASTA/multiFASTA, saco duplicados, unifico cabeceras.
3. **Control de calidad**: largo de secuencias, composición, cobertura del alineamiento.
4. **Análisis** según la pregunta: ORFs y traducción, motivos, estructura secundaria, homología (BLAST).
5. **Alineamiento múltiple** (Clustal / MAFFT / MUSCLE) y curado de columnas.
6. **Filogenia**: selección de modelo, inferencia con PhyML, visualización del árbol.

---

## Contenido

| Archivo | Qué hace |
|---|---|
| [`01_descargar_secuencias_ncbi.py`](./01_descargar_secuencias_ncbi.py) | Descarga masiva de proteínas desde NCBI a partir de una lista de IDs (EDirect / `efetch`) |
| [`02_descargar_cds_ncbi.py`](./02_descargar_cds_ncbi.py) | Igual, pero recupera las secuencias codificantes (CDS nucleotídicas) |
| [`03_multifasta_a_singlefasta.py`](./03_multifasta_a_singlefasta.py) | Convierte un multiFASTA (secuencia en varias líneas) a una línea por secuencia |
| [`04_analisis_secuencias_EMBOSS.md`](./04_analisis_secuencias_EMBOSS.md) | Workflow de análisis de secuencias con EMBOSS (ORFs, traducción, motivos, estructura 2ª) |
| [`05_alineamiento_y_filogenia.md`](./05_alineamiento_y_filogenia.md) | Workflow de alineamiento múltiple e inferencia filogenética con PhyML |

---

## Herramientas y para qué sirven

- **NCBI EDirect (`efetch`, `esearch`)** — acceso programático a las bases de datos de
  NCBI desde la terminal; ideal para bajar cientos de secuencias sin clics.
- **EMBOSS** — suite clásica de análisis de secuencias: traducción (`transeq`),
  detección de regiones codificantes (`tcode`), ORFs (`plotorf`, `showorf`),
  estructura secundaria (`garnier`), hélices/coiled-coils (`pepcoil`, `pepwheel`,
  `helixturnhelix`), búsqueda de motivos (`patmatmotifs`).
- **Alineadores (Clustal Omega / MAFFT / MUSCLE)** — alineamiento múltiple de secuencias.
- **PhyML** — inferencia filogenética por máxima verosimilitud.
- **Mesquite / Dendroscope** — manipulación y visualización de árboles y matrices.
- **BLAST** — búsqueda de homología contra bases de datos (p. ej. Swiss-Prot).
- **Cytoscape** — visualización de redes (p. ej. similitud entre secuencias).
- **Python** (`argparse`, manejo de archivos) — pegamento que automatiza todo el pipeline.

> Los scripts de Python están escritos con `argparse`, así que son **reutilizables**
> desde la línea de comandos con distintos archivos de entrada/salida, no hard-codeados
> a un caso puntual.
