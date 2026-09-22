#' Get a specific component of URL
#'
#' These functions get a specific component of URL.
#' @inheritParams ada_url_parse
#' @return character, `NA` if not a valid URL
#' @examples
#' url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
#' ada_get_href(url)
#' ada_get_username(url)
#' ada_get_password(url)
#' ada_get_port(url)
#' ada_get_hash(url)
#' ada_get_host(url)
#' ada_get_hostname(url)
#' ada_get_pathname(url)
#' ada_get_search(url)
#' ada_get_protocol(url)
#' ada_get_domain(url)
#' ada_get_basename(url)
#' ## these functions are vectorized
#' urls <- c("http://www.google.com", "http://www.google.com:80", "noturl")
#' ada_get_port(urls)
#' @export
ada_get_href <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_href, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_username <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_username, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_password <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_password, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_port <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_port, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_hash <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_hash, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_host <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_host, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_hostname <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_hostname, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_pathname <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_pathname, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_search <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_search, decode)
}

#' @rdname ada_get_href
#' @export
ada_get_protocol <- function(url, decode = TRUE) {
    .ada_call(url, Rcpp_ada_get_protocol, decode)
}

R_ada_get_domain <- function(url) {
    host <- .as_hostname(url)

    ps <- public_suffix(host)
    remainder <- .strip_suffix(host, ps)
    domain <- paste0(sub(".*\\.([^\\.]+)$", "\\1", remainder), ".", ps)

    is_suffix <- !is.na(host) & !is.na(ps) & host == ps
    domain[is_suffix & !ps %in% psl$wildcard] <- ""
    domain[is_suffix & ps %in% psl$wildcard] <- ps[is_suffix & ps %in% psl$wildcard]
    domain[is.na(ps) | is.na(host)] <- NA_character_
    domain
}

#' @rdname ada_get_href
#' @export
ada_get_domain <- function(url, decode = TRUE) {
    url <- .check_url(url)
    if (is.null(url)) {
        return(character(0))
    }
    res <- R_ada_get_domain(url)
    if (decode) {
        return(url_decode2(res))
    }
    res
}

#' @rdname ada_get_href
#' @export
ada_get_basename <- function(url, decode = TRUE) {
    protocol <- ada_get_protocol(url, decode = decode)
    hostname <- ada_get_hostname(url, decode = decode)
    # non-special schemes (mailto:, data:, ...) have no authority component
    sep <- ifelse(.has_authority(url), "//", "")
    basename <- paste0(protocol, sep, hostname)
    basename[is.na(protocol)] <- NA_character_
    basename
}

#' Does the URL have an authority (`//`) component?
#' @noRd
.has_authority <- function(url) {
    ada_has_hostname(url) & !ada_has_empty_hostname(url)
}
