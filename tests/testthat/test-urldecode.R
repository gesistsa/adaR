test_that(".URLdecode #21", {
    expect_equal(.URLdecode("?q=%E3%83%89%E3%82%A4%E3%83%84"), "?q=\u30c9\u30a4\u30c4")
    expect_equal(.URLdecode(c("?q=%E3%83%89%E3%82%A4%E3%83%84", NA)), c("?q=\u30c9\u30a4\u30c4", NA_character_))
    ## corners
    expect_equal(.URLdecode(""), "")
    expect_equal(.URLdecode(NA_character_), NA_character_)
    expect_equal(.URLdecode(NA), NA_character_)
    expect_equal(.URLdecode(NULL), character(0))
})

test_that("Integration #21", {
    res <- adaR::ada_url_parse(c("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4", NA, "https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4"))
    expect_equal(res$search, c("?q=\u30c9\u30a4\u30c4", NA_character_, "?q=\u30c9\u30a4\u30c4"))
})
