# =============================================================================
# 08 - Estadística no paramétrica
# -----------------------------------------------------------------------------
# Pregunta típica: los supuestos de normalidad no se cumplen, la muestra es
# chica, o los datos son ordinales/con outliers. En vez de forzar un test
# paramétrico, uso alternativas basadas en rangos o en remuestreo.
# =============================================================================

datos <- read.table("datos.txt", header = TRUE)

# ---- Comparación de dos grupos: Wilcoxon / Mann-Whitney ---------------------
# Alternativa no paramétrica al test t (compara medianas / distribuciones).
wilcox.test(valor ~ grupo, data = datos)

# Para datos apareados (antes/después del mismo individuo)
# wilcox.test(antes, despues, paired = TRUE)

# ---- Más de dos grupos: Kruskal-Wallis + post-hoc ---------------------------
# Alternativa no paramétrica al ANOVA de una vía.
kruskal.test(valor ~ tratamiento, data = datos)
# Comparaciones múltiples por pares (con corrección del p-valor)
pairwise.wilcox.test(datos$valor, datos$tratamiento, p.adjust.method = "holm")

# ---- Asociación monótona: correlación de Spearman ---------------------------
# No asume linealidad ni normalidad; mide asociación por rangos.
cor.test(datos$x, datos$y, method = "spearman")

# ---- Test de permutaciones (hecho a mano) -----------------------------------
# Idea general de la inferencia no paramétrica: si no hay efecto, permutar las
# etiquetas de grupo no debería cambiar el estadístico. Construyo la
# distribución nula permutando y comparo el valor observado.
obs <- diff(tapply(datos$valor, datos$grupo, mean))   # diferencia de medias observada
perm <- replicate(10000, {
  g <- sample(datos$grupo)                            # baraja las etiquetas
  diff(tapply(datos$valor, g, mean))
})
p_valor <- mean(abs(perm) >= abs(obs))                # proporción tan extrema como lo observado
p_valor

hist(perm, breaks = 40, main = "Distribución nula (permutaciones)", xlab = "diferencia")
abline(v = obs, col = 2, lwd = 2)

# =============================================================================
# Idea clave: cuando los supuestos no se cumplen, no fuerzo el método —cambio de
# herramienta. Los tests de rangos y, sobre todo, las permutaciones me dan
# inferencia válida con mínimos supuestos, y el enfoque de permutación se adapta
# a casi cualquier estadístico que me interese.
# =============================================================================
