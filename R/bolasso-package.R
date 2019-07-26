#' bolasso: A package for variable selection via bolasso algorithm
#'
#' This package provides implementation of bolasso to select variables.
#' This is done via bootsrapping the training set and running a lasso in every bootstrap sample.
#' Then, only variables that appear in most of the bootstrap samples are selected and a ridge
#' is trained with those variables
#'
#'
#'
#' @docType package
#' @name bolasso
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL
