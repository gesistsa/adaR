#' Validate the `url` argument shared by all exported functions
#'
#' Returns `NULL` for a `NULL` input, so callers can short-circuit to a
#' zero-length result, and otherwise a character vector.
#' @noRd
.check_url <- function(url, arg = "url") {
    if (is.null(url)) {
        return(NULL)
    }
    if (is.factor(url)) {
        return(as.character(url))
    }
    # `NA` is logical; accept an all-NA vector as the character equivalent
    if (is.logical(url) && all(is.na(url))) {
        return(as.character(url))
    }
    if (!is.character(url)) {
        stop(sprintf(
            "`%s` must be a character vector, not %s.", arg, class(url)[1]
        ), call. = FALSE)
    }
    url
}

#' Dispatch to an Rcpp worker with the shared NULL/type handling
#'
#' `empty` is the zero-length value to return for a `NULL` input; it also fixes
#' the return type of the exported function.
#' @noRd
.ada_call <- function(url, func, ..., empty = character(0)) {
    url <- .check_url(url)
    if (is.null(url)) {
        return(empty)
    }
    func(url, ...)
}

#' Dispatch for the `ada_set_*` family
#'
#' Adds recycling and length checking of `input` on top of `.ada_call()`.
#' @noRd
.set <- function(url, input, decode, func) {
    url <- .check_url(url)
    if (is.null(url)) {
        return(character(0))
    }
    if (is.null(input)) {
        return(url)
    }
    input <- .check_url(input, arg = "input")
    if (length(input) == 1L) {
        input <- rep(input, length(url))
    } else if (length(input) != length(url)) {
        stop("input must have length one or the same length as url", call. = FALSE)
    }
    func(url, input, decode)
}
