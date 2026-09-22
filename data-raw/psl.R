# Rebuild the public suffix list shipped in R/sysdata.rda.
# Run with the package loaded (pkgload::load_all()), url_reverse() is needed.

lines <- readLines("https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat")
marker <- which(lines == "// ===BEGIN PRIVATE DOMAINS===")

# The list has three kinds of rule (https://publicsuffix.org/list/):
#   normal      example.com
#   wildcard    *.ck         -> any single label under .ck is a suffix
#   exception   !www.ck      -> beats a wildcard; the suffix is the rule
#                               minus its leftmost label
# and two sections: the ICANN domains, and the privately registered ones
# (github.io, blogspot.com, s3.amazonaws.com, ...).
section <- function(x) {
    x <- x[!grepl("^//", x) & x != ""]
    wildcard <- sub("^\\*\\.", "", x[grepl("^[*]", x)])
    # Exceptions are matched separately and must not enter the trie: their
    # keys would carry a literal "!" and could never match any input.
    exception <- sub("^!", "", x[grepl("^!", x)])
    raw_list <- c(x[!grepl("^[*!]", x)], wildcard)
    list(
        raw_list = raw_list,
        wildcard = wildcard,
        exception = exception,
        rev_raw_list = unname(url_reverse(paste0(".", raw_list)))
    )
}

psl <- list(
    icann = section(lines[1:marker]),
    private = section(lines[(marker + 1):length(lines)])
)

str(lapply(psl, lengths))

usethis::use_data(psl, overwrite = TRUE, internal = TRUE)
