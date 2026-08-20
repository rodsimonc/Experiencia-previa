# =============================================================================
# 05 - Análisis Discriminante Lineal (LDA) + MANOVA
# -----------------------------------------------------------------------------
# Pregunta típica: tengo grupos conocidos (sexo, especie, ...) y varias
# variables; ¿qué combinación las separa mejor y puedo clasificar individuos
# nuevos? Se construyen las matrices W/B "a mano", se usa lda, se testea con
# MANOVA y se verifican los supuestos del método.
# =============================================================================

library(MASS)

datos <- read.table("tucos.txt", header = TRUE)   # col 1 = SEXO, resto morfometría

# ---- Matrices de dispersión (la mecánica del discriminante) -----------------
# W = variación DENTRO de los grupos ; B = variación ENTRE grupos.
Xc  <- scale(datos[, -1], center = TRUE, scale = FALSE)
Tot <- crossprod(Xc)                                   # dispersión total
Wm  <- crossprod(scale(datos[datos$SEXO == "M", -1], scale = FALSE))
Wh  <- crossprod(scale(datos[datos$SEXO == "H", -1], scale = FALSE))
W   <- Wm + Wh
B   <- Tot - W
# El eje discriminante maximiza B respecto de W: autovectores de W^-1 B.
ev  <- svd(ginv(W) %*% B, nu = 1)

# ---- LDA automático ---------------------------------------------------------
discri <- lda(SEXO ~ ., data = datos)
pred   <- predict(discri)

# Contribución de cada variable al eje discriminante
cor(datos[, -1], pred$x)

# Calidad de clasificación (matriz de confusión)
table(observado = datos$SEXO, predicho = pred$class)

# ---- Contraste global: MANOVA ----------------------------------------------
man <- manova(cbind(LDIAS, LSD, LBAS, AR, ALCRA) ~ SEXO, data = datos)
anova(man)

# ---- Clasificar individuos nuevos ------------------------------------------
nuevos <- read.table("predados.txt", header = TRUE)
predict(discri, nuevos)$class

# ---- Verificación de supuestos ---------------------------------------------
# 1) Igualdad de matrices de varianza-covarianza entre grupos (box-M)
library(biotools)
boxM(datos[, -1], datos[, 1])

# 2) Normalidad por variable DENTRO de cada grupo
by(datos$LSD, datos$SEXO, shapiro.test)

# 3) Distancia de Mahalanobis entre centroides de grupos
xh <- discri$means
mahalanobis(xh[1, ], xh[2, ], cov(datos[, -1]))

# =============================================================================
# Aplicación real: también lo usé en morfometría geométrica (relative warps,
# variables RW1..RW30) para separar especies de flores y tipos de polinizador,
# construyendo la fórmula de MANOVA de forma programática. El discriminante es
# válido si se cumplen los supuestos (box-M + normalidad); si no, hay que
# transformar las variables antes de interpretar.
# =============================================================================
