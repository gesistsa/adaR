#' Use ada-url to parse a url
#' @param url url
#' @export
ada_url_parse <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    Rcpp_ada_parse(url, nchar(url))
}
