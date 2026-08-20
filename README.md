# Experiencia previa — Bioestadística y Bioinformática

Hola, soy **Carlos Rodríguez Simón**. Este repositorio es una muestra concreta de lo
que sé hacer con datos biológicos: desde que llegan crudos hasta que salen conclusiones
con soporte estadístico y figuras publicables.

No es código de juguete: son *workflows* reales, comentados paso a paso, que reflejan
mi formación en estadística multivariada y bioinformática, y dos años trabajando con
datos en R y Python (con Google Colab, línea de comandos y herramientas del área).

---

## 📊 [`bioestadística/`](./bioestad%C3%ADstica) — análisis de datos en R

Qué hago cuando me llega una tabla de datos: explorar, elegir modelo, verificar
supuestos, estimar con remuestreo y comunicar con figuras.

| Puedo… | Herramientas |
|---|---|
| Inferencia clásica y comparación de grupos | `t.test`, `binom.test`, `prop.test`, tests **no paramétricos** (`wilcox.test`, `kruskal.test`) |
| Regresión múltiple + selección de modelos | `lm`, `MuMIn::dredge`, PRESS, Mallow's Cp, VIF, `visreg` |
| **GLM y modelos mixtos** | `glm` (Poisson, binomial), `lme4`/`nlme` (efectos aleatorios, datos anidados) |
| Regresión **no lineal** (curvas de crecimiento) | `optim`, `nls`, Weibull / Gompertz / Monomolecular / Chapman |
| **PCA** y ordenación | `princomp`, `ade4::dudi.pca`, biplots, bootstrap de *loadings* |
| **Discriminante (LDA)** + MANOVA | `MASS::lda`, `manova`, Mahalanobis, `biotools::boxM` |
| **Clustering**, distancias y **mapas de calor** | `hclust`, `dist`, correlación cofenética, bootstrap, `heatmap`/`pheatmap` |
| **Análisis bayesiano** | inferencia bayesiana / MCMC (`brms` / Stan), intervalos de credibilidad |
| **Machine learning** | `caret`/`randomForest`, validación cruzada, curvas ROC |
| **Visualización** | `ggplot2` + `tidyverse` (dplyr, tidyr) |

## 🧬 [`bioinformática/`](./bioinform%C3%A1tica) — secuencias y genómica

Qué hago cuando me llega un set de secuencias, IDs o datos de secuenciación:
descargar, limpiar, analizar, alinear, inferir filogenias y analizar datos ómicos.

| Puedo… | Herramientas |
|---|---|
| Descargar secuencias masivamente desde **NCBI** | EDirect (`efetch`), **Biopython** (`Bio.Entrez`, `SeqIO`) |
| Manejar y reformatear FASTA/multiFASTA | Python, Biopython, `argparse` |
| Analizar secuencias (ORFs, traducción, motivos, estructura 2ª) | Suite **EMBOSS** |
| Alinear y construir árboles filogenéticos | Clustal / MAFFT / MUSCLE, **PhyML**, Mesquite, Dendroscope |
| **RNA-seq / expresión diferencial** | conteo de *reads*, `DESeq2` / `edgeR`, volcano plots |
| **Microbioma / metabarcoding** | `mothur` / QIIME, curvas de rarefacción, diversidad α/β |
| **Estructura de proteínas / modelado** | modelado por homología, PDB, análisis estructural, docking |
| Homología y redes | BLAST, logos de secuencia (Shannon/Kullback), Cytoscape |

## 🛠️ Herramientas y entorno

**R** · **Python** (pandas, numpy, scikit-learn, Biopython) · **SQL** y bases de datos ·
**Linux / bash** (scripting, pipes, procesamiento por línea de comandos) ·
**pipelines reproducibles** (Snakemake / Nextflow, Docker) · Git · Google Colab.

---

## Cómo trabajo (mi flujo general)

1. **Entender el dato** antes de tocarlo: qué mide cada variable, escalas, faltantes, sesgos de muestreo.
2. **Explorar** con gráficos y resúmenes antes de modelar.
3. **Elegir el método** según la pregunta y la estructura del dato, no al revés.
4. **Verificar supuestos** (normalidad, homogeneidad de varianzas, colinealidad, etc.).
5. **Estimar la incertidumbre**, muchas veces con **remuestreo (bootstrap)** o intervalos bayesianos.
6. **Comunicar** con figuras claras y una interpretación honesta de lo que el dato permite (y lo que no).

Cada carpeta tiene su propio `README` con el detalle y los ejemplos comentados.
