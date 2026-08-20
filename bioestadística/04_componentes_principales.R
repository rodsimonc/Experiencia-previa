# =============================================================================
# 04 - Análisis de Componentes Principales (PCA)
# -----------------------------------------------------------------------------
# Pregunta típica: tengo muchas variables correlacionadas; ¿puedo resumirlas en
# pocos ejes que capturen la variación y ver cómo se agrupan los individuos?
# Se hace PCA "a mano" (para entender qué calcula), con princomp y con ade4,
# y se evalúa la significancia de los loadings por bootstrap.
# =============================================================================

# ---- PCA desde los autovalores (para entender la mecánica) ------------------
datos <- read.table("tucos.txt", header = TRUE)   # morfometría, col 1 = SEXO
S <- cov(datos[, -1])          # matriz de covarianza
E <- eigen(S)                  # autovalores y autovectores
100 * sum(E$values[1:2]) / sum(E$values)   # % de varianza en los 2 primeros CP

X   <- scale(datos[, -1], center = TRUE, scale = FALSE)  # centrar
CPs <- X %*% E$vectors                                    # coordenadas (scores)
cor(datos[, -1], CPs[, 1:2])   # correlación variable-componente (interpretación)

# ---- PCA con princomp + biplot ---------------------------------------------
# cor = TRUE -> usa matriz de correlación (recomendado si las escalas difieren)
pcs <- princomp(datos[, -1], cor = TRUE)
summary(pcs)                   # proporción de varianza por componente
biplot(pcs); abline(h = 0, v = 0, lty = 3)

# Regla práctica para elegir cuántos componentes: autovalor > 1 (línea)
plot(pcs); abline(h = 1)

# ---- Significancia de los loadings por bootstrap ----------------------------
# Problema: el signo de cada componente es arbitrario y varía entre remuestreos.
# Solución: fijar el signo usando la variable de mayor peso como referencia.
library(boot)
bootComp <- function(x, i, comp = 1) {
  ref  <- princomp(datos, cor = TRUE)$loadings[, comp]
  piv  <- which.max(abs(ref))                          # variable "ancla"
  cf   <- princomp(x[i, ], cor = TRUE)$loadings[, comp]
  if (sign(ref[piv]) != sign(cf[piv])) cf <- -cf       # corrige el signo
  cf
}
salBoot <- boot(datos[, -1], bootComp, stype = "i", R = 10000)

# Un loading es "significativo" si su intervalo del 95% NO incluye el 0.
par(mfrow = c(2, 3))
for (k in seq_len(ncol(datos) - 1)) {
  hist(salBoot$t[, k], breaks = seq(-1, 1, length = 100),
       main = colnames(datos)[-1][k])
  abline(v = quantile(salBoot$t[, k], c(0.025, 0.975)), col = 2)
}

# ---- PCA con ade4 (gráficos de clases y círculo de correlación) -------------
library(ade4)
iris <- read.table("iris.txt", header = TRUE)
PCs <- dudi.pca(iris[, 2:5], center = TRUE, scale = TRUE, scannf = FALSE, nf = 4)
s.class(PCs$li[, 1:2], fac = iris$Especie, cellipse = 2,
        col = c("red", "blue", "black"))
s.corcircle(PCs$co)

# =============================================================================
# Idea clave: PCA no es solo "apretar un botón". Hay que decidir covarianza vs
# correlación según las escalas, elegir cuántos componentes retener, y — lo más
# importante — evaluar qué variables contribuyen de verdad (bootstrap de
# loadings con corrección de signo). Si las variables no están correlacionadas,
# el PCA no aporta y conviene saberlo antes de sobreinterpretar.
# =============================================================================
