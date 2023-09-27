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
