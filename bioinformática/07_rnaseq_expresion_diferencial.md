# Workflow: RNA-seq y expresión diferencial

Cómo paso de lecturas crudas de secuenciación (RNA-seq) a una lista de genes
**diferencialmente expresados** entre condiciones (p. ej. tratamiento vs control).

## Pipeline

```
FASTQ (reads crudos)
      │  control de calidad
      ▼
FastQC / MultiQC  →  Trimmomatic / fastp   (recorte de adaptadores y bases malas)
      │
      ▼
Mapeo / cuantificación
   HISAT2 / STAR (mapeo al genoma)  +  featureCounts
   o  Salmon / kallisto (cuantificación sin mapeo)
      │  matriz de conteos (genes x muestras)
      ▼
Expresión diferencial en R  →  DESeq2 / edgeR
      │
      ▼
Genes DE + figuras (volcano, MA, heatmap) + enriquecimiento funcional (GO/KEGG)
```

## 1. Control de calidad y limpieza (bash)

```bash
fastqc *.fastq.gz -o qc/           # reporte de calidad
multiqc qc/                        # consolida todos los reportes
fastp -i muestra_R1.fastq.gz -I muestra_R2.fastq.gz \
      -o muestra_R1.trim.fastq.gz -O muestra_R2.trim.fastq.gz
```

## 2. Cuantificación (ejemplo con Salmon)

```bash
salmon quant -i indice_transcriptoma -l A \
      -1 muestra_R1.trim.fastq.gz -2 muestra_R2.trim.fastq.gz \
      -p 8 -o cuant/muestra
```

## 3. Expresión diferencial en R (DESeq2)

```r
library(DESeq2)
# 'conteos' = matriz genes x muestras ; 'info' = condición de cada muestra
dds <- DESeqDataSetFromMatrix(countData = conteos,
                              colData   = info,
                              design    = ~ condicion)
dds <- DESeq(dds)
res <- results(dds, contrast = c("condicion", "tratamiento", "control"))
res <- res[order(res$padj), ]          # ordenar por significancia ajustada

# Genes significativos (FDR < 0.05 y cambio de al menos 2x)
sig <- subset(res, padj < 0.05 & abs(log2FoldChange) > 1)
```

## 4. Visualización

```r
# Volcano plot: significancia vs magnitud del cambio
plot(res$log2FoldChange, -log10(res$padj), pch = 20,
     xlab = "log2 Fold Change", ylab = "-log10(padj)")
abline(v = c(-1, 1), h = -log10(0.05), lty = 2, col = "red")

# Heatmap de los genes DE más significativos (patrones entre muestras)
library(pheatmap)
top <- head(rownames(res[order(res$padj), ]), 40)
pheatmap(assay(vst(dds))[top, ], scale = "row")
```

Después, enriquecimiento funcional (GO / KEGG con `clusterProfiler`) para
interpretar biológicamente la lista de genes.

## Herramientas usadas

FastQC · MultiQC · fastp/Trimmomatic · Salmon/STAR/HISAT2 · featureCounts ·
DESeq2 / edgeR · pheatmap · clusterProfiler.
