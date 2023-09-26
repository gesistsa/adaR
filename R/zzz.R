adaR_env <- new.env(parent = emptyenv())

triebeardify <- function() {
    triebeard::trie(psl$rev_raw_list, psl$raw_list)
}

.onLoad <- function(...) {
    ps_trie <- triebeardify()
    assign("trie_ps", ps_trie, envir = adaR_env)
}
