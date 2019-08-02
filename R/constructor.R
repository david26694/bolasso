new_bolasso <- function(df_coefs, ridge_coefs, threshold_selection, blueprint) {
  hardhat::new_model(
    df_coefs = df_coefs,
    ridge_coefs = ridge_coefs,
    threshold_selection = threshold_selection,
    blueprint = blueprint, class = "bolasso"
    )
}
