psl <- readLines("https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat")
psl <- psl[1:which(psl == "// ===BEGIN PRIVATE DOMAINS===")]
psl <- psl[!grepl("^//", psl) & psl != ""]

wildcard <- psl[grepl("^\\*", psl)]
wildcard <- stringr::str_remove(wildcard, "\\*\\.")

fixed <- psl[!grepl("^\\*", psl)]
raw_list <- c(fixed, wildcard)
rev_raw_list <- sapply(paste0(".", raw_list), url_reverse)
psl <- list("raw_list" = raw_list, "wildcard" = wildcard, "rev_raw_list" = rev_raw_list)

usethis::use_data(psl, overwrite = TRUE, internal = TRUE)
