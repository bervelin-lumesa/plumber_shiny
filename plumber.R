
library(plumber)
library(randomForest)

model <- readRDS("rand_forest.rds")

if (is.null(model)) {
  stop("Le modèle n'a pas été chargé correctement")
}

#* @apiTitle API de prédiction d'espèce Iris
#* @apiDescription Cette API est basée sur un modèle de forêts 
#* aléatoires entraîné avec les données Iris pour prédire l'espèce de fleur. 


#* Return the prediction
#* @param Sepal_Length
#* @param Sepal_Width
#* @param Petal_Length
#* @param Petal_Width


#* @post /species-predict
function(Sepal_Length, Sepal_Width, Petal_Length, Petal_Width){
  
  df <- data.frame(
    Sepal.Length = as.numeric(Sepal_Length),
    Sepal.Width  = as.numeric(Sepal_Width),
    Petal.Length = as.numeric(Petal_Length),
    Petal.Width  = as.numeric(Petal_Width)
  )
  
  predict(model, newdata = df)
  
  
}

