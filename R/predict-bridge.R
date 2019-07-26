predict_bolasso_bridge <- function(type, model, predictors, ...) {

  predict_function <- get_predict_function(type)
  predictions <- predict_function(model, predictors, ...)

  hardhat::validate_prediction_size(predictions, predictors)

  predictions
}

get_predict_function <- function(type) {
  switch(
    type,
    numeric = predict_bolasso_numeric,
    link = predict_bolasso_link,
    class = predict_bolasso_class,
    prob = predict_bolasso_prob
  )
}
