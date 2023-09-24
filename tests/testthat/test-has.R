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

test_that("invalid urls", {
  url <- "thisisnoturl"
  for (func in c(ada_has_credentials, ada_has_empty_hostname, ada_has_non_empty_password, ada_has_non_empty_username, ada_has_port, ada_has_hash, ada_has_search)) {
    expect_error(func(url))    
  }
})

has_functions <- c(ada_has_credentials, ada_has_empty_hostname, ada_has_non_empty_password, ada_has_non_empty_username, ada_has_port, ada_has_hash, ada_has_search)

test_that("corners", {
  corners <- c(NA, NA_character_, "")
  for (url in corners) {
    for (func in has_functions) {
      expect_error(func(url))    
    }
  }
  for (func in has_functions) {
    expect_error(func(NULL), NA)
  }
})
