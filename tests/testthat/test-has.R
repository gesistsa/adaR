test_that("all has functions work", {
  url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
  expect_true(ada_has_credentials(url))
  expect_false(ada_has_empty_hostname(url))
  expect_true(ada_has_hostname(url))
  expect_true(ada_has_non_empty_password(url))
  expect_true(ada_has_non_empty_username(url))
  expect_true(ada_has_port(url))
  expect_true(ada_has_hash(url))
  expect_true(ada_has_search(url))
})

has_functions <- c(ada_has_credentials, ada_has_empty_hostname, ada_has_hostname, ada_has_non_empty_username, ada_has_non_empty_password, ada_has_port, ada_has_hash, ada_has_search)

test_that("invalid urls should return NA, #26", {
  url <- "thisisnoturl"
  for (func in has_functions) {
    expect_error(func(url), NA)
  }
})

test_that("corners #31", {
    for (func in has_functions) {
        expect_error(func(c(NA, NA_character_, "")), NA)
    }
    for (func in has_functions) {
        expect_error(func(NULL), NA)
    }
})

test_that("ada_has_credentials is vectorized ref #3", {
  expect_error(res <- ada_has_credentials(c("https://admin:admin@the-internet.herokuapp.com/basic_auth", "https://www.google.com")), NA)
})
