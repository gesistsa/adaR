psl <- readLines("https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat")
psl <- psl[1:which(psl == "// ===BEGIN PRIVATE DOMAINS===")]
psl <- psl[!grepl("^//", psl) & psl != ""]
wildcard <- psl[grepl("^\\*", psl)]
fixed <- psl[!grepl("^\\*", psl)]

psl <- list("fixed" = fixed, "wildcard" = wildcard)

usethis::use_data(psl, overwrite = TRUE, internal = TRUE)

# Benchmark
urls <- c(
    "https://subsub.sub.domain.co.uk",
    "https://domain.api.gov.uk",
    "https://domain.co.uk",
    "https://domain.com",
    "https://thisisnotpart.butthisispartoftheps.kawasaki.jp"
)

bench::mark(
    ada = public_suffix(urls),
    psl = psl::public_suffix(urls), iterations = 5000, check = FALSE
)
