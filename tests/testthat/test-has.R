test_that("all has functions work", {
  url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
  expect_true(ada_has_credentials(url))
  expect_false(ada_has_empty_hostname(url))
  expect_true(ada_has_hash(url))
  expect_true(ada_has_hostname(url))
  expect_true(ada_has_non_empty_password(url))
  expect_true(ada_has_non_empty_username(url))
  expect_true(ada_has_port(url))
  expect_true(ada_has_search(url))
})
