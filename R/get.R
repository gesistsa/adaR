#' Get href component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_href("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_href <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_href(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}

#' Get username component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_username("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_username <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_username(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}


#' Get password component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_password("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_password <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_password(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}


#' Get port component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_port("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_port <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_port(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}


#' Get hash component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_hash("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_hash <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_hash(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}


#' Get host component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_host("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_host <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_host(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}


#' Get hostname component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_hostname("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_hostname <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_hostname(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}


#' Get pathname component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_pathname("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_pathname <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_pathname(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}


#' Get search component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_search("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_search <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_search(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}


#' Get protocol component of URL
#' @inheritParams ada_url_parse
#' @return logical
#' @examples
#' ada_get_protocol("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_get_protocol <- function(url, decode = TRUE) {
    len <- vapply(url, function(x) nchar(x, type = "bytes"), integer(1), USE.NAMES = FALSE)
    out <- Rcpp_ada_get_protocol(url, len)
    if (isTRUE(decode)) {
        return(url_decode2(out))
    }
    return(out)
}
