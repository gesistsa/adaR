test_that("non-character input is rejected with a clear message", {
    expect_error(ada_get_host(123), "`url` must be a character vector, not numeric")
    expect_error(ada_get_host(list("http://a.com")), "`url` must be a character vector, not list")
    expect_error(ada_has_port(TRUE), "`url` must be a character vector, not logical")
    expect_error(ada_url_parse(1:3), "`url` must be a character vector, not integer")
    expect_error(ada_clear_port(123), "`url` must be a character vector")
    expect_error(ada_set_port("http://a.com", 80), "`input` must be a character vector, not numeric")
})

test_that("factors and bare NA are still accepted", {
    expect_equal(ada_get_hostname(factor("http://a.com")), "a.com")
    expect_equal(ada_get_hostname(NA), NA_character_)
    expect_equal(ada_has_port(NA), NA)
})

test_that("NULL gives a zero-length result of the right type", {
    expect_identical(ada_get_host(NULL), character(0))
    expect_identical(ada_has_port(NULL), logical(0))
    expect_identical(ada_clear_port(NULL), character(0))
    expect_identical(ada_set_port(NULL, "80"), character(0))
    expect_identical(ada_get_domain(NULL), character(0))
    expect_identical(ada_get_basename(NULL), character(0))
    expect_identical(url_decode2(NULL), character(0))
    expect_identical(public_suffix(NULL), character(0))
    expect_identical(nrow(ada_url_parse(NULL)), 0L)
})

test_that("set recycles length-one input and rejects other lengths", {
    urls <- c("http://a.com", "http://b.com")
    # 80 would be dropped as http's default port, so use non-default ones
    expect_equal(ada_get_port(ada_set_port(urls, "8080")), c("8080", "8080"))
    expect_equal(ada_get_port(ada_set_port(urls, c("8080", "8081"))), c("8080", "8081"))
    expect_error(
        ada_set_port(urls, c("8080", "8081", "8082")),
        "input must have length one or the same length as url"
    )
})
