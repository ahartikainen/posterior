% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convergence.R
\name{rhat_basic}
\alias{rhat_basic}
\title{Basic version of the Rhat convergence diagnostic}
\usage{
rhat_basic(x, split = TRUE)
}
\arguments{
\item{x}{A 2D array of draws (iterations x chains).}

\item{split}{Logical. If \code{TRUE}, compute estimate on split chains.}
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
Compute the basic Rhat convergence diagnostic for a single variable as
described in Gelman et al. (2013). For practical applications, we strongly
recommend the improved Rhat convergence diagnostic implemented in
\code{\link[=rhat]{rhat()}}.
}
\examples{
mu <- extract_variable_matrix(example_draws(), "mu")
rhat_basic(mu)

}
\references{
Andrew Gelman, John B. Carlin, Hal S. Stern, David B. Dunson, Aki Vehtari and
Donald B. Rubin (2013). Bayesian Data Analysis, Third Edition. Chapman and
Hall/CRC.
}
\seealso{
Other diagnostics: 
\code{\link{ess_basic}()},
\code{\link{ess_bulk}()},
\code{\link{ess_quantile}()},
\code{\link{ess_sd}()},
\code{\link{ess_tail}()},
\code{\link{mcse_mean}()},
\code{\link{mcse_quantile}()},
\code{\link{mcse_sd}()},
\code{\link{rhat}()}
}
\concept{diagnostics}
