#' Check if URL has credentials
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_has_credentials("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_has_credentials <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    vapply(url, function(x) vapply(url, function(x) Rcpp_ada_has_credentials(x, nchar(x, type = "bytes")), logical(1)), logical(1))
}

#' Check if URL has an empty hostname
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_has_empty_hostname("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_has_empty_hostname <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    vapply(url, function(x) Rcpp_ada_has_empty_hostname(x, nchar(x, type = "bytes")), logical(1))
}

#' Check if URL has a hostname
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_has_hostname("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_has_hostname <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    vapply(url, function(x) Rcpp_ada_has_hostname(x, nchar(x, type = "bytes")), logical(1))
}

#' Check if URL has a non empty username
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_has_non_empty_username("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_has_non_empty_username <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    vapply(url, function(x) Rcpp_ada_has_non_empty_username(x, nchar(x, type = "bytes")), logical(1))
}

#' Check if URL has a non empty password
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_has_non_empty_password("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_has_non_empty_password <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    vapply(url, function(x) Rcpp_ada_has_non_empty_password(x, nchar(x, type = "bytes")), logical(1))
}

#' Check if URL has a port
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_has_port("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_has_port <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    vapply(url, function(x) Rcpp_ada_has_port(x, nchar(x, type = "bytes")), logical(1))
}

#' Check if URL has a hash
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_has_hash("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_has_hash <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    vapply(url, function(x) Rcpp_ada_has_hash(x, nchar(x, type = "bytes")), logical(1))
}

#' Check if URL has a search
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_has_search("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_has_search <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    vapply(url, function(x) Rcpp_ada_has_search(x, nchar(x, type = "bytes")), logical(1))
}
