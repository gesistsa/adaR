adaR_env <- new.env(parent = emptyenv())

.onLoad <- function(...) {
    adaR_env$trie_ps <- triebeard::trie(psl$rev_raw_list, psl$raw_list)
    adaR_env$exception <- .psl_exceptions()
}

#' Exception rules of the public suffix list, without their leading `!`
#'
#' Read from `psl$exception` when present. Older `sysdata.rda` builds left the
#' exception rules inside `raw_list` with the `!` attached, so fall back to
#' recovering them from there.
#' @noRd
.psl_exceptions <- function() {
    if (!is.null(psl$exception)) {
        return(psl$exception)
    }
    sub("^!", "", grep("^!", psl$raw_list, value = TRUE))
}
