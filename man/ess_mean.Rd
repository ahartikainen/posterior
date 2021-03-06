% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convergence.R
\name{ess_mean}
\alias{ess_mean}
\title{Effective sample size for the mean}
\usage{
ess_mean(x)
}
\arguments{
\item{x}{A 2D array of draws (iterations x chains).}
}
\value{
A single numeric value. If any of the draws is non-finite, that is, \code{NA},
\code{NaN}, \code{Inf}, or \code{-Inf}, the returned output will be (numeric) \code{NA}. Also, if
all draws of a variable are the same, that is, if draws are constant, the
returned output will be (numeric) \code{NA} as well. The reason for the latter is
that, for constant draws, we cannot distinguish between variables that are
supposed to be constant (e.g., for a diagonal element of a correlation
matrix, which will always be 1) or variables that just happened to be
constant because of a failure of convergence or other problems in the
sampling process.
}
\description{
Compute effective sample size estimate for a mean (expectation)
estimate of a single variable.
}
\examples{
mu <- extract_variable_matrix(example_draws(), "mu")
ess_mean(mu)

}
\references{
Andrew Gelman, John B. Carlin, Hal S. Stern, David B. Dunson, Aki Vehtari and
Donald B. Rubin (2013). Bayesian Data Analysis, Third Edition. Chapman and
Hall/CRC.
}
