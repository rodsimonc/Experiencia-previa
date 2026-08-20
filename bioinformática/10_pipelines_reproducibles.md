# Workflow: automatización y pipelines reproducibles

Un análisis bioinformático que no se puede volver a correr igual no sirve. Acá
está cómo automatizo y hago reproducible el trabajo: desde bash para pegar pasos,
hasta gestores de flujo y contenedores.

## 1. Bash: pegar herramientas y procesar en lote

La línea de comandos de Linux es el pegamento del día a día: pipes, redirección
y bucles para aplicar el mismo paso a muchos archivos.

```bash
# Traducir todos los FASTA de un directorio, en paralelo
for f in *.fasta; do
    transeq -sequence "$f" -outseq "${f%.fasta}_prot.fasta"
done

# Contar secuencias por archivo y ordenar
grep -c ">" *.fasta | sort -t: -k2 -n

# Encadenar: filtrar, ordenar y quedarse con lo relevante
cat hits.tsv | awk '$3 > 90' | sort -k12 -nr | head -20
```

## 2. Snakemake / Nextflow: flujos con dependencias

Cuando el pipeline tiene muchos pasos con dependencias, un gestor de flujo
declara *qué* se produce a partir de *qué*, corre solo lo necesario, paraleliza
y documenta el pipeline entero.

```python
# Snakemake (esquema): cada regla define entradas, salidas y el comando
rule cuantificar:
    input:  "trim/{muestra}_R1.fastq.gz", "trim/{muestra}_R2.fastq.gz"
    output: "cuant/{muestra}/quant.sf"
    threads: 8
    shell:  "salmon quant -i {indice} -l A -1 {input[0]} -2 {input[1]} "
            "-p {threads} -o cuant/{wildcards.muestra}"
```

## 3. Docker: mismo entorno en todos lados

Un contenedor congela versiones de herramientas y dependencias, así el análisis
corre igual en mi máquina, en un servidor o dentro de un pipeline.

```dockerfile
FROM continuumio/miniconda3
RUN conda install -c bioconda salmon deseq2 snakemake
```

## 4. Control de versiones

Git para versionar código y parámetros (este mismo repositorio es un ejemplo),
de modo que cada resultado se pueda rastrear al código exacto que lo generó.

## Idea clave

Reproducibilidad = otra persona (o yo dentro de seis meses) puede correr el mismo
análisis y obtener el mismo resultado. Bash resuelve lo rápido; Snakemake/Nextflow
y Docker hacen que un pipeline complejo sea reejecutable y portable.

## Herramientas usadas

bash / GNU coreutils · Snakemake · Nextflow · Docker / conda · Git.
