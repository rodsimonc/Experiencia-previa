# Ciencia de datos y análisis de datos

Esta carpeta es mi espacio de **data science / análisis de datos** aplicado a datos
de cualquier dominio (no solo biológicos). La idea es mostrar el flujo completo:
de un dataset crudo a insights, modelos y visualizaciones reproducibles.

> 🚧 **En construcción.** Estoy subiendo proyectos y ejemplos de forma continua.
> Abajo está el mapa de lo que vive (y va a vivir) acá.

---

## Qué hago cuando me llega un dataset

1. **Entender y cargar**: tipos, faltantes, escalas, duplicados (`pandas`).
2. **Análisis exploratorio (EDA)**: distribuciones, correlaciones, outliers, primeras hipótesis.
3. **Limpieza y *feature engineering***: normalización, encoding, variables derivadas.
4. **Modelado**: según la pregunta — inferencia estadística, regresión, o machine learning.
5. **Evaluación honesta**: train/test, validación cruzada, métricas apropiadas al problema.
6. **Comunicación**: visualizaciones claras y, cuando corresponde, un dashboard.

---

## Contenido

| Archivo | Qué muestra |
|---|---|
| [`plantilla_EDA.py`](./plantilla_EDA.py) | Plantilla reutilizable de análisis exploratorio con pandas + matplotlib |
| [`consultas_sql_analiticas.sql`](./consultas_sql_analiticas.sql) | Consultas SQL analíticas (agregaciones, JOINs, window functions) |
| [`pipeline_ml_python.py`](./pipeline_ml_python.py) | Pipeline de machine learning en Python (scikit-learn): preprocesamiento, CV, evaluación |

## Roadmap (lo que voy a ir sumando)

- **`01_eda/`** — análisis exploratorios de datasets concretos (con notebooks y conclusiones).
- **`02_sql/`** — casos de análisis con SQL sobre bases de datos reales.
- **`03_machine_learning/`** — proyectos de ML de punta a punta (clasificación, regresión, clustering).
- **`04_nlp_y_llm/`** — trabajo con texto y LLMs (incluye mi chatbot **RAG** con LangChain + FastAPI, en su propio repo).
- **`05_visualizacion_y_dashboards/`** — dashboards y reporting (Power BI, Plotly/Dash).

---

## Stack

**Python** (pandas, NumPy, scikit-learn, Matplotlib/Seaborn) · **SQL** ·
**R** para estadística (ver la carpeta [`bioestadística`](../bioestad%C3%ADstica)) ·
Jupyter / Google Colab · Git. En camino: Power BI, Docker, despliegue en la nube.

> Nota: la estadística más "dura" (multivariado, GLM/mixtos, bayesiano, ML en R) está
> en [`bioestadística`](../bioestad%C3%ADstica); acá el foco es el flujo de data science
> en Python y SQL, sobre datos de cualquier dominio.
