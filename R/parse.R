#' Use ada-url to parse a url
#' @param url character. one or more URL to be parsed
#' @param decode logical. Whether to decode the output (see [utils::URLdecode()]), default to `TRUE`
#' @return A list of components of the url
#' @examples
#' ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#' @export
ada_url_parse <- function(url, decode = TRUE) {
    url <- utf8::as_utf8(url)
    url_parsed <- Rcpp_ada_parse(url)
    if (isTRUE(decode)) {
        return(.decoder(url_parsed))
    }
    return(url_parsed)
}

.decoder <- function(df) {
    for (i in seq_len(ncol(df))) {
        df[[i]] <- .URLdecode(df[[i]])
    }
    df
}

## NA/NULL-aware utils::URLdecode, hopefully without great performance impact
.URLdecode <- function(URL) {
    if (is.null(URL)) {
        return(character(0))
    }
    non_na_index <- which(!is.na(URL))
    URL[non_na_index] <- url_decode(URL[non_na_index])
    URL[!non_na_index] <- NA_character_
    return(URL)
}
