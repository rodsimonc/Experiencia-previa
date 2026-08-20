# =============================================================================
# 06 - Clustering, distancias y soporte por bootstrap
# -----------------------------------------------------------------------------
# Pregunta típica: ¿cómo se agrupan mis unidades (especies, poblaciones,
# individuos) según su similitud? Y sobre todo: ¿cuáles agrupamientos son
# reales y cuáles podrían deberse al azar? Se cubren índices de similitud,
# clustering jerárquico, correlación cofenética y validación por remuestreo.
# =============================================================================

# ---- Distancia a partir de un índice de similitud ---------------------------
# Ejemplo ecológico: solapamiento de nicho de Pianka entre especies.
datos <- read.table("sanjoaquin.txt", header = TRUE)
pianka <- function(x, y) {
  px <- x / sum(x); py <- y / sum(y)
  100 * sum(px * py) / sqrt(sum(px^2) * sum(py^2))
}
# hclust necesita DISTANCIAS, así que uso el complemento (100 - similitud).
P <- dist(t(datos)); b <- 0
for (i in 1:(ncol(datos) - 1))
  for (j in (i + 1):ncol(datos)) { b <- b + 1; P[b] <- 100 - pianka(datos[, i], datos[, j]) }

# ---- Clustering jerárquico --------------------------------------------------
clus <- hclust(P, method = "average")   # UPGMA
plot(as.dendrogram(clus), horiz = TRUE, xlab = "100 - Pianka")

# ---- ¿El árbol representa bien las distancias? Correlación cofenética -------
cor(cophenetic(clus), P)                 # cerca de 1 = poca distorsión
plot(cophenetic(clus), P, pch = 19); abline(0, 1, col = 2, lwd = 2)

# ---- Soporte de los grupos por bootstrap ------------------------------------
# Barajo los datos (respetando ceros estructurales, p.ej. presas imposibles) y
# construyo una distribución nula de similitud. El percentil 95 marca el umbral
# por encima del cual un agrupamiento NO se explica por azar.
library(boot)
clus_boot <- function(x, i) {
  Ov <- NULL
  for (sp in 1:ncol(x)) {
    idx <- which(x[, sp] != 0)
    if (length(idx) > 1) x[idx, sp] <- x[sample(idx), sp]
  }
  for (a in 1:(ncol(x) - 1)) for (bb in (a + 1):ncol(x))
    Ov <- c(Ov, pianka(x[, a], x[, bb]))
  Ov
}
sal  <- boot(datos, clus_boot, stype = "i", R = 1000)
Psig <- quantile(sal$t, 0.95)

par(mfrow = c(1, 2))
hist(sal$t, n = 40, main = "", xlab = "100 - Pianka"); abline(v = Psig, col = 2, lwd = 2)
plot(as.dendrogram(clus), horiz = TRUE); abline(v = Psig, lty = 3, lwd = 2)

# ---- Distancias genéticas (genética de poblaciones) -------------------------
# Mismo espíritu con marcadores microsatélite: leer genotipos, calcular
# distancia genética entre poblaciones y construir un árbol Neighbor-Joining.
library(adegenet); library(ape)
gen  <- read.structure("micros.str", n.ind = 142, n.loc = 11,
                       onerowperind = TRUE, col.lab = 1, col.pop = 2,
                       row.marknames = 1, NA.char = "-9", ask = FALSE)
Dg   <- dist.genpop(as.genpop(gen@tab), method = 5)
arbol <- nj(Dg)
plot(arbol, type = "phylogram")

# =============================================================================
# Idea clave: agrupar es fácil; lo difícil (y lo importante) es saber qué
# agrupamientos creer. Por eso: (1) elijo bien la distancia según el dato,
# (2) chequeo distorsión con correlación cofenética y (3) valido los grupos
# con remuestreo antes de sacar conclusiones biológicas.
# =============================================================================
