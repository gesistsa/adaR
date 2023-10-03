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
