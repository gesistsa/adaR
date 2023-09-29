#' Extract the public suffix from a vector of domains or hostnames
#'
#' @param domains character. vector of domains or hostnames
#' @export
#' @return public suffixes of domains as character vector
#' @examples
#' public_suffix("http://example.com")
#'
#' # doesn't work for general URLs
#' public_suffix("http://example.com/path/to/file")
#'
#' # extracting hostname first does the trick
#' public_suffix(ada_get_hostname("http://example.com/path/to/file"))
public_suffix <- function(domains) {
    if (is.null(domains)) {
        return(character())
    }
    suffix_match <- triebeard::longest_match(adaR_env$trie_ps, url_reverse(domains))
    with_wildcard <- suffix_match %in% psl$wildcard
    if (any(with_wildcard)) {
        host <- ada_get_hostname(domains[with_wildcard])
        idx <- !(host == suffix_match[with_wildcard])
        pat <- paste0("\\.", suffix_match[with_wildcard][idx], "$")
        dom <- mapply(function(x, y) sub(x, "", y), pat, domains[with_wildcard][idx], USE.NAMES = FALSE)
        idy <- .has_dot(dom)
        suffix_match[with_wildcard][idx][idy] <- paste0(sub(".*\\.([^\\.]+)$", "\\1", dom[idy]), ".", suffix_match[with_wildcard][idx][idy])
        suffix_match[with_wildcard][idx][!idy] <- host[idx][!idy]
    }
    suffix_match
}

.has_dot <- function(x) {
    grepl("\\.", x)
}
