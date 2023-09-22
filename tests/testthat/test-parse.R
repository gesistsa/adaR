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
  res <- ada_url_parse("https://www.hk01.com/zone/1/\u6e2f\u805e")
  expect_equal(res[["pathname"]], "/zone/1/\u6e2f\u805e")
  res <- ada_url_parse("http://www.m\u00fcller.de")
  expect_equal(res[["host"]], "www.xn--mller-kva.de")
})

test_that("URLdecode optional #5", {
  expect_equal(ada_url_parse("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4")$search, "?q=\u30c9\u30a4\u30c4") ## default TRUE
  expect_equal(ada_url_parse("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4", decode = FALSE)$search, "?q=%E3%83%89%E3%82%A4%E3%83%84")
})

test_that("multiple urls", {
  urls <- rep("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag", 5)
  expect_equal(nrow(ada_url_parse(urls)), 5L)
})
