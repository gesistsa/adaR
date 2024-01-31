test_that("works with standard url", {
    res <- ada_url_parse("https://www.google.de/")
    expect_equal(res[["href"]], "https://www.google.de/")
    expect_equal(res[["host"]], "www.google.de")
})

test_that("works with complex url", {
    res <- ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
    expect_equal(res[["username"]], "user_1")
    expect_equal(res[["password"]], "password_1")
    expect_equal(res[["host"]], "example.org:8080")
    expect_equal(res[["hostname"]], "example.org")
    expect_equal(res[["port"]], "8080")
    expect_equal(res[["pathname"]], "/api")
    expect_equal(res[["search"]], "?q=1")
    expect_equal(res[["hash"]], "#frag")
})

test_that("works with utf8", {
    res <- ada_url_parse("https://www.hk01.com/zone/1/\u6e2f\u805e")
    expect_equal(res[["pathname"]], "/zone/1/\u6e2f\u805e")
    res <- ada_url_parse("http://www.m\u00fcller.de")
    expect_equal(res[["host"]], "www.m\u00fcller.de")
    res <- ada_url_parse("https://\u4e2d\u56fd\u79fb\u52a8.\u4e2d\u56fd")
    expect_equal(res$href[1], "https://xn--fiq02ib9d179b.xn--fiqs8s/")
    expect_equal(res$host[1], "\u4e2d\u56fd\u79fb\u52a8.\u4e2d\u56fd")
})

test_that("URLdecode optional #5", {
    expect_equal(ada_url_parse("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4")$search, "?q=\u30c9\u30a4\u30c4") ## default TRUE
    expect_equal(ada_url_parse("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4", decode = FALSE)$search, "?q=%E3%83%89%E3%82%A4%E3%83%84")
})

test_that("multiple urls", {
    urls <- rep("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag", 5)
    expect_equal(nrow(ada_url_parse(urls)), 5L)
})

test_that("corner cases", {
    expect_error(ada_url_parse())
    expect_error(ada_url_parse(NULL), NA)
    corners <- c(NA, NULL, "", "youcantparsethis", 1)
    testthat::expect_error(x <- ada_url_parse(corners), NA)
    testthat::expect_error(y <- ada_url_parse(corners, decode = FALSE), NA)
    expect_equal(x$host, c(NA_character_, NA_character_, NA_character_, NA_character_))
    expect_equal(y$host, c(NA_character_, NA_character_, NA_character_, NA_character_))
})

test_that("#66", {
    ## unicode see #67
    url <- "http://xn--53-6kcainf4buoffq.xn--p1ai/\u6e2f\u805e/junior-programmer.html"
    res <- adaR::ada_url_parse(url)
    expect_equal(res$href, url) ## doesn't mess up
    expect_equal(res$pathname, "/\u6e2f\u805e/junior-programmer.html")
    expect_false(res$host == "xn--53-6kcainf4buoffq.xn--p1ai") ## puny code is converted
})
