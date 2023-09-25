.has <- function(url, func) {
    if (is.null(url)) {
        return(logical(0))
    }
    func(url)
}

#' Check if URL has a certain component
#'
#' These functions check if URL has a certain component.
#' @inheritParams ada_url_parse
#' @return logical, `NA` if not a valid URL.
#' @examples
#' url <- c("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' ada_has_credentials(url)
#' ada_has_empty_hostname(url)
#' ada_has_hostname(url)
#' ada_has_non_empty_username(url)
#' ada_has_non_empty_password(url)
#' ada_has_port(url)
#' ada_has_hash(url)
#' ada_has_search(url)
#' ## these functions are vectorized
#' urls <- c("http://www.google.com", "http://www.google.com:80", "noturl")
#' ada_has_port(urls)
#' @export
ada_has_credentials <- function(url) {
    .has(url, Rcpp_ada_has_credentials)
}

#' @rdname ada_has_credentials
#' @export
ada_has_empty_hostname <- function(url) {
    .has(url, Rcpp_ada_has_empty_hostname)
}

#' @rdname ada_has_credentials
#' @export
ada_has_hostname <- function(url) {
    .has(url, Rcpp_ada_has_hostname)
}

#' @rdname ada_has_credentials
#' @export
ada_has_non_empty_username <- function(url) {
    .has(url, Rcpp_ada_has_non_empty_username)
}

#' @rdname ada_has_credentials
#' @export
ada_has_non_empty_password <- function(url) {
    .has(url, Rcpp_ada_has_non_empty_password)
}

#' @rdname ada_has_credentials
#' @export
ada_has_port <- function(url) {
    .has(url, Rcpp_ada_has_port)
}

#' @rdname ada_has_credentials
#' @export
ada_has_hash <- function(url) {
    .has(url, Rcpp_ada_has_hash)
}

#' @rdname ada_has_credentials
#' @export
ada_has_search <- function(url) {
    .has(url, Rcpp_ada_has_search)
}
