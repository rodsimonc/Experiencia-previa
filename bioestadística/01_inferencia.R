# =============================================================================
# 01 - Inferencia y comparación de grupos
# -----------------------------------------------------------------------------
# Pregunta típica: ¿difieren dos grupos en una variable? ¿Está una proporción
# lejos de un valor esperado? Este es el primer paso antes de modelar.
# =============================================================================

# ---- Datos ------------------------------------------------------------------
# 'pesos' es una tabla con una variable continua (peso) y un factor (sexo).
dim(pesos)
head(pesos)

# ---- Exploración ------------------------------------------------------------
# Un boxplot muestra medianas, dispersión y outliers de un vistazo.
boxplot(peso ~ sexo, data = pesos, outline = FALSE, boxwex = 0.5)

# ---- Comparación de medias: test t ------------------------------------------
# Compara la media de 'peso' entre niveles de 'sexo'.
t.test(peso ~ sexo, data = pesos)

# Visualizar dónde cae el estadístico observado en la distribución t
tobs <- -12
curve(dt(x, df = 443), from = -13, to = 13)
abline(v = tobs, col = "red")

# ---- Proporciones -----------------------------------------------------------
# ¿La cantidad de machos vs hembras se aparta de una proporción teórica?
# binom.test (exacto) y prop.test (aproximación normal) para distintas H0.
table(pesos$sexo)
binom.test(x = c(32, 25), p = 1/2)     # ¿50/50?
binom.test(x = c(32, 25), p = 2/3)     # ¿2:1?
prop.test(x = 32, n = 32 + 25, p = 1/2)

# =============================================================================
# Idea clave: antes de un test hay que mirar el dato (boxplot) y tener claro
# qué H0 se está poniendo a prueba. El mismo recuento se puede contrastar
# contra distintas hipótesis según la biología del problema.
# =============================================================================
