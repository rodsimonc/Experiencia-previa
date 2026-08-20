# Bioestadística en R

Esto es lo que sé hacer cuando me llega una tabla de datos y hay que sacarle
conclusiones con respaldo estadístico. El foco está en **estadística multivariada**,
que es donde tengo más recorrido, pero incluye también inferencia clásica, regresión
y modelos no lineales.

Cada script está comentado como un *workflow*: qué mira, con qué librería, y por qué.

---

## Qué hago cuando recibo datos (checklist real)

1. **Inspección**: `dim`, `head`, `summary`, tipos de variable, faltantes, escalas.
2. **Exploración gráfica**: `boxplot`, `pairs`, dispersión — ver la forma antes de modelar.
3. **Supuestos**: normalidad (`shapiro.test`, Q-Q plots), homogeneidad de varianzas
   (`bartlett.test`, `boxM`), colinealidad (VIF).
4. **Modelado** según la pregunta (comparar grupos, predecir, reducir dimensiones, agrupar).
5. **Incertidumbre**: intervalos de confianza; **bootstrap** cuando no hay fórmula cerrada.
6. **Interpretación y figuras** publicables.

---

## Contenido

| Archivo | Tema | Qué demuestra |
|---|---|---|
| [`01_inferencia.R`](./01_inferencia.R) | Inferencia y comparación de grupos | t-test, tests binomial y de proporciones, chequeo de supuestos |
| [`02_regresion_multiple.R`](./02_regresion_multiple.R) | Regresión múltiple + selección de modelos | `lm`, diagnósticos, `dredge` (MuMIn), PRESS/Cp/VIF, stepwise, predicción con IC |
| [`03_regresion_no_lineal.R`](./03_regresion_no_lineal.R) | Curvas de crecimiento | ajuste por `optim` y `nls`; Weibull, Gompertz, Monomolecular, Chapman; bootstrap de parámetros |
| [`04_componentes_principales.R`](./04_componentes_principales.R) | PCA | `princomp`, `ade4::dudi.pca`, biplots, **bootstrap de loadings** con corrección de signo |
| [`05_analisis_discriminante.R`](./05_analisis_discriminante.R) | LDA + MANOVA | `MASS::lda`, matrices W/B, Mahalanobis, `boxM`, tabla de clasificación, morfometría geométrica |
| [`06_clustering.R`](./06_clustering.R) | Clustering y distancias | `dist`, `hclust`, correlación cofenética, **soporte por bootstrap**, distancias genéticas (`adegenet`) |

---

## Librerías que uso y para qué

- **`MASS`** — análisis discriminante lineal (`lda`), utilidades multivariadas (`ginv`).
- **`ade4` / `adegraphics`** — análisis multivariado ecológico: PCA (`dudi.pca`), gráficos
  de clases, círculos de correlación, envolventes convexas.
- **`MuMIn`** — selección automática de modelos (`dredge`) con criterios múltiples.
- **`car`** — diagnósticos de regresión, factor de inflación de la varianza (`vif`).
- **`boot`** — remuestreo bootstrap para estimar incertidumbre de casi cualquier estadístico.
- **`biotools`** — test de box-M (homogeneidad de matrices de varianza-covarianza).
- **`adegenet` / `ape`** — genética de poblaciones: distancias genéticas, árboles NJ.
- **`visreg`** — visualización de efectos parciales de un modelo.
- **`jpeg`** — usado como ejemplo didáctico: comprimir una imagen con PCA.

> Nota: los datos de estos ejemplos vienen de mis cursos (morfometría de roedores,
> flores/polinizadores, microsatélites, etc.). Los scripts muestran el **método**;
> se adaptan a cualquier tabla de datos con la misma estructura.
