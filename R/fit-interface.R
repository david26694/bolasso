#' Fit a `bolasso`
#'
#' `bolasso()` applies bolasso to dataset. Bolasso is a feature selection technique
#' that applies lasso for feature to different bootstrap samples of the dataset, and
#' then keeps the features that are selection most of the time.
#'
#' @param x Depending on the context:
#'
#'   * A __data frame__ of predictors.
#'   * A __matrix__ of predictors.
#'   * A __recipe__ specifying a set of preprocessing steps
#'     created from [recipes::recipe()].
#'
#' @param y When `x` is a __data frame__ or __matrix__, `y` is the outcome
#' specified as:
#'
#'   * A __data frame__ with 1 numeric column.
#'   * A __matrix__ with 1 numeric column.
#'   * A numeric __vector__.
#'
#' @param data When a __recipe__ or __formula__ is used, `data` is specified as:
#'
#'   * A __data frame__ containing both the predictors and the outcome.
#'
#' @param formula A formula specifying the outcome terms on the left-hand side,
#' and the predictor terms on the right-hand side.
#'
#' @param ... Most importantly, n_bootstraps, threshold_selection, and ... of cv.glmnet.
#'
#' @return
#'
#' A `bolasso` object.
#'
#' @examples
#' predictors <- mtcars[,c("mpg", "disp", "hp", "drat", "wt")]
#' outcome <- mtcars[, "vs"]
#'
#' # XY interface
#' mod <- bolasso(predictors, outcome)
#'
#' # Formula interface
#' mod2 <- bolasso(vs ~ ., mtcars)
#'
#' # Recipes interface
#' library(recipes)
#' rec <- recipe(mpg ~ ., mtcars)
#' rec <- step_log(rec, disp)
#' mod3 <- bolasso(rec, mtcars)
#'
#' @export
bolasso <- function(x, ...) {
  UseMethod("bolasso")
}

#' @export
#' @rdname bolasso
bolasso.default <- function(x, ...) {
  stop("`bolasso()` is not defined for a '", class(x)[1], "'.", call. = FALSE)
}

# XY method - data frame

#' @export
#' @rdname bolasso
bolasso.data.frame <- function(x, y, ...) {
  processed <- hardhat::mold(x, y)
  bolasso_bridge(processed, ...)
}

# XY method - matrix

#' @export
#' @rdname bolasso
bolasso.matrix <- function(x, y, ...) {
  processed <- hardhat::mold(x, y)
  bolasso_bridge(processed, ...)
}

# Formula method

#' @export
#' @rdname bolasso
bolasso.formula <- function(formula, data, ...) {
  processed <- hardhat::mold(formula, data)
  bolasso_bridge(processed, ...)
}

# Recipe method

#' @export
#' @rdname bolasso
bolasso.recipe <- function(x, data, ...) {
  processed <- hardhat::mold(x, data)
  bolasso_bridge(processed, ...)
}
