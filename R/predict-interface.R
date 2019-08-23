#' Predict from a `bolasso`
#'
#' @param object A `bolasso` object.
#'
#' @param new_data A data frame or matrix of new predictors.
#'
#' @param type A single character. The type of predictions to generate.
#' Valid options are:
#'
#' - `"numeric"` for numeric predictions (output of X*beta).
#' - `"link"` same as numeric.
#' - `"prob"` for probabilities (apply logit transformation to link).
#' - `"class"` for classes (based on threshold class is set to 0 or 1).
#'
#' @param ... Used to pass threshold when using class predictions.
#'
#' @return
#'
#' A tibble of predictions. The number of rows in the tibble is guaranteed
#' to be the same as the number of rows in `new_data`.
#'
#' @examples
# train <- mtcars[1:20,]
# test <- mtcars[21:32, -1]
#
# # Fit
# mod <- bolasso(mpg ~ cyl + log(drat), train)
#
# # Predict, with preprocessing
# predict(mod, test)
#'
#' @export
predict.bolasso <- function(object, new_data, type = "prob", ...) {
  forged <- hardhat::forge(new_data, object$blueprint)
  rlang::arg_match(type, valid_predict_types())
  predict_bolasso_bridge(type, object, forged$predictors, ...)
}

valid_predict_types <- function() {
  c("numeric", "link", "prob", "class")
}
