# =============================================================================
# 11 - Visualización con ggplot2 y mapas de calor
# -----------------------------------------------------------------------------
# Una figura clara comunica más que una tabla. Acá muestro el flujo tidyverse
# (manipular + graficar) y mapas de calor para matrices de scores/puntuaciones.
# =============================================================================

library(tidyverse)   # dplyr + tidyr + ggplot2

datos <- read.table("datos.txt", header = TRUE)

# ---- Manipular y graficar en un solo flujo ----------------------------------
# Resumen por grupo y gráfico de barras con barras de error.
resumen <- datos %>%
  group_by(grupo) %>%
  summarise(media = mean(valor), ee = sd(valor) / sqrt(n()))

ggplot(resumen, aes(grupo, media, fill = grupo)) +
  geom_col(width = 0.6) +
  geom_errorbar(aes(ymin = media - ee, ymax = media + ee), width = 0.2) +
  labs(x = NULL, y = "Valor medio ± EE", title = "Comparación por grupo") +
  theme_minimal() + theme(legend.position = "none")

# ---- Dispersión con ajuste y facetas ----------------------------------------
ggplot(datos, aes(x, y, color = grupo)) +
  geom_point(alpha = 0.7) +
  geom_smooth(method = "lm", se = TRUE) +
  facet_wrap(~ grupo) +
  theme_bw()

# ---- Mapa de calor de una matriz de scores ----------------------------------
# Ej.: individuos (filas) x variables/scores (columnas). El heatmap con
# clustering agrupa filas y columnas parecidas y revela patrones.
library(pheatmap)
mat <- as.matrix(datos[, sapply(datos, is.numeric)])
rownames(mat) <- datos$id

pheatmap(mat,
         scale = "column",              # normaliza cada variable (comparables)
         clustering_distance_rows = "euclidean",
         clustering_method = "average", # UPGMA, como en el clustering del script 06
         main = "Mapa de calor de scores")

# =============================================================================
# Idea clave: el tidyverse permite ir de los datos crudos a una figura publicable
# en un flujo legible (%>%). Para matrices de puntuaciones, el mapa de calor con
# dendrogramas muestra de un vistazo qué individuos y qué variables se agrupan.
# =============================================================================
