# =============================================================================
# 09 - Inferencia bayesiana
# -----------------------------------------------------------------------------
# Pregunta típica: quiero cuantificar la incertidumbre como una DISTRIBUCIÓN de
# valores plausibles del parámetro (no solo un p-valor), incorporar conocimiento
# previo, o ajustar modelos jerárquicos complejos. Uso brms (sintaxis de fórmula
# de R por encima de Stan / MCMC).
# =============================================================================

library(brms)

datos <- read.table("datos.txt", header = TRUE)

# ---- Regresión bayesiana con priors explícitos ------------------------------
# Mismo modelo que un lm, pero declarando distribuciones previas y obteniendo
# una distribución POSTERIOR para cada parámetro.
priors <- c(
  prior(normal(0, 10), class = "b"),        # priors poco informativos para las pendientes
  prior(normal(0, 20), class = "Intercept")
)

modelo <- brm(
  respuesta ~ x1 + x2,
  data = datos, family = gaussian(),
  prior = priors,
  chains = 4, iter = 2000, cores = 4, seed = 123
)

# ---- Diagnóstico de convergencia --------------------------------------------
# Rhat ~ 1.00 y buen tamaño efectivo de muestra indican cadenas sanas.
summary(modelo)
plot(modelo)                 # trazas + posteriors
# pp_check(modelo)           # chequeo predictivo posterior (ajuste del modelo)

# ---- Interpretación: intervalos de credibilidad -----------------------------
# A diferencia del IC frecuentista, acá SÍ puedo decir "hay 95% de probabilidad
# de que el parámetro esté en este intervalo", dado el modelo y los datos.
posterior_interval(modelo, prob = 0.95)

# Probabilidad directa de una hipótesis (p. ej. que el efecto de x1 sea > 0)
hypothesis(modelo, "x1 > 0")

# ---- Modelo jerárquico (bayesiano mixto) ------------------------------------
# Efecto aleatorio de sitio, en versión bayesiana.
modelo_jer <- brm(respuesta ~ tratamiento + (1 | sitio),
                  data = datos, chains = 4, iter = 2000, cores = 4)

# =============================================================================
# Idea clave: el enfoque bayesiano cambia la pregunta de "¿rechazo H0?" a
# "¿qué valores del parámetro son plausibles y con qué probabilidad?". Es
# especialmente útil con muestras chicas, conocimiento previo, o estructuras
# jerárquicas. Siempre verifico convergencia (Rhat) antes de interpretar.
# =============================================================================
