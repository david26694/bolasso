predict_bolasso_numeric <- function(model, predictors) {

  predict_bolasso_link(model, predictors)

}


predict_bolasso_prob <- function(model, predictors) {

  log_odds <- predict_bolasso_link(model, predictors)

  family <- stats::binomial()

  # solve for p: `log_odds = ln(p / (1 - p))`
  prob_success <- family$linkinv(log_odds$.pred)
  prob_failure <- 1 - prob_success

  # Reverse the probabilities since `levels` will have failure first
  prob <- cbind(prob_failure, prob_success)

  as_tibble(prob) %>%
    rename(.prob0 = prob_failure, .prob1 = prob_success)
  # TODO: Improve this with blueprint
  # blueprint <- model$blueprint
  #
  # levels <- levels(blueprint$ptypes$outcomes[[1]])
  #
  # hardhat::spruce_prob(levels, prob)
}

predict_bolasso_class <- function(model, predictors, threshold_class = 0.5) {

  prob_tbl <- predict_bolasso_prob(model, predictors)
  prob_failure <- prob_tbl$.prob0

  # TODO: Improve with blueprint
  pred_class <- as.factor(ifelse(prob_failure >= threshold_class, 1, 0))

  hardhat::spruce_class(pred_class)
}

predict_bolasso_link <- function(model, predictors) {

  # Rearrange to do matrix vector multiplication
  predictors[, "(Intercept)"] <- 1
  predictors <- predictors[, model$ridge_coefs$feature]

  # Obtain predictions of linear model
  predictions <- as.matrix(predictors) %*% model$ridge_coefs$value
  predictions <- as.vector(predictions)

  # Return in standard way
  hardhat::spruce_numeric(predictions)
}
