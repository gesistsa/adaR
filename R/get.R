.get <- function(url, decode, func) {
    if (is.null(url)) {
        return(character(0))
    }
    out <- func(url)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}

#' Get href component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_href("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_href <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_href)
}

#' Get username component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_username("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_username <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_username)
}

#' Get password component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_password("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_password <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_password)
}

#' Get port component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_port("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_port <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_port)
}

#' Get hash component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_hash("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_hash <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_hash)
}

#' Get host component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_host("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_host <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_host)
}

#' Get hostname component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_hostname("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_hostname <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_hostname)
}

#' Get pathname component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_pathname("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_pathname <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_pathname)
}

#' Get search component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_search("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_search <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_search)
}

#' Get protocol component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_protocol("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_protocol <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_protocol)
}
