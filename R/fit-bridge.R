#' Fit bridge
#'
#' @details
#'
#' The bridge connects the high level interface methods with the low level
#' implementation.
#'
#' Pass through other objects to the implementation function as required.
#'
#' @param processed
#'
#' @keywords internal
bolasso_bridge <- function(processed, ...) {

  # Predictors work: if not numeric, glmnet will crash
  predictors <- processed$predictors
  hardhat::validate_predictors_are_numeric(predictors)

  # Outcome work
  outcome <- processed$outcomes[[1]]

  fit <- bolasso_impl(predictors, outcome, ...)

  new_bolasso(
    df_coefs = fit$df_coefs,
    ridge_coefs = fit$ridge_coefs,
    blueprint = processed$blueprint
  )
}
