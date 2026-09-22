test_that("public_suffix works on some examples", {
    urls <- c(
        "https://subsub.sub.domain.co.uk",
        "https://domain.api.gov.uk",
        "https://thisisnotpart.butthisispartoftheps.kawasaki.jp"
    )
    ps <- public_suffix(urls)
    expect_equal(ps[1], "co.uk")
    expect_equal(ps[2], "gov.uk")
    expect_equal(ps[3], "butthisispartoftheps.kawasaki.jp")
})

test_that("public suffix works on complete list", {
    urls <- paste0("https://dontmatchme.", setdiff(psl$raw_list, psl$wildcard))
    psla <- public_suffix(urls)
    expect_true(all(psla == setdiff(psl$raw_list, psl$wildcard)))
})

test_that("corners", {
    expect_equal(public_suffix(NA), NA_character_)
    expect_equal(public_suffix(NULL), character(0))
    expect_equal(public_suffix(""), NA_character_)
})

test_that("wildcard only #44", {
    # expect_equal(public_suffix("http://kobe.jp"), "kobe.jp")
    expect_equal(public_suffix("http://c.mm"), "c.mm")
    urls <- c(
        "http://kobe.jp",
        "http://c.mm",
        "http://google.de",
        "https://thisisnotpart.butthisispartoftheps.kawasaki.jp"
    )
    ps <- public_suffix(urls)
    # expect_equal(ps[1], "kobe.jp")
    expect_equal(ps[2], "c.mm")
    expect_equal(ps[3], "de")
    expect_equal(ps[4], "butthisispartoftheps.kawasaki.jp")
})

test_that("several wildcard matches in one call, #issue from review", {
    # used to fail with "NAs are not allowed in subscripted assignments"
    expect_equal(public_suffix(c("a.b.ck", "c.d.ck")), c("b.ck", "d.ck"))
    expect_equal(
        public_suffix(c("a.b.ck", "example.com", "c.d.ck")),
        c("b.ck", "com", "d.ck")
    )
})

test_that("hostnames and full URLs give the same suffix", {
    urls <- c(
        "http://a.b.ck", "https://subsub.sub.domain.co.uk",
        "http://c.mm", "https://example.com"
    )
    expect_equal(public_suffix(urls), public_suffix(ada_get_hostname(urls)))
})

test_that("URLs with a path work directly", {
    expect_equal(public_suffix("http://example.com/path/to/file"), "com")
    expect_equal(
        public_suffix("https://sub.domain.co.uk/a/b?q=1#f"), "co.uk"
    )
})

test_that("public_suffix rejects non-character input", {
    expect_error(public_suffix(123), "must be a character vector")
})

test_that("bare hostnames are accepted and normalised", {
    expect_equal(public_suffix("github.com"), "com")
    expect_equal(public_suffix("GitHub.COM"), "com")
    expect_equal(public_suffix("sub.Example.CO.UK"), "co.uk")
    expect_equal(public_suffix("xn--bcher-kva.de"), "de")
})

test_that("input that is neither a URL nor a bare hostname stays NA", {
    # these must not be matched against the suffix trie verbatim, or a string
    # merely ending in something suffix-like gets a bogus answer
    junk <- c(
        "evil.com/path.de", "foo/bar.com", "/path/to.de", "?q=x.com",
        "not a url.de", "a b.com", "example.com:8080", "user@example.com"
    )
    expect_equal(public_suffix(junk), rep(NA_character_, length(junk)))
    expect_equal(ada_get_domain(junk), rep(NA_character_, length(junk)))
})

test_that("URLs, hostnames and junk mix correctly in one call", {
    x <- c("https://a.co.uk/p", "github.com", "evil.com/path.de", NA, "", "c.d.ck")
    expect_equal(public_suffix(x), c("co.uk", "com", NA, NA, NA, "d.ck"))
    expect_equal(ada_get_domain(x), c("a.co.uk", "github.com", NA, NA, NA, "c.d.ck"))
})
