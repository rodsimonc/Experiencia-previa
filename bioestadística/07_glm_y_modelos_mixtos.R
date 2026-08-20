# =============================================================================
# 07 - Modelos lineales generalizados (GLM) y modelos mixtos
# -----------------------------------------------------------------------------
# Pregunta típica: la respuesta NO es continua-normal (es un conteo, una
# proporción, un sí/no), o las observaciones NO son independientes (medidas
# repetidas, individuos anidados en sitios). La regresión lineal común no sirve;
# se usan GLM y modelos mixtos.
# =============================================================================

# ---- GLM: respuesta de conteo (Poisson) -------------------------------------
# Ej.: número de especies (conteo) en función de variables ambientales.
datos <- read.table("conteos.txt", header = TRUE)
m_pois <- glm(n_especies ~ temperatura + altitud, family = poisson, data = datos)
summary(m_pois)

# Chequeo de sobredispersión (varianza >> media): si el cociente es >> 1,
# conviene quasipoisson o binomial negativa.
disp <- sum(residuals(m_pois, type = "pearson")^2) / m_pois$df.residual
disp
if (disp > 1.5) {
  library(MASS)
  m_nb <- glm.nb(n_especies ~ temperatura + altitud, data = datos)  # binomial negativa
  summary(m_nb)
}

# ---- GLM: respuesta binaria (logística) -------------------------------------
# Ej.: presencia/ausencia (0/1) en función de un predictor.
m_logit <- glm(presencia ~ cobertura, family = binomial, data = datos)
# Interpretación en odds-ratio (exponenciar los coeficientes)
exp(coef(m_logit))

# ---- Modelo mixto: efecto aleatorio -----------------------------------------
# Ej.: mediciones repetidas dentro de cada sitio -> el sitio es efecto aleatorio.
library(lme4)
m_mix <- lmer(respuesta ~ tratamiento + (1 | sitio), data = datos)
summary(m_mix)

# GLM mixto (conteo con efecto aleatorio de sitio)
m_glmm <- glmer(n_especies ~ tratamiento + (1 | sitio),
                family = poisson, data = datos)
summary(m_glmm)

# Comparación de modelos por AIC (menor = mejor equilibrio ajuste/complejidad)
AIC(m_pois, m_logit)

# =============================================================================
# Idea clave: elegir la FAMILIA según la naturaleza de la respuesta (conteo ->
# Poisson/negbin; binaria -> binomial) y agregar EFECTOS ALEATORIOS cuando hay
# estructura de agrupamiento que viola la independencia. Siempre reviso
# sobredispersión antes de confiar en un modelo de conteo.
# =============================================================================
