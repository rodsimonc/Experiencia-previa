# Ciencia de datos y análisis de datos

Esta carpeta es mi espacio de **data science / análisis de datos** aplicado a datos
de cualquier dominio (no solo biológicos). La idea es mostrar el flujo completo:
de un dataset crudo a insights, modelos y visualizaciones reproducibles.

> 🚧 **En construcción.** Sumo proyectos y ejemplos de forma continua.

---

## Qué hago cuando me llega un dataset

1. **Entender y cargar**: tipos, faltantes, escalas, duplicados (`pandas`).
2. **Análisis exploratorio (EDA)**: distribuciones, correlaciones, outliers, primeras hipótesis.
3. **Limpieza y *feature engineering***: normalización, encoding, variables derivadas.
4. **Modelado**: según la pregunta — inferencia estadística, regresión, o machine learning.
5. **Evaluación honesta**: train/test, validación cruzada, métricas apropiadas al problema.
6. **Comunicación**: visualizaciones claras y una recomendación accionable.

---

## Contenido

### Flujo de análisis y modelado

| Archivo | Qué muestra |
|---|---|
| [`plantilla_EDA.py`](./plantilla_EDA.py) | Análisis exploratorio reutilizable (pandas + matplotlib) |
| [`feature_engineering.py`](./feature_engineering.py) | Preprocesamiento y variables derivadas sin *data leakage* (`ColumnTransformer`) |
| [`pipeline_ml_python.py`](./pipeline_ml_python.py) | Pipeline de ML end-to-end (scikit-learn): preprocesamiento + CV + evaluación |
| [`evaluacion_de_modelos.py`](./evaluacion_de_modelos.py) | Evaluación honesta con clases desbalanceadas (PR-AUC, umbral óptimo, recall de la minoritaria) |
| [`clustering_y_segmentacion.py`](./clustering_y_segmentacion.py) | Segmentación no supervisada (KMeans + PCA) con elección y perfilado de grupos |

### Estadística para decisiones

| Archivo | Qué muestra |
|---|---|
| [`estadistica_ab_testing.py`](./estadistica_ab_testing.py) | Análisis de experimentos A/B: tamaño de muestra, potencia, tamaño de efecto e IC |
| [`consultas_sql_analiticas.sql`](./consultas_sql_analiticas.sql) | SQL analítico: agregaciones, JOINs, subconsultas y window functions |

### NLP y LLMs

| Archivo | Qué muestra |
|---|---|
| [`llm_evaluation.py`](./llm_evaluation.py) | Evaluación estructurada de salidas de LLM: rúbrica, validación de JSON y métricas agregadas |

> Esto último conecta con mi experiencia laboral como **AI Trainer / evaluador**
> (Turing, Outlier) y con mi chatbot **RAG** (LangChain + FastAPI), en su propio repo.

## Roadmap (lo que sigue)

- **Proyectos end-to-end** sobre datasets reales, con notebook + conclusiones de negocio.
- **NLP/LLM**: ejemplo mínimo de RAG y un evaluador tipo *LLM-as-a-judge*.
- **Visualización y dashboards**: Plotly/Dash y Power BI.
- **Series temporales** y modelos de pronóstico.

---

## Stack

**Python** (pandas, NumPy, scikit-learn, SciPy, statsmodels, Matplotlib) · **SQL** ·
**R** para estadística (ver [`bioestadística`](../bioestad%C3%ADstica)) ·
Jupyter / Google Colab · Git. En camino: Power BI, Docker, despliegue en la nube.

> Nota: la estadística más "dura" (multivariado, GLM/mixtos, bayesiano, ML en R) está
> en [`bioestadística`](../bioestad%C3%ADstica); acá el foco es el flujo de data science
> en Python y SQL, sobre datos de cualquier dominio.
