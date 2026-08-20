# =============================================================================
# 02 - Regresión múltiple + selección de modelos
# -----------------------------------------------------------------------------
# Pregunta típica: ¿qué variables explican la respuesta y con qué modelo
# predigo mejor? Incluye diagnóstico de supuestos, selección de modelos por
# criterios múltiples y predicción con intervalos.
# =============================================================================

library(MuMIn)   # selección automática de modelos (dredge)
library(car)     # VIF (colinealidad)
library(visreg)  # efectos parciales

# ---- Ajuste inicial ---------------------------------------------------------
datos <- read.table("datos.txt", header = TRUE)
reg <- lm(Y ~ X1 + X2 + X3 + X4, data = datos)

# ---- Diagnóstico de supuestos ----------------------------------------------
# 1) Homocedasticidad: residuos vs ajustados (no debe haber patrón/embudo)
par(mfrow = c(1, 2))
plot(fitted(reg), residuals(reg)); abline(h = 0, lty = 2)
g <- cut(fitted(reg), breaks = 3)
bartlett.test(residuals(reg), g = g)       # test formal de varianzas iguales

# 2) Normalidad de los residuos
qqnorm(residuals(reg), datax = TRUE); qqline(residuals(reg), datax = TRUE, col = 2)
shapiro.test(residuals(reg))

# ---- Selección de modelos ---------------------------------------------------
# Defino criterios de comparación y dejo que dredge evalúe todos los submodelos.
r2   <- function(x) summary(x)$r.squared
MSE  <- function(x) summary(x)$sigma^2
p    <- function(x) x$rank
h    <- function(x) influence.measures(x)$infmat[, x$rank + 4]
PRESS <- function(x) sum((residuals(x) / (1 - h(x)))^2)   # error de predicción
VF   <- function(x) mean(vif(x))                           # colinealidad media

options(na.action = "na.fail")   # dredge lo requiere
modelos <- dredge(reg,
                  extra = c("r2", "MSE", "PRESS", "VF"),
                  m.lim = c(2, 10),
                  rank  = "PRESS")   # ranquear por capacidad predictiva
head(modelos)

# Criterio práctico: descartar modelos con colinealidad alta (VIF medio > 5)
# y quedarse con el de menor PRESS.
plot(VF ~ p, data = modelos, pch = 19, cex = 0.4); abline(h = 5, col = 2)

# ---- Modelo elegido ---------------------------------------------------------
elegido <- get.models(modelos, subset = 1)[[1]]
summary(elegido)

# Efectos parciales de cada predictor (útil para comunicar)
visreg(elegido)

# ---- Predicción con intervalo de confianza ---------------------------------
nuevo <- data.frame(X1 = 170, X3 = 0.15)
predict(elegido, newdata = nuevo, interval = "confidence", se.fit = TRUE)

# =============================================================================
# Idea clave: "el mejor modelo" depende del criterio. Acá priorizo PREDICCIÓN
# (PRESS) y controlo colinealidad (VIF), no solo el R2, que siempre mejora al
# agregar variables. Los supuestos se verifican SOBRE el modelo elegido.
# =============================================================================
