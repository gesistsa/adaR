test_that("all get functions work", {
    url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
    expect_equal(ada_get_username(url), "user_1")
    expect_equal(ada_get_password(url), "password_1")
    expect_equal(ada_get_host(url), "example.org:8080")
    expect_equal(ada_get_hostname(url), "example.org")
    expect_equal(ada_get_port(url), "8080")
    expect_equal(ada_get_pathname(url), "/api")
    expect_equal(ada_get_search(url), "?q=1")
    expect_equal(ada_get_hash(url), "#frag")
})

get_functions <- c(ada_get_username, ada_get_password, ada_get_host, ada_get_hostname, ada_get_port, ada_get_pathname,
                   ada_get_search, ada_get_hash)

test_that("invalid urls should return NA, #26", {
    url <- "thisisnoturl"
    for (func in get_functions) {
        expect_error(func(url), NA)
    }
})

test_that("corners #31", {
    for (func in get_functions) {
        expect_error(func(c(NA, NA_character_, "")), NA)
    }
    for (func in get_functions) {
        expect_error(func(NULL), NA)
    }
})

test_that("decode can pass", {
    expect_equal(ada_get_search("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4"), "?q=\u30c9\u30a4\u30c4")
    expect_equal(ada_get_search("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4", decode = FALSE), "?q=%E3%83%89%E3%82%A4%E3%83%84")
})
