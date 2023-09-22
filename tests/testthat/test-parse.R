test_that("works with standard url", {
  res <- ada_url_parse("https://www.google.de")
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
  res <- ada_url_parse("https://www.hk01.com/zone/1/港聞")
  expect_equal(res[["pathname"]], "/zone/1/港聞")
  res <- ada_url_parse("http://www.müller.de")
  expect_equal(res[["host"]], "www.xn--mller-kva.de")
})
