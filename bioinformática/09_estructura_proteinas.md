# Workflow: estructura de proteínas y modelado por homología

Cómo paso de una secuencia de proteína sin estructura conocida a un **modelo
tridimensional** útil para razonar sobre función, sitios activos e interacciones.

## Pipeline

```
Secuencia problema (FASTA)
      │  buscar plantillas con estructura resuelta
      ▼
BLAST / HHsearch contra PDB   →  elegir molde(s) por identidad y cobertura
      │
      ▼
Alineamiento secuencia-molde
      │
      ▼
Modelado por homología (MODELLER / SWISS-MODEL)
      │
      ▼
Validación del modelo  →  análisis estructural / docking
```

## 1. Buscar plantillas

Se busca en el **PDB** una o más proteínas de estructura conocida homólogas a la
secuencia problema (por BLAST o perfiles HMM). Se eligen por identidad de
secuencia y cobertura: a mayor identidad, más confiable el modelo.

## 2. Modelado por homología

- **SWISS-MODEL** (servicio web) para un modelo rápido.
- **MODELLER** (Python) para control fino: alineamiento molde-objetivo,
  generación de múltiples modelos y selección por función de energía (DOPE).

## 3. Validación

- Gráfico de **Ramachandran** (ángulos φ/ψ dentro de regiones permitidas).
- Puntajes de calidad (QMEAN, DOPE) y comparación con el molde.

## 4. Análisis estructural y visualización

- **PyMOL / Chimera** para inspeccionar el plegamiento, mapear residuos
  conservados (los del logo de secuencia del workflow filogenético) sobre la
  estructura, e identificar el sitio activo.
- **Docking** (AutoDock Vina) para explorar la unión de ligandos.

## Contexto

En mi TP final combiné esto con la parte filogenética: partí de una familia de
proteínas, inferí su árbol (ver
[`05_alineamiento_y_filogenia.md`](./05_alineamiento_y_filogenia.md)), identifiqué
residuos conservados con logos de secuencia (información de Shannon/Kullback) y los
interpreté sobre la estructura modelada.

## Herramientas usadas

BLAST/HHsearch · PDB · SWISS-MODEL / MODELLER · Ramachandran / QMEAN · PyMOL /
Chimera · AutoDock Vina.
