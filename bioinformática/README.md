# Bioinformática

Esto es lo que sé hacer cuando me llegan **secuencias biológicas**, listas de IDs o
datos de secuenciación: obtenerlos, limpiarlos, analizarlos, alinearlos, inferir
relaciones evolutivas y analizar datos ómicos. Combino **Python** (incluido
**Biopython**) con herramientas estándar de línea de comandos (**EMBOSS**, **PhyML**,
alineadores, `mothur`).

---

## Qué hago cuando recibo datos

1. **Obtención**: descargo secuencias de NCBI en lote (EDirect o Biopython).
2. **Limpieza y formato**: normalizo FASTA/multiFASTA, saco duplicados, unifico cabeceras.
3. **Control de calidad**: largos, composición, cobertura del alineamiento, calidad de *reads*.
4. **Análisis** según la pregunta: ORFs y traducción, motivos, homología (BLAST),
   expresión diferencial, diversidad de comunidades, estructura de proteínas.
5. **Alineamiento múltiple** (Clustal / MAFFT / MUSCLE) y curado.
6. **Filogenia** (PhyML) y visualización.
7. Todo **automatizado y reproducible** con scripts y pipelines.

---

## Contenido

| Archivo | Qué hace |
|---|---|
| [`01_descargar_secuencias_ncbi.py`](./01_descargar_secuencias_ncbi.py) | Descarga masiva de proteínas desde NCBI (EDirect / `efetch`) |
| [`02_descargar_cds_ncbi.py`](./02_descargar_cds_ncbi.py) | Igual, pero recupera las CDS nucleotídicas |
| [`03_multifasta_a_singlefasta.py`](./03_multifasta_a_singlefasta.py) | Convierte multiFASTA a una línea por secuencia |
| [`04_analisis_secuencias_EMBOSS.md`](./04_analisis_secuencias_EMBOSS.md) | Workflow EMBOSS: ORFs, traducción, motivos, estructura 2ª |
| [`05_alineamiento_y_filogenia.md`](./05_alineamiento_y_filogenia.md) | Workflow de alineamiento múltiple + filogenia con PhyML |
| [`06_biopython.py`](./06_biopython.py) | Manejo de secuencias con Biopython: descarga, parsing, traducción, estadísticas |
| [`07_rnaseq_expresion_diferencial.md`](./07_rnaseq_expresion_diferencial.md) | Workflow de RNA-seq: de *reads* a genes diferencialmente expresados (DESeq2) |
| [`08_microbioma_metabarcoding.md`](./08_microbioma_metabarcoding.md) | Análisis de comunidades microbianas con `mothur`/QIIME (diversidad α/β) |
| [`09_estructura_proteinas.md`](./09_estructura_proteinas.md) | Modelado por homología, PDB y análisis estructural |
| [`10_pipelines_reproducibles.md`](./10_pipelines_reproducibles.md) | Automatización con bash, Snakemake/Nextflow y Docker |

---

## Herramientas y para qué sirven

- **NCBI EDirect / Biopython (`Bio.Entrez`, `SeqIO`)** — acceso programático a NCBI y
  manejo de secuencias desde Python.
- **EMBOSS** — análisis de secuencias (traducción, ORFs, estructura 2ª, motivos).
- **Alineadores (Clustal Omega / MAFFT / MUSCLE)** — alineamiento múltiple.
- **PhyML** — inferencia filogenética por máxima verosimilitud.
- **DESeq2 / edgeR** — expresión diferencial en RNA-seq.
- **mothur / QIIME** — metabarcoding y análisis de microbioma (diversidad, OTUs/ASVs).
- **BLAST** — búsqueda de homología.
- **Modelado por homología / PDB** — estructura tridimensional de proteínas.
- **Cytoscape** — redes de similitud.
- **Snakemake / Nextflow / Docker** — pipelines reproducibles.
- **Python** (`pandas`, `numpy`, `scikit-learn`) — análisis y ML sobre datos ómicos.

> Los scripts de Python usan `argparse` y son **reutilizables** desde la línea de
> comandos; los `.md` documentan pipelines de línea de comandos paso a paso.
