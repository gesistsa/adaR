#' Use ada-url to parse a url
#' @param url character. one or more URL to be parsed
#' @param decode logical. Whether to decode the output (see [utils::URLdecode()]), default to `TRUE`
#' @return A list of components of the url
#' @examples
#' ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_url_parse <- function(url, decode = TRUE) {
    url <- utf8::as_utf8(url)
    # url_parsed <- Rcpp_ada_parse(url, nchar(url, type = "bytes"))
    url_parsed <- lapply(url, function(x) Rcpp_ada_parse(x, nchar(x, type = "bytes")))
    if (isTRUE(decode)) {
        url_parsed <- lapply(url_parsed, function(x) lapply(x, utils::URLdecode))
        return(do.call("rbind", lapply(url_parsed, data.frame)))
    }
    return(do.call("rbind", lapply(url_parsed, data.frame)))
}
