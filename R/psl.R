#' Extract the public suffix from a vector of domains
#'
#' @param domains character. vector of domains
#' @export
public_suffix <- function(domains) {
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
    psl[res[length(res)]]
}
