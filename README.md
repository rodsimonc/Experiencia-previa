# Experiencia previa — Bioestadística y Bioinformática

Hola, soy **Carlos Rodríguez Simón**. Este repositorio es una muestra concreta de lo
que sé hacer con datos biológicos: desde que llegan crudos hasta que salen conclusiones
con soporte estadístico y figuras publicables.

No es código de juguete: son *workflows* reales, comentados paso a paso, que reflejan
trabajo hecho durante mi formación en estadística multivariada y bioinformática, y dos
años trabajando con datos en R y Python.

---

## Qué encontrás acá

### 📊 [`bioestadística/`](./bioestad%C3%ADstica)
Análisis estadístico de datos (sobre todo **multivariado**) en **R**. Qué hago cuando
me llega una tabla de datos: explorar, elegir modelo, verificar supuestos, estimar con
remuestreo y comunicar el resultado con figuras.

| Puedo… | Herramientas |
|---|---|
| Inferencia clásica y comparación de grupos | `t.test`, `binom.test`, `prop.test`, `shapiro.test`, `bartlett.test` |
| Regresión múltiple + selección de modelos | `lm`, `MuMIn::dredge`, PRESS, Mallow's Cp, VIF, `visreg` |
| Regresión **no lineal** (curvas de crecimiento) | `optim`, `nls`, modelos Weibull / Gompertz / Monomolecular / Chapman |
| **Componentes principales (PCA)** | `princomp`, `ade4::dudi.pca`, biplots, bootstrap de *loadings* |
| **Análisis discriminante (LDA)** + MANOVA | `MASS::lda`, `manova`, distancia de Mahalanobis, `biotools::boxM` |
| **Clustering** y distancias | `hclust`, `dist`, correlación cofenética, soporte por bootstrap, distancias genéticas (`adegenet`) |

### 🧬 [`bioinformática/`](./bioinform%C3%A1tica)
Trabajo con **secuencias biológicas** (ADN/proteínas) en **Python** y herramientas de
línea de comandos. Qué hago cuando me llega un set de secuencias o una lista de IDs:
descargarlas, limpiarlas, analizarlas, alinearlas e inferir filogenias.

| Puedo… | Herramientas |
|---|---|
| Descargar secuencias masivamente desde **NCBI** | NCBI **EDirect** (`efetch`) automatizado con Python |
| Manejar y reformatear FASTA/multiFASTA | Python (parsing propio), `argparse` para scripts reutilizables |
| Analizar secuencias (ORFs, traducción, motivos, estructura 2ª) | Suite **EMBOSS** (`transeq`, `tcode`, `garnier`, `pepwheel`, `patmatmotifs`, …) |
| Alinear y construir árboles filogenéticos | Clustal / MAFFT / MUSCLE, **PhyML**, Mesquite, Dendroscope |
| Búsquedas de homología y análisis de redes | BLAST, logos de secuencia (Shannon/Kullback), Cytoscape |

---

## Cómo trabajo (mi flujo general)

1. **Entender el dato** antes de tocarlo: qué mide cada variable, escalas, faltantes, sesgos de muestreo.
2. **Explorar** con gráficos y resúmenes antes de modelar.
3. **Elegir el método** según la pregunta y la estructura del dato, no al revés.
4. **Verificar supuestos** (normalidad, homogeneidad de varianzas, colinealidad, etc.).
5. **Estimar la incertidumbre**, muchas veces con **remuestreo (bootstrap)** cuando no hay fórmula cerrada.
6. **Comunicar** con figuras claras y una interpretación honesta de lo que el dato permite (y lo que no).

---

## Stack técnico

**R** (estadística/multivariado) · **Python** (bioinformática, automatización) ·
línea de comandos Linux · Git · Google Colab.

Cada carpeta tiene su propio `README` con más detalle y los ejemplos comentados.
