#' Extract the public suffix from a vector of domains
#'
#' @inheritParams ada_url_parse
#' @export
public_suffix <- function(url) {
    domains <- ada_get_hostname(url)
    dom_split <- strsplit(domains, ".", fixed = TRUE)
    tld_cand <- lapply(dom_split, .tld_build)
    vapply(tld_cand, .ftld_lookup, character(1))
}

.tld_build <- function(x) {
    n <- length(x)
    vapply(0:(n - 1), function(i) paste0(x[(n - i):n], collapse = "."), character(1))
}

.ftld_lookup <- function(x) {
    res <- fastmatch::fmatch(x, psl)
    res <- res[!is.na(res)]
    if (length(res) != 0) {
        return(psl[res[length(res)]])
    } else {
        return(NA_character_)
    }
}
