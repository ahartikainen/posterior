% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/convergence.R
\name{autocorrelation}
\alias{autocorrelation}
\title{Autocorrelation estimates}
\usage{
autocorrelation(x)
}
\arguments{
\item{x}{A numeric vector forming a sequence of values.}
}
\value{
A numeric vector of autocorrelations at every lag (scaled by N-lag).
}
\description{
Compute autocorrelation estimates for every lag for the specified
input sequence using a fast Fourier transform approach. The estimate
for lag t is scaled by N-t where N is the length of the sequence.
}
\keyword{internal}
