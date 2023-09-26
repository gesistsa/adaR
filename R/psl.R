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
        pat <- paste0("\\.", suffix_match[with_wildcard], "$")
        dom <- mapply(function(x, y) sub(x, "", y), pat, url[with_wildcard], USE.NAMES = FALSE)
        suffix_match[with_wildcard] <- paste0(sub(".*\\.([^\\.]+)$", "\\1", dom), ".", suffix_match[with_wildcard])
    }
    suffix_match
}
