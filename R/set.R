.set <- function(url, decode, input, func) {
    if (is.null(url)) {
        return(character(0))
    }
    if (is.null(input)) {
        return(url)
    }
    if (length(input) == 1) {
        input <- rep(input, length(url))
    }
    if (length(input) != length(url)) {
        stop("input must have length one or the same length as url", call. = FALSE)
    }
    func(url, input, decode)
}

#' Set a specific component of URL
#'
#' These functions set a specific component of URL.
#' @inheritParams ada_url_parse
#' @param input character. containing new component for URL. Vector of length 1
#' or same length as url.
#' @return character, `NA` if not a valid URL
#' @examples
#' url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
#' ada_set_href(url, "https://google.de")
#' ada_set_username(url, "user_2")
#' ada_set_password(url, "hunter2")
#' ada_set_port(url, "1234")
#' ada_set_hash(url, "#section1")
#' ada_set_host(url, "example.de")
#' ada_set_hostname(url, "example.de")
#' ada_set_pathname(url, "path/")
#' ada_set_search(url, "q=2")
#' ada_set_protocol(url, "ws:")
#' @export
ada_set_href <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_href)
}

#' @rdname ada_set_href
#' @export
ada_set_username <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_username)
}

#' @rdname ada_set_href
#' @export
ada_set_password <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_password)
}

#' @rdname ada_set_href
#' @export
ada_set_port <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_port)
}

#' @rdname ada_set_href
#' @export
ada_set_host <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_host)
}

#' @rdname ada_set_href
#' @export
ada_set_hostname <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_hostname)
}

#' @rdname ada_set_href
#' @export
ada_set_pathname <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_pathname)
}

#' @rdname ada_set_href
#' @export
ada_set_protocol <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_protocol)
}

#' @rdname ada_set_href
#' @export
ada_set_search <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_search)
}

#' @rdname ada_set_href
#' @export
ada_set_hash <- function(url, input, decode = TRUE) {
    .set(url, decode, input, Rcpp_ada_set_hash)
}
