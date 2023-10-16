.get <- function(url, decode, func) {
    if (is.null(url)) {
        return(character(0))
    }
    func(url, decode)
}

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
    .get(url, decode, Rcpp_ada_get_href)
}

#' @rdname ada_get_href
#' @export
ada_get_username <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_username)
}

#' @rdname ada_get_href
#' @export
ada_get_password <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_password)
}

#' @rdname ada_get_href
#' @export
ada_get_port <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_port)
}

#' @rdname ada_get_href
#' @export
ada_get_hash <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_hash)
}

#' @rdname ada_get_href
#' @export
ada_get_host <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_host)
}

#' @rdname ada_get_href
#' @export
ada_get_hostname <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_hostname)
}

#' @rdname ada_get_href
#' @export
ada_get_pathname <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_pathname)
}

#' @rdname ada_get_href
#' @export
ada_get_search <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_search)
}

#' @rdname ada_get_href
#' @export
ada_get_protocol <- function(url, decode = TRUE) {
    .get(url, decode, Rcpp_ada_get_protocol)
}

R_ada_get_domain <- function(url) {
    host <- ada_get_hostname(url)
    host <- sub("^www\\.", "", host)
    prot <- ada_get_protocol(url)
    url_new <- paste0(prot, host)

    ps <- public_suffix(url_new)
    pat <- paste0("\\.", ps, "$")

    dom <- mapply(function(x, y) sub(x, "", y), pat, host, USE.NAMES = FALSE)
    domain <- paste0(sub(".*\\.([^\\.]+)$", "\\1", dom), ".", ps)
    domain[host == ps & !ps %in% psl$wildcard] <- ""
    domain[host == ps & ps %in% psl$wildcard] <- ps
    domain[is.na(ps)] <- NA
    domain[is.na(host)] <- NA
    domain
}

#' @rdname ada_get_href
#' @export
ada_get_domain <- function(url, decode = TRUE) {
    if (is.null(url)) {
        return(character(0))
    }
    res <- R_ada_get_domain(url)
    if (decode) {
        return(url_decode2(res))
    }
    return(res)
}

#' @rdname ada_get_href
#' @export
ada_get_basename <- function(url) {
    protocol <- ada_get_protocol(url)
    not_na <- !is.na(protocol)
    tmp <- protocol[not_na]
    host <- ada_get_hostname(url[not_na])
    basename <- rep(NA_character_, length(url))
    basename[not_na] <- paste0(tmp, "//", host)
    basename
}
