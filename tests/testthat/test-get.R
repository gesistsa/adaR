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
