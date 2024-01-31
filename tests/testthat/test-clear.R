test_that("all set functions work", {
    url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
    expect_equal(ada_clear_port(url), "https://user_1:password_1@example.org/api?q=1#frag")
    expect_equal(ada_clear_hash(url), "https://user_1:password_1@example.org:8080/api?q=1")
    expect_equal(ada_clear_search(url), "https://user_1:password_1@example.org:8080/api#frag")
})

clear_functions <- c(
    ada_clear_port, ada_clear_search, ada_clear_hash
)

test_that("invalid urls should return NA", {
    url <- "thisisnoturl"
    for (func in clear_functions) {
        expect_equal(func(url), NA_character_)
    }
})

test_that("clear with puny code will still return puny, ref#66", {
    url <- "http://xn--53-6kcainf4buoffq.xn--p1ai/junior-programmer.html?ap=123"
    expect_equal(ada_clear_search(url), "http://xn--53-6kcainf4buoffq.xn--p1ai/junior-programmer.html")
})
