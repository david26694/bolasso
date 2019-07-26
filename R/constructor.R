new_bolasso <- function(df_coefs, ridge_coefs, blueprint) {
  hardhat::new_model(
    df_coefs = df_coefs, ridge_coefs = ridge_coefs,
    blueprint = blueprint, class = "bolasso"
    )
}
