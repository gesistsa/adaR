#' Use ada-url to parse a url
#' @param url character. URL to be parsed
#' @param decode logical. Whether to decode the output (see [utils::URLdecode()]), default to `TRUE`
#' @return A list of components of the url
#' @examples
#' ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_url_parse <- function(url, decode = TRUE) {
    url <- stringi::stri_enc_toutf8(url)
    url_parsed <- Rcpp_ada_parse(url, nchar(url, type = "bytes"))
    if (isTRUE(decode)) {
      return(lapply(url_parsed, utils::URLdecode))
    }
    return(url_parsed)
}
