test_that("Integration #21", {
    res <- adaR::ada_url_parse(c("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4", NA, "https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4"))
    expect_equal(res$search, c("?q=\u30c9\u30a4\u30c4", NA_character_, "?q=\u30c9\u30a4\u30c4"))
})

test_that("cpp implementation is correct", {
    enc <- "https%3A%2F%2Fwww.google.de%2Fmaps%2F%4047.6647302%2C9.1389738%2C11z%3Fentry%3Dttu"
    dec <- "https://www.google.de/maps/@47.6647302,9.1389738,11z?entry=ttu"
    expect_equal(url_decode2(enc), dec)
})

test_that("corners", {
    expect_error(url_decode2(NULL), NA)
    expect_error(url_decode2(NA), NA)
    expect_error(url_decode2(c("?q=%E3%83%89%E3%82%A4%E3%83%84", NA))[2], NA)
})

test_that("a '%' that is not a valid escape is passed through", {
    # sscanf used to leave `value` uninitialised here and skip 3 characters,
    # dropping the rest of the string
    expect_equal(url_decode2("abc%"), "abc%")
    expect_equal(url_decode2("a%zz b"), "a%zz b")
    expect_equal(url_decode2("a%f"), "a%f")
    expect_equal(url_decode2("100%25 %2F a%GG b%"), "100% / a%GG b%")
    expect_equal(url_decode2("%"), "%")
    expect_equal(url_decode2("%%20"), "% ")
})

test_that("decoding is case insensitive and round-trips literal percent", {
    expect_equal(url_decode2(c("%2f", "%2F")), c("/", "/"))
    expect_equal(url_decode2("50%-75% off"), "50%-75% off")
})

test_that("url_decode2 rejects non-character input", {
    expect_error(url_decode2(123), "must be a character vector")
    expect_error(url_decode2(list("a")), "must be a character vector")
})
