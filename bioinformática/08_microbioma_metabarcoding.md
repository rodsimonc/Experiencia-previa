# Workflow: microbioma / metabarcoding

Cómo paso de lecturas de amplicón (p. ej. 16S rRNA) a una descripción de la
**comunidad microbiana**: quién está, en qué abundancia, y cómo difieren las
comunidades entre muestras. Trabajé con `mothur` en mis TPs de bioinformática.

## Pipeline

```
FASTQ de amplicón (16S / ITS)
      │  unir pares, filtrar por calidad y largo
      ▼
Reducción de ruido  →  OTUs (mothur) o ASVs (DADA2)
      │
      ▼
Asignación taxonómica (SILVA / Greengenes)
      │  tabla de abundancias (taxones x muestras)
      ▼
Diversidad α (dentro de cada muestra) y β (entre muestras) + ordenación
```

## 1. Procesamiento con mothur (esquema)

```
make.contigs(file=muestras.files)          # unir lecturas paired-end
screen.seqs(...)                            # filtrar por largo y calidad
unique.seqs(); count.seqs(...)              # colapsar secuencias idénticas
align.seqs(reference=silva.align)           # alinear contra referencia
classify.seqs(reference=..., taxonomy=...)  # asignar taxonomía
cluster.split(...); make.shared(...)        # agrupar en OTUs y tabla de abundancia
```

## 2. Diversidad

- **Diversidad α** (riqueza y equitatividad dentro de cada muestra): índices de
  Shannon, Simpson, Chao1; **curvas de rarefacción** para controlar el efecto del
  esfuerzo de muestreo (recordá: normalizar por profundidad antes de comparar).
- **Diversidad β** (diferencias entre muestras): matrices de distancia
  (Bray-Curtis, UniFrac) y ordenación por **PCoA / NMDS**; contraste estadístico
  con **PERMANOVA** (`adonis`).

## 3. Análisis en R (phyloseq)

```r
library(phyloseq); library(vegan)
# 'ps' = objeto phyloseq (tabla OTU + taxonomía + metadatos)
plot_richness(ps, x = "grupo", measures = c("Shannon", "Simpson"))

# Ordenación de la diversidad beta (Bray-Curtis + NMDS)
ord <- ordinate(ps, method = "NMDS", distance = "bray")
plot_ordination(ps, ord, color = "grupo")

# ¿Difieren las comunidades entre grupos? (PERMANOVA)
d <- phyloseq::distance(ps, "bray")
adonis2(d ~ grupo, data = as(sample_data(ps), "data.frame"))
```

## Conexión con mi otro trabajo

El análisis de comunidades usa las mismas ideas que mis scripts de
[bioestadística](../bioestad%C3%ADstica): matrices de distancia, ordenación
(como el PCA/PCoA) y contrastes con remuestreo (PERMANOVA es, en el fondo, un
test de permutaciones sobre distancias).

## Herramientas usadas

mothur · DADA2 · QIIME2 · SILVA/Greengenes · phyloseq · vegan (`adonis`, NMDS).
