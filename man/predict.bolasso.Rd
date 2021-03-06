% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/predict-interface.R
\name{predict.bolasso}
\alias{predict.bolasso}
\title{Predict from a \code{bolasso}}
\usage{
\method{predict}{bolasso}(object, new_data, type = "prob", ...)
}
\arguments{
\item{object}{A \code{bolasso} object.}

\item{new_data}{A data frame or matrix of new predictors.}

\item{type}{A single character. The type of predictions to generate.
Valid options are:
\itemize{
\item \code{"numeric"} for numeric predictions (output of X*beta).
\item \code{"link"} same as numeric.
\item \code{"prob"} for probabilities (apply logit transformation to link).
\item \code{"class"} for classes (based on threshold class is set to 0 or 1).
}}

\item{...}{Used to pass threshold when using class predictions.}
}
\value{
A tibble of predictions. The number of rows in the tibble is guaranteed
to be the same as the number of rows in \code{new_data}.
}
\description{
Predict from a \code{bolasso}
}
\examples{

}
