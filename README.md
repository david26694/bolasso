
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
#> # A tibble: 5 x 4
#>   feature selection_ratio coefficient selected_bolasso
#>   <chr>             <dbl>       <dbl> <lgl>           
#> 1 hp                  1      -0.00273 TRUE            
#> 2 disp                0.9    -0.00139 TRUE            
#> 3 drat                0.5    NA       FALSE           
#> 4 mpg                 0.5    NA       FALSE           
#> 5 wt                  0.5    NA       FALSE

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
#> # A tibble: 10 x 4
#>    feature selection_ratio coefficient selected_bolasso
#>    <chr>             <dbl>       <dbl> <lgl>           
#>  1 wt                 1         -1.73  TRUE            
#>  2 disp               0.9       -4.39  TRUE            
#>  3 carb               0.85      -0.785 TRUE            
#>  4 hp                 0.65      NA     FALSE           
#>  5 drat               0.6        1.40  TRUE            
#>  6 am                 0.35      NA     FALSE           
#>  7 gear               0.35      NA     FALSE           
#>  8 qsec               0.35      NA     FALSE           
#>  9 vs                 0.3       NA     FALSE           
#> 10 cyl                0.2       NA     FALSE

# It has different types of prediction, like numeric, class and prob
predict(model_rec, mtcars, type = 'numeric')
#> # A tibble: 32 x 1
#>    .pred
#>    <dbl>
#>  1  21.5
#>  2  21.1
#>  3  26.1
#>  4  19.6
#>  5  17.1
#>  6  19.3
#>  7  15.4
#>  8  22.2
#>  9  22.8
#> 10  19.9
#> # … with 22 more rows
```
