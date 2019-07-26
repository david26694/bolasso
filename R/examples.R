# #
# #
# #
# #
# #
# #
# # # Davis examples with bolasso -----------------------------------------------------------------
# #
# #
# #
# # # Fit examples bolasso
# #
# #
# # predictors <- as.matrix(mtcars[,c("mpg", "disp", "hp")])
# # outcome <- as.factor(mtcars$vs)
# #
# # bl <- bolasso(predictors, outcome, family = 'binomial', type.measure = 'auc')
# #
# # bl <- bolasso(vs ~ mpg + disp + hp, mtcars, n_bootsraps = 10, family = 'binomial', threshold_selection = 0.5)
# #
# # model <- bl
# # model$blueprint$ptypes
# #
# # predictors_test <- mtcars[,c("mpg", "disp", "hp")]
# # predictors <- predictors_test
# #
# # predictors_test[, "(Intercept)"] <- 1
# # predictors_test <- predictors_test[, model$ridge_coefs$feature]
# #
# # as.matrix(predictors_test) %*% model$ridge_coefs$value
# #
# #
# # # Predict examples bolasso
# #
# # fit <- glmnet::cv.glmnet(predictors, outcome)
# #
# # glmnet::coef.glmnet(fit, s = fit$lambda.min)
# #
# #
# # # Coefficients of lasso at given lambda
# # df_coefs <- glmnet::coef.cv.glmnet(fit, s = fit$lambda.min) %>%
# #   as.matrix %>%
# #   as.data.frame()
# #
# # names <- rownames(df_coefs)
# # values <- df_coefs[, 1]
# #
# #
# # # Coefficients data frame clean
# # df_coefs <- df_coefs %>%
# #   transmute(
# #     feature = rownames(.),
# #     value = `1`
# #   )
# #
# #
# # Davis final example -------------------------------------------------------------------------
#
# library(yardstick)
# library(dplyr)
# library(rsample)
# library(tibble)
# library(dplyr)
# library(hardhat)
#
# set.seed(123)
#
# split <- initial_split(mtcars)
# train <- training(split)
# test <- testing(split)
#
# model <- bolasso(vs ~ mpg + disp + hp, mtcars, n_bootsraps = 10, family = 'binomial', threshold_selection = 0.5)
#
# predict(model, test)
#
# predict(model, test, type = "class")
# predict(model, test, type = "prob")
#



# predictors <- mtcars[,c("mpg", "disp", "hp")]
# outcome <- mtcars[, c("vs")]
#
# # XY interface
# mod <- bolasso(predictors, outcome)
#
# # Formula interface
# mod2 <- bolasso(mpg ~ ., mtcars)
#
# # Recipes interface
# library(recipes)
# rec <- recipe(mpg ~ ., mtcars)
# rec <- step_log(rec, disp)
# mod3 <- bolasso(rec, mtcars)


#' predictors <- mtcars[,c("mpg", "disp", "hp")]
#' outcome <- mtcars[, "vs"]
