.clear <- function(url, decode, func, to_unicode) {
    if (is.null(url)) {
        return(character(0))
    }
    func(url, decode, to_unicode)
}

#' Clear a specific component of URL
#'
#' These functions clears a specific component of URL.
#' @inheritParams ada_url_parse
#' @return character, `NA` if not a valid URL
#' @examples
#' url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
#' ada_clear_port(url)
#' ada_clear_hash(url)
#' ada_clear_search(url)
#' @export
ada_clear_port <- function(url, decode = TRUE, to_unicode = TRUE) {
    .clear(url, decode, Rcpp_ada_clear_port, to_unicode)
}

#' @rdname ada_clear_port
#' @export
ada_clear_hash <- function(url, decode = TRUE, to_unicode = TRUE) {
    .clear(url, decode, Rcpp_ada_clear_hash, to_unicode)
}

#' @rdname ada_clear_port
#' @export
ada_clear_search <- function(url, decode = TRUE, to_unicode = TRUE) {
    .clear(url, decode, Rcpp_ada_clear_search, to_unicode)
}
