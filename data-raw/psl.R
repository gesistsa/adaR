psl <- readLines("https://raw.githubusercontent.com/publicsuffix/list/master/public_suffix_list.dat")
psl <- psl[!grepl("^//", psl) & psl != ""]

usethis::use_data(psl, overwrite = TRUE, internal = TRUE)

# Benchmark
doms <- c("subsub.sub.domain.co.uk", "domain.api.gov.uk", "domain.co.uk", "domain.com", "www.domain.com")

bench::mark(
    ada = public_suffix(doms),
    psl = psl::public_suffix(doms), iterations = 5000, check = FALSE
)
