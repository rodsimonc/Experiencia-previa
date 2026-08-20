# Workflow: alineamiento múltiple e inferencia filogenética

Cómo paso de un conjunto de secuencias homólogas a un árbol filogenético con
soporte estadístico. Corresponde al trabajo de mi TP final de bioinformática,
donde partí de una búsqueda por homología y llegué a un árbol interpretado.

## Pipeline completo

```
IDs / secuencias
      │  (efetch — ver 01_descargar_secuencias_ncbi.py)
      ▼
BLAST contra base de referencia (p. ej. Swiss-Prot)
      │  seleccionar hits homólogos, filtrar por cobertura/identidad
      ▼
Alineamiento múltiple  (Clustal Omega / MAFFT / MUSCLE)
      │  curar columnas: quitar regiones mal alineadas / muy gappeadas
      ▼
Selección de modelo evolutivo + PhyML (máxima verosimilitud)
      │  soporte de ramas (aLRT / bootstrap)
      ▼
Visualización e interpretación  (Dendroscope / Mesquite)
```

## 1. Búsqueda de homología

```bash
# Buscar secuencias homólogas y quedarse con una tabla de hits
blastp -query proteina.fasta -db swissprot -outfmt 6 -out hits.tsv
```
A partir de la tabla de hits se filtran las secuencias por cobertura e identidad
para armar el set de trabajo.

## 2. Alineamiento múltiple

```bash
clustalo -i secuencias.fasta -o alineamiento.fasta --outfmt=fasta
# o: mafft --auto secuencias.fasta > alineamiento.fasta
```
Después se **cura** el alineamiento: se recortan las columnas con demasiados gaps
o mal alineadas, porque ensucian la señal filogenética. En mi TP trabajé con un
set de ~61 secuencias podado por cobertura (>70 %).

## 3. Inferencia del árbol con PhyML

```bash
# PhyML sobre el alineamiento en formato PHYLIP (máxima verosimilitud)
phyml -i alineamiento.phy -d aa -m LG -b -4    # -b -4 = soporte aLRT
```
Se elige el modelo de sustitución adecuado (p. ej. LG para proteínas) y se pide
soporte de ramas para saber en qué nodos confiar.

## 4. Visualización e interpretación

El árbol resultante (`.nwk` / Newick) se visualiza en **Dendroscope** o
**Mesquite**, se enraíza, se colorean clados y se interpretan las relaciones
evolutivas. Complementé el análisis con **logos de secuencia** (información de
Shannon / Kullback-Leibler por posición) para ver residuos conservados, y con
**Cytoscape** para representar redes de similitud entre secuencias.

## Herramientas usadas

BLAST · Clustal Omega / MAFFT / MUSCLE · PhyML · Dendroscope · Mesquite ·
logos de secuencia (Shannon/Kullback) · Cytoscape.
