#' Use ada-url to parse a url
#' @param url character. one or more URL to be parsed
#' @param decode logical. Whether to decode the output (see [utils::URLdecode()]), default to `TRUE`
#' @details For details on the returned components refer to the introductory vignette.
#' @return A data frame of the url components:
#' href, protocol, username, password, host, hostname, port, pathname, search, and hash
#' @examples
#' ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_url_parse <- function(url, decode = TRUE) {
    if (is.null(url)) {
        return(structure(list(
            href = character(0), protocol = character(0),
            username = character(0), password = character(0), host = character(0),
            hostname = character(0), port = character(0), pathname = character(0),
            search = character(0), hash = character(0)
        ), row.names = integer(0), class = "data.frame"))
    }
    Rcpp_ada_parse(url, decode)
}

#' Function to percent-decode characters in URLs
#'
#' Similar to [utils::URLdecode]
#'
#' @param url a character vector
#' @return precent decoded URLs as character vector
#' @export
#' @examples
#' url_decode2("Hello%20World")
#' @export
url_decode2 <- function(url) {
    if (is.null(url)) {
        return(character(0))
    }
    Rcpp_url_decode2(url)
}
