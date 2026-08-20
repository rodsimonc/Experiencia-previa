# Bioestadística en R

Esto es lo que sé hacer cuando me llega una tabla de datos y hay que sacarle
conclusiones con respaldo estadístico. El foco está en **estadística multivariada**,
pero incluye inferencia clásica y no paramétrica, regresión, GLM y modelos mixtos,
métodos bayesianos y machine learning.

Cada script está comentado como un *workflow*: qué mira, con qué librería, y por qué.

---

## Qué hago cuando recibo datos (checklist real)

1. **Inspección**: `dim`, `head`, `summary`, tipos de variable, faltantes, escalas.
2. **Exploración gráfica**: `boxplot`, `pairs`, dispersión, `ggplot2` — ver la forma antes de modelar.
3. **Supuestos**: normalidad (`shapiro.test`, Q-Q), homogeneidad (`bartlett.test`, `boxM`),
   colinealidad (VIF). Si no se cumplen, uso alternativas **no paramétricas** o transformo.
4. **Modelado** según la pregunta (comparar, predecir, reducir dimensiones, agrupar, clasificar).
5. **Incertidumbre**: intervalos de confianza, **bootstrap**, o intervalos de credibilidad **bayesianos**.
6. **Interpretación y figuras** publicables.

---

## Contenido

| Archivo | Tema | Qué demuestra |
|---|---|---|
| [`01_inferencia.R`](./01_inferencia.R) | Inferencia y comparación de grupos | t-test, tests binomial y de proporciones, supuestos |
| [`02_regresion_multiple.R`](./02_regresion_multiple.R) | Regresión múltiple + selección | `lm`, diagnósticos, `dredge`, PRESS/Cp/VIF, predicción |
| [`03_regresion_no_lineal.R`](./03_regresion_no_lineal.R) | Curvas de crecimiento | `optim` y `nls`; Weibull/Gompertz/Mono/Chapman; bootstrap |
| [`04_componentes_principales.R`](./04_componentes_principales.R) | PCA | `princomp`, `ade4`, biplots, bootstrap de loadings |
| [`05_analisis_discriminante.R`](./05_analisis_discriminante.R) | LDA + MANOVA | `MASS::lda`, Mahalanobis, `boxM`, clasificación |
| [`06_clustering.R`](./06_clustering.R) | Clustering y distancias | `hclust`, cofenética, soporte por bootstrap, genética |
| [`07_glm_y_modelos_mixtos.R`](./07_glm_y_modelos_mixtos.R) | GLM y modelos mixtos | `glm` (Poisson/binomial), `lme4` (efectos aleatorios) |
| [`08_metodos_no_parametricos.R`](./08_metodos_no_parametricos.R) | Estadística no paramétrica | Wilcoxon, Kruskal-Wallis, permutaciones, correlación de Spearman |
| [`09_analisis_bayesiano.R`](./09_analisis_bayesiano.R) | Inferencia bayesiana | `brms`/Stan, priors, posterior, intervalos de credibilidad |
| [`10_machine_learning.R`](./10_machine_learning.R) | Machine learning | `randomForest`/`caret`, validación cruzada, ROC, importancia de variables |
| [`11_visualizacion_ggplot2.R`](./11_visualizacion_ggplot2.R) | Visualización y mapas de calor | `ggplot2`, `tidyverse`, heatmaps de scores (`pheatmap`) |

---

## Librerías que uso y para qué

- **`MASS`** — discriminante lineal (`lda`), utilidades multivariadas.
- **`ade4` / `adegraphics`** — PCA ecológico, gráficos de clases, círculos de correlación.
- **`MuMIn` / `car`** — selección de modelos (`dredge`), diagnósticos, VIF.
- **`lme4` / `nlme`** — modelos lineales y generalizados **mixtos** (efectos aleatorios).
- **`boot`** — remuestreo bootstrap para la incertidumbre de casi cualquier estadístico.
- **`brms` / `rstan`** — modelos **bayesianos** con sintaxis de fórmula, sobre Stan.
- **`randomForest` / `caret`** — **machine learning**: entrenamiento, validación cruzada, métricas.
- **`biotools` / `adegenet` / `ape`** — box-M, genética de poblaciones, árboles.
- **`ggplot2` / `dplyr` / `tidyr`** — manipulación y visualización (tidyverse).
- **`pheatmap`** — mapas de calor con dendrogramas para matrices de scores.

> Los datos de estos ejemplos vienen de mis cursos (morfometría, flores/polinizadores,
> microsatélites, etc.) o son ilustrativos. Los scripts muestran el **método**; se
> adaptan a cualquier tabla con la misma estructura.
