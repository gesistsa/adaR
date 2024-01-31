test_that("all set functions work", {
    url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
    expect_equal(ada_get_href(ada_set_href(url, "https://example.org:8000/api?q=2#das")), "https://example.org:8000/api?q=2#das")
    expect_equal(ada_get_username(ada_set_username(url, "user_2")), "user_2")
    expect_equal(ada_get_password(ada_set_password(url, "hunter2")), "hunter2")
    expect_equal(ada_get_host(ada_set_host(url, "example.de:1234")), "example.de:1234")
    expect_equal(ada_get_hostname(ada_set_hostname(url, "example.net/")), "example.net")
    expect_equal(ada_get_port(ada_set_port(url, "1234")), "1234")
    expect_equal(ada_get_pathname(ada_set_pathname(url, "/dat")), "/dat")
    expect_equal(ada_get_search(ada_set_search(url, "q=2")), "?q=2")
    expect_equal(ada_get_hash(ada_set_hash(url, "section1")), "#section1")
    expect_equal(ada_get_protocol(ada_set_protocol(url, "ws:")), "ws:")
})

set_functions <- c(
    ada_set_href, ada_set_username, ada_set_password, ada_set_host, ada_set_hostname, ada_set_port, ada_set_pathname,
    ada_set_search, ada_set_hash, ada_set_protocol
)

test_that("invalid urls should return NA", {
    url <- "thisisnoturl"
    for (func in set_functions) {
        expect_equal(func(url, "invalid"), NA_character_)
    }
})

test_that("invalid component handling", {
    url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
    expect_equal(ada_get_port(ada_set_port(url, "blabla")), "8080")
    expect_equal(ada_get_protocol(ada_set_protocol(url, "abc:")), "https:")
})

test_that("uneven vectors", {
    expect_error(ada_set_protocol(rep("https://google.de", 3), rep("ws:", 2)))
})

test_that("NULL input", {
    expect_equal(ada_set_protocol("https://google.de", NULL), "https://google.de")
})

test_that("setting with puny code will still return puny, ref#66", {
    url <- "http://xn--53-6kcainf4buoffq.xn--p1ai/junior-programmer.html"
    expect_equal(ada_set_protocol(url, "ws:"), "ws://xn--53-6kcainf4buoffq.xn--p1ai/junior-programmer.html")
    expect_equal(ada_set_href(url, "http://xn--53-6kcainf4buoffq.xn--p1ai/junior-programmer.html"), "http://xn--53-6kcainf4buoffq.xn--p1ai/junior-programmer.html")
})
