
<!-- README.md is generated from README.Rmd. Please edit that file -->

# bolasso

The goal of bolasso is to apply robust feature selection via lasso and
bootsrtapping.

## Installation

You can install bolasso from github with:

``` r
# install.packages("devtools")
devtools::install_github("david26694/bolasso")
```

## Example

This is a basic example which shows you how to apply bolasso in a
regression setting:

``` r
## basic example code
library(bolasso)

# We want to predict vs with the other mtcars variables
predictors <- mtcars[,c("mpg", "disp", "hp", "drat", "wt")]
outcome <- mtcars[, "vs"]

# Apply bolasso with 10 bootstrap samples
model <- bolasso(predictors, outcome, n_bootstraps = 10)

# Show variable selection results
summary(model)
#> Joining, by = "feature"
#> # A tibble: 5 x 4
#>   feature selection_ratio coefficient selected_bolasso
#>   <chr>             <dbl>       <dbl> <lgl>           
#> 1 hp                  1      NA       FALSE           
#> 2 disp                0.9    -0.00176 TRUE            
#> 3 mpg                 0.7     0.0222  TRUE            
#> 4 drat                0.5    NA       FALSE           
#> 5 wt                  0.4    NA       FALSE

# It can also run on recipes, and with formulas
library(recipes)
#> Loading required package: dplyr
#> Warning: package 'dplyr' was built under R version 3.5.2
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
#> 
#> Attaching package: 'recipes'
#> The following object is masked from 'package:stats':
#> 
#>     step
rec <- recipe(mpg ~ ., mtcars)
rec <- step_log(rec, disp)
model_rec <- bolasso(rec, mtcars, n_bootstraps = 20)

summary(model_rec)
#> Joining, by = "feature"
#> # A tibble: 10 x 4
#>    feature selection_ratio coefficient selected_bolasso
#>    <chr>             <dbl>       <dbl> <lgl>           
#>  1 disp               0.95      -7.62  TRUE            
#>  2 carb               0.85      -0.764 TRUE            
#>  3 wt                 0.85      NA     FALSE           
#>  4 drat               0.55      NA     FALSE           
#>  5 am                 0.45      NA     FALSE           
#>  6 hp                 0.45      NA     FALSE           
#>  7 gear               0.4       NA     FALSE           
#>  8 cyl                0.35      NA     FALSE           
#>  9 qsec               0.3       NA     FALSE           
#> 10 vs                 0.25      NA     FALSE

# It has different types of prediction, like numeric, class and prob
predict(model_rec, mtcars, type = 'numeric')
#> # A tibble: 32 x 1
#>    .pred
#>    <dbl>
#>  1  20.8
#>  2  20.8
#>  3  26.1
#>  4  19.4
#>  5  16.1
#>  6  20.5
#>  7  14.6
#>  8  23.0
#>  9  23.3
#> 10  20.4
#> # … with 22 more rows
```
