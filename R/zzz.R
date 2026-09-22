adaR_env <- new.env(parent = emptyenv())

.onLoad <- function(...) {
    adaR_env$rules_icann <- .make_rules(psl$icann)
    adaR_env$rules_all <- .make_rules(.merge_sections(psl$icann, psl$private))
}

#' Turn one section of the public suffix list into a lookup-ready rule set
#' @noRd
.make_rules <- function(x) {
    list(
        trie = triebeard::trie(x$rev_raw_list, x$raw_list),
        wildcard = x$wildcard,
        exception = x$exception
    )
}

#' Concatenate the ICANN and private sections
#'
#' The two sections do not overlap, so the rules can simply be appended.
#' @noRd
.merge_sections <- function(a, b) {
    Map(c, a, b)
}

#' Pick the rule set for a given `icann_only`
#' @noRd
.psl_rules <- function(icann_only) {
    if (isTRUE(icann_only)) adaR_env$rules_icann else adaR_env$rules_all
}
