new_bolasso <- function(df_coefs, ridge_coefs, threshold_selection, blueprint) {
  hardhat::new_model(
    df_coefs = df_coefs,
    ridge_coefs = ridge_coefs,
    threshold_selection = threshold_selection,
    blueprint = blueprint, class = "bolasso"
    )
}



#' Summarise a `bolasso`
#'
#' The summary of a bolasso is structured as a `tbl`.
#' Every row of the `tbl` represents a feature and it always has 4 columns:
#'  \itemize{
#'   \item feature: name of the feature
#'   \item selection_ratio: proportion of the times that the feature is selected
#'   \item selected_bolasso: TRUE if selected_ratio is large enough for the feature to be selected
#'   \item coefficient: Coefficient in ridge regression trained afterwards
#'  }
#'
#' @param model `bolasso` object to summarise
#'
#'
#' @return
#'
#' A `tbl` with summary information of a `bolasso` object.
#'
#' @examples
#'
#' predictors <- mtcars[,c("mpg", "disp", "hp", "drat", "wt")]
#' outcome <- mtcars[, "vs"]
#'
#'
#' mod <- bolasso(predictors, outcome, n_bootstraps = 10)
#'
#' summary(mod)
#'
#' @export
summary.bolasso <- function(model){

  # Use ridge information to account for selected variables
  ridge_coefficients <- model$ridge_coefs %>% rename(coefficient = value)
  ridge_coefficients$selected_bolasso <- T

  # Obtain proportion of times selected by feature
  selection_rates <- model$df_coefs %>%
    group_by(feature) %>%
    summarise(selection_ratio = sum(selected)/n()) %>%
    arrange(desc(selection_ratio))

  summary_bolasso <- selection_rates %>%
    left_join(ridge_coefficients, by = 'feature') %>%
    # If it doesn't appear in ridge, it is not selected
    mutate(selected_bolasso = coalesce(selected_bolasso, F))

  summary_bolasso

}


#' plot a `bolasso`
#'
#' The ggplot of a `bolasso` is a facet.
#' In each plot of the facet, there is an histogram of coefficients that the feature obtains in each
#' of the bootsrap samples. A red line shows the 0 coefficient value. If there are points at both sides
#' of the red line, it means that the feature has both positive and negative signs, which doesn't make sense.
#'
#' @param model `bolasso` object to plot
#' @param threshold_selection If it is NULL, only variables with selection_rate above the one in the model
#' are plotted. We can set this value to lower or higher to plot more or less variables.
#'
#'
#' @return
#'
#' A `ggplot` object, faceted and with the distribution of each variable in it.
#'
#' @examples
#'
#' predictors <- mtcars[,c("mpg", "disp", "hp", "drat", "wt")]
#' outcome <- mtcars[, "vs"]
#'
#'
#' mod <- bolasso(predictors, outcome, n_bootstraps = 50)
#'
#' ggplot(mod)
#' ggplot(mod, threshold_selection = 0.8)
#' ggplot(mod, threshold_selection = 0.2)
#'
#' @export
ggplot.bolasso <- function(model, threshold_selection = NULL){

  # If a threshold is not provided, we use the one provided in the constructor
  # and used to select variables
  if(is.null(threshold_selection)){
    threshold_selection <- model$threshold_selection
  }

  # Only take variables whose selection rate is above threshold_selection
  filter_variables <- model$df_coefs %>%
    group_by(feature) %>%
    mutate(
      ratio_selection = sum(selected)/n()
    ) %>%
    filter(ratio_selection > threshold_selection)

  # This is for the facet to be as most squared as possible
  ncol <- round(sqrt(length(unique(filter_variables$feature))))

  # Histogram and vertical line
  p <- ggplot2::ggplot(filter_variables, aes(x = value)) +
    ggplot2::geom_histogram() +
    ggplot2::geom_vline(xintercept = 0, color = "red") +
    theme_minimal()

  # Facet
  p +
    ggplot2::facet_wrap(~ feature, ncol = ncol) +
    ggplot2::theme(aspect.ratio = 1)



}
