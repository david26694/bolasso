#' Low level bolasso implementation
#'
#' @details
#'
#' - x must be a matrix
#' - y must be a vector
#'
#' @param predictors A numeric tibble of predictors.
#' @param outcome A tibble with outcome
#'
#' @importFrom rsample bootstraps
#' @importFrom glmnet cv.glmnet
#'
#' @keywords internal
bolasso_impl <- function(predictors, outcome, n_bootsraps = 100, threshold_selection = 0.5, ...) {

  # Take all data to build samples with rsample
  full_data <- cbind(predictors, outcome)
  boots_samples <- rsample::bootstraps(full_data, times = n_bootsraps)


  # Use bootstrap samples to select features with bolasso
  selected_features_df <- purrr::map_dfr(
    boots_samples$splits,
    apply_feature_selection,
    threshold_selection,
    ...
  )

  # Retrain ridge
  ridge_coefs <- train_ridge(full_data, selected_features_df, threshold_selection, ...)

  # Return bolasso coefficients for analysis and ridge coefficients
  list(
    df_coefs = selected_features_df,
    ridge_coefs = ridge_coefs
    )

}


train_ridge <- function(full_data, selected_features_df, threshold_selection, lambda_min = T, ...){

  # Features that are selected more times than threshold selection
  selected_features <- selected_features_df %>%
    group_by(feature) %>%
    count(selected) %>%
    mutate(prop = n/sum(n)) %>%
    filter(selected == T, prop > threshold_selection) %>%
    ungroup() %>%
    pull(feature)

  # Obtain outcome and selected features
  outcome <- pull(full_data, outcome)
  predictors <- as.matrix(select(full_data, selected_features))

  # Train ridge with outcome and selected features
  ridge <- glmnet::cv.glmnet(
    x = as.matrix(predictors),
    y = outcome,
    alpha = 0,
    ...
  )

  # Select lambda at optimal metric or 1 sd
  if(lambda_min){
    lambda <- ridge$lambda.min
  } else{
    lambda <- ridge$lambda.1se
  }

  # Coefficients of lasso at given lambda
  df_coefs <- glmnet::coef.cv.glmnet(ridge, s = lambda) %>%
    as.matrix %>%
    as.data.frame()

  names <- rownames(df_coefs)
  values <- df_coefs[, 1]


  # Coefficients data frame clean
  df_coefs <- df_coefs %>%
    transmute(
      feature = rownames(.),
      value = `1`
    )

  df_coefs

}

apply_feature_selection <- function(boot_split, lambda_min = T, ...){

  df <- analysis(boot_split)

  outcome <- pull(df, outcome)
  predictors <- as.matrix(select(df, -outcome))

  # Train lasso using cross validation
  lasso <- glmnet::cv.glmnet(
    x = as.matrix(predictors),
    y = outcome,
    ...
  )

  # Select lambda at optimal metric or 1 sd
  if(lambda_min){
    lambda <- lasso$lambda.min
  } else{
    lambda <- lasso$lambda.1se
  }

  # Coefficients of lasso at given lambda
  df_coefs <- glmnet::coef.cv.glmnet(lasso, s = lambda) %>%
    as.matrix %>%
    as.data.frame()

  names <- rownames(df_coefs)
  values <- df_coefs[, 1]


  # Coefficients data frame clean
  df_coefs <- df_coefs %>%
    transmute(
      feature = rownames(.),
      value = `1`,
      selected = value != 0
    ) %>%
    # Non trivial features
    filter(feature != '(Intercept)')

  return(df_coefs)


}


