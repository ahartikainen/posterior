#' Summaries of `draws` objects
#'
#' The `summarise_draws()` (and `summarize_draws()`) methods provide a quick way
#' to get a table of summary statistics and diagnostics. These methods will
#' convert an object to a `draws` object if it isn't already. For convenience, a
#' [summary()][base::summary] method for `draws` objects is also provided as an
#' alias for `summarise_draws()` if the input object is already a `draws`
#' object.
#'
#' @name draws_summary
#'
#' @param x,object A `draws` object or one coercible to a `draws` object.
#' @param ... Name-value pairs of summary functions.
#'   The name will be the name of the variable in the result unless
#'   the function returns a named vector in which case the latter names
#'   are used. Functions can be passed in all formats supported by
#'   [as_function()][rlang::as_function]. See the 'Examples' section below
#'   for examples.
#'
#' @return
#' The `summarise_draws()` methods return a [tibble][tibble::tibble] data frame.
#' The first column, `"variable"`, contains the variable names and the remaining
#' columns contain summary statistics and diagnostics.
#'
#' @details
#' By default, the following summary functions are used: [mean()], [median()],
#' [sd()], [mad()], [quantile2()], [rhat()], [ess_bulk()], and [ess_tail()].
#' The functions `default_summary_measures()`, `default_convergence_measures()`,
#' and `default_mcse_measures()` return character vectors of names of the
#' default measures included in the package.
#'
#' @examples
#' x <- example_draws("eight_schools")
#' class(x)
#' str(x)
#'
#' summarise_draws(x)
#' summarise_draws(x, "mean", "median")
#' summarise_draws(x, default_convergence_measures())
#' summarise_draws(x, mean, mcse = mcse_mean)
#' summarise_draws(x, ~quantile(.x, probs = c(0.4, 0.6)))
#'
NULL

#' @rdname draws_summary
#' @export
summarise_draws <- function(x, ...) {
  UseMethod("summarise_draws")
}

#' @rdname draws_summary
#' @export
summarize_draws <- summarise_draws


#' @export
summarise_draws.default <- function(x, ...) {
  x <- as_draws(x)
  summarise_draws(x, ...)
}

#' @rdname draws_summary
#' @export
summarise_draws.draws <- function(x, ...) {
  funs <- as.list(c(...))
  if (length(funs)) {
    if (is.null(names(funs))) {
      # ensure names are initialized properly
      names(funs) <- rep("", length(funs))
    }
    calls <- substitute(list(...))[-1]
    calls <- ulapply(calls, deparse2)
    for (i in seq_along(funs)) {
      fname <- NULL
      if (is.character(funs[[i]])) {
        fname <- as_one_character(funs[[i]])
      }
      # label unnamed arguments via their calls
      if (!nzchar(names(funs)[i])) {
        if (!is.null(fname)) {
          names(funs)[i] <- fname
        } else {
          names(funs)[i] <- calls[i]
        }
      }
      # get functions passed as stings from the right environments
      if (!is.null(fname)) {
        if (exists(fname, envir = caller_env())) {
          env <- caller_env()
        } else if (fname %in% getNamespaceExports("posterior")) {
          env <- asNamespace("posterior")
        } else {
          stop2("Cannot find function '", fname, "'.")
        }
      }
      funs[[i]] <- rlang::as_function(funs[[i]], env = env)
    }
  } else {
    # default functions
    funs <- list(
      mean = base::mean,
      median = stats::median,
      sd = stats::sd,
      mad = stats::mad,
      quantile = quantile2,
      rhat = rhat,
      ess_bulk = ess_bulk,
      ess_tail = ess_tail
    )
  }

  # it is more efficient to repair and transform objects for all variables
  # at once instead of doing it within the loop for each variable separately
  if (ndraws(x) == 0L) {
    return(empty_draws_summary())
  }
  x <- repair_draws(x)
  x <- as_draws_array(x)
  variables <- variables(x)
  out <- named_list(variables, values = list(named_list(names(funs))))
  for (v in variables) {
    draws <- drop_dims(x[, , v], dims = 3)
    for (m in names(funs)) {
      out[[v]][[m]] <- funs[[m]](draws)
      if (rlang::is_named(out[[v]][[m]])) {
        # use returned names to label columns
        out[[v]][[m]] <- rbind(out[[v]][[m]])
      }
    }
    out[[v]] <- do_call(cbind, out[[v]])
  }
  out <- tibble::as_tibble(do_call(rbind, out))
  if ("variable" %in% names(out)) {
    stop2("Name 'variable' is reserved in 'summarise_draws'.")
  }
  out$variable <- variables
  out <- move_to_start(out, "variable")
  class(out) <- class_draws_summary()
  out
}

#' @rdname draws_summary
#' @export
summary.draws <- function(object, ...) {
  summarise_draws(object, ...)
}

#' @rdname draws_summary
#' @export
default_summary_measures <- function() {
  c("mean", "median", "sd", "mad", "quantile2")
}

#' @rdname draws_summary
#' @export
default_convergence_measures <- function() {
  c("rhat", "ess_bulk", "ess_tail")
}

#' @rdname draws_summary
#' @export
default_mcse_measures <- function() {
  c("mcse_mean", "mcse_median", "mcse_sd", "mcse_quantile")
}

class_draws_summary <- function() {
  c("draws_summary", "tbl_df", "tbl", "data.frame")
}

# empty draws_summary object
# @param dimensions names of dimensions to be added as empty columns
empty_draws_summary <- function(dimensions = "variable") {
  assert_character(dimensions, null.ok = TRUE)
  out <- tibble::tibble()
  for (d in dimensions) {
    out[[d]] <- character(0)
  }
  class(out) <- class_draws_summary()
  out
}
