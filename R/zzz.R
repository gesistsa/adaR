adaR_env <- new.env(parent = emptyenv())

.onLoad <- function(...) {
    adaR_env$trie_ps <- triebeard::trie(psl$rev_raw_list, psl$raw_list)
}
