# =============================================================================
# 10 - Machine learning (clasificación supervisada)
# -----------------------------------------------------------------------------
# Pregunta típica: quiero PREDECIR una clase o valor a partir de muchas
# variables, priorizando la capacidad predictiva sobre la interpretación de cada
# coeficiente, y evaluándola honestamente (sin sobreajuste). Uso Random Forest
# con validación cruzada vía caret.
# =============================================================================

library(caret)
library(randomForest)
library(pROC)

datos <- read.table("datos.txt", header = TRUE)
datos$clase <- as.factor(datos$clase)   # variable respuesta categórica

# ---- Partición train / test -------------------------------------------------
# Separo datos de entrenamiento y de prueba para evaluar sin engañarme.
set.seed(123)
idx   <- createDataPartition(datos$clase, p = 0.7, list = FALSE)
train <- datos[idx, ]
test  <- datos[-idx, ]

# ---- Entrenamiento con validación cruzada -----------------------------------
# 10-fold CV: estima el desempeño de forma robusta y ajusta hiperparámetros.
ctrl <- trainControl(method = "cv", number = 10, classProbs = TRUE,
                     summaryFunction = twoClassSummary)
modelo <- train(clase ~ ., data = train, method = "rf",
                trControl = ctrl, metric = "ROC", tuneLength = 5)
modelo

# ---- Evaluación en el conjunto de prueba ------------------------------------
pred <- predict(modelo, test)
confusionMatrix(pred, test$clase)               # accuracy, sensibilidad, especificidad

# Curva ROC y AUC (capacidad de discriminación)
prob <- predict(modelo, test, type = "prob")[, 2]
roc_obj <- roc(test$clase, prob)
plot(roc_obj); auc(roc_obj)

# ---- Importancia de variables -----------------------------------------------
# Qué variables aportan más a la predicción (interpretabilidad del modelo).
varImpPlot(modelo$finalModel, main = "Importancia de variables")

# =============================================================================
# Idea clave: en ML lo central es evaluar SIN sobreajustar — por eso separo
# train/test y uso validación cruzada. Reporto métricas apropiadas al problema
# (ROC/AUC, sensibilidad/especificidad, no solo accuracy) y miro la importancia
# de variables para que el modelo no sea una caja negra.
# =============================================================================
