# =============================================================================
# 03 - Regresión no lineal: curvas de crecimiento
# -----------------------------------------------------------------------------
# Pregunta típica: una variable crece con el tiempo hasta una asíntota; ¿qué
# modelo describe mejor esa curva y con qué incertidumbre en los parámetros?
# Se ajustan 4 modelos clásicos por minimización de la suma de cuadrados
# (optim) y luego con nls, y se estima la incertidumbre por bootstrap.
# =============================================================================

library(boot)

datos <- nonlindat   # columnas: tiempo, longitud

# ---- Modelos candidatos -----------------------------------------------------
# Cada uno es una forma funcional distinta de "crecimiento con asíntota".
Weibull   <- function(x, par) par[1] * (1 - exp(-(par[2] * x[, 1])^par[3]))
Gompertz  <- function(x, par) par[1] * exp(-par[2] * exp(-par[3] * x[, 1]))
Mono      <- function(x, par) par[1] * (1 - par[2] * exp(-par[3] * x[, 1]))
Chapman   <- function(x, par) par[1] * (1 - exp(-par[2] * x[, 1]))^par[3]

# ---- Ajuste por mínimos cuadrados con optim ---------------------------------
# Función objetivo: suma de cuadrados del error entre observado y esperado.
sse <- function(par, modelo) sum((datos[, 2] - modelo(datos, par))^2)

tau_ini <- c(44, 0.1, 1)   # valores iniciales razonables (a ojo del gráfico)
AjuW  <- optim(tau_ini, sse, modelo = Weibull,  method = "BFGS")
AjuG  <- optim(tau_ini, sse, modelo = Gompertz, method = "BFGS")
AjuM  <- optim(tau_ini, sse, modelo = Mono,     method = "BFGS")
AjuCh <- optim(tau_ini, sse, modelo = Chapman,  method = "BFGS")

# Comparar el error de cada modelo (menor = mejor ajuste)
c(Weibull = AjuW$value, Mono = AjuM$value, Gompertz = AjuG$value, Chapman = AjuCh$value)

# ---- Visualización ----------------------------------------------------------
plot(longitud ~ tiempo, data = datos, pch = 21, bg = "lightblue")
lines(datos$tiempo, Weibull(datos, AjuW$par),  col = "red",       lwd = 2)
lines(datos$tiempo, Gompertz(datos, AjuG$par), col = "darkgreen", lwd = 2)

# ---- Ajuste con nls (obtiene errores estándar de los parámetros) ------------
aju_wei <- nls(longitud ~ tau1 * (1 - exp(-(tau2 * tiempo)^tau3)),
               data = datos, algorithm = "port",
               start = list(tau1 = 44, tau2 = 0.05, tau3 = 1))
summary(aju_wei)
coef(aju_wei)       # estimadores
deviance(aju_wei)   # suma de cuadrados del error

# ---- Incertidumbre por bootstrap -------------------------------------------
# Re-ajusto el modelo en cada remuestreo para obtener la distribución de los
# parámetros y sus intervalos del 95%.
Wei_boot <- function(x, i) {
  d <- x[i, ]
  fit <- optim(AjuW$par,
               function(p) sum((d[, 2] - Weibull(d, p))^2),
               method = "BFGS")
  c(fit$value, fit$par)
}
boot_wei <- boot(datos, Wei_boot, R = 2000, stype = "i")

par(mfrow = c(2, 2))
for (k in 1:4) {
  hist(boot_wei$t[, k], n = 50,
       main = c("SSE", "tau1", "tau2", "tau3")[k], xlab = "")
  if (k > 1) abline(v = quantile(boot_wei$t[, k], c(0.025, 0.975)), lty = 3, lwd = 2)
}

# =============================================================================
# Idea clave: cuando la relación no es lineal, hay que (1) proponer formas
# funcionales con sentido biológico, (2) ajustarlas numéricamente, (3) elegir
# por error de ajuste y (4) reportar la incertidumbre de los parámetros, no
# solo su valor puntual.
# =============================================================================
