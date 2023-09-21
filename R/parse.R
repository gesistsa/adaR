#' Use ada-url to parse a url
#' @param url url
#' @return A list of components
#' @examples
#' ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_url_parse <- function(url) {
    url <- stringi::stri_enc_toutf8(url)
    Rcpp_ada_parse(url, nchar(url))
}
