# Rebuild the public suffix list shipped in R/sysdata.rda.
# Run with the package loaded (pkgload::load_all()), url_reverse() is needed.

lines <- readLines("https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat")
lines <- lines[1:which(lines == "// ===BEGIN PRIVATE DOMAINS===")]
lines <- lines[!grepl("^//", lines) & lines != ""]

# The list has three kinds of rule (https://publicsuffix.org/list/):
#   normal      example.com
#   wildcard    *.ck         -> any single label under .ck is a suffix
#   exception   !www.ck      -> beats a wildcard; the suffix is the rule
#                               minus its leftmost label
exception <- sub("^!", "", lines[grepl("^!", lines)])
wildcard <- sub("^\\*\\.", "", lines[grepl("^\\*", lines)])
fixed <- lines[!grepl("^[*!]", lines)]

# Exceptions are matched separately and must not enter the trie: their keys
# would carry a literal "!" and could never match any input.
raw_list <- c(fixed, wildcard)
rev_raw_list <- unname(url_reverse(paste0(".", raw_list)))

psl <- list(
    "raw_list" = raw_list,
    "wildcard" = wildcard,
    "exception" = exception,
    "rev_raw_list" = rev_raw_list
)

usethis::use_data(psl, overwrite = TRUE, internal = TRUE)
