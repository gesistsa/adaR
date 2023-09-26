#' Extract the public suffix from a vector of domains
#'
#' @inheritParams ada_url_parse
#' @export
public_suffix <- function(url) {
    if (is.null(url)) {
        return(character())
    }
    suffix_match <- triebeard::longest_match(adaR_env$trie_ps, url_reverse(url))
    with_wildcard <- suffix_match %in% psl$wildcard
    if (any(with_wildcard)) {
        host <- ada_get_hostname(url[with_wildcard])
        idx <- !(host == suffix_match[with_wildcard])
        pat <- paste0("\\.", suffix_match[with_wildcard][idx], "$")
        dom <- mapply(function(x, y) sub(x, "", y), pat, url[with_wildcard][idx], USE.NAMES = FALSE)
        idy <- .has_dot(dom)
        suffix_match[with_wildcard][idx][idy] <- paste0(sub(".*\\.([^\\.]+)$", "\\1", dom[idy]), ".", suffix_match[with_wildcard][idx][idy])
        suffix_match[with_wildcard][idx][!idy] <- host[with_wildcard][idx][!idy]
    }
    suffix_match
}

.has_dot <- function(x) {
    grepl("\\.", x)
}
