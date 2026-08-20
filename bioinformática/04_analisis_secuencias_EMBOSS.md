# Workflow: análisis de secuencias con EMBOSS

Cómo paso de una secuencia cruda de ADN a información biológica útil (regiones
codificantes, proteína, motivos y estructura secundaria) usando la suite EMBOSS
desde la línea de comandos. Este flujo corresponde al trabajo hecho en mis TPs
de bioinformática.

> EMBOSS es una colección de programas de línea de comandos; cada paso toma un
> archivo de secuencia y produce un resultado (texto o figura). Se encadenan
> fácilmente en un script.

## 1. De ADN a regiones codificantes y ORFs

```bash
# ¿Qué regiones son probablemente codificantes? (estadístico de Fickett)
tcode -sequence gen.fasta -window 200 -graph png -outfile tcode.out

# Encontrar y mostrar los marcos abiertos de lectura (ORFs)
plotorf -sequence gen.fasta -graph png
showorf -sequence gen.fasta -outfile orfs.txt
```

## 2. Traducción a proteína

```bash
# Traducir en el marco correcto (frame) a secuencia de aminoácidos
transeq -sequence cds.fasta -frame 1 -outseq proteina.fasta
```

## 3. Análisis de la proteína

```bash
# Estructura secundaria (predicción de Garnier: hélice / lámina / giro)
garnier -sequence proteina.fasta -outfile garnier.txt

# Regiones coiled-coil y hélices anfipáticas
pepcoil  -sequence proteina.fasta -outfile pepcoil.txt
pepwheel -sequence proteina.fasta -graph png        # rueda helicoidal
helixturnhelix -sequence proteina.fasta -outfile hth.txt   # motivos HTH de unión a ADN

# Búsqueda de motivos funcionales conocidos (base PROSITE)
patmatmotifs -sequence proteina.fasta -outfile motivos.txt
```

## Interpretación

El objetivo no es correr comandos sino **encadenar la evidencia**: `tcode`/`plotorf`
localizan la región codificante, `transeq` da la proteína, y los análisis de
proteína (`garnier`, `pepcoil`, `patmatmotifs`) sugieren función y estructura.
Cada salida se contrasta con lo esperado biológicamente antes de concluir.

## Herramientas usadas

`tcode` · `plotorf` · `showorf` · `transeq` · `garnier` · `pepcoil` · `pepwheel` ·
`helixturnhelix` · `patmatmotifs` (todas de EMBOSS), más `dotmatcher` y `est2genome`
para comparación de secuencias y mapeo de ESTs a genoma.
