test_that("public_suffix works", {
  urls <- c(
    "https://subsub.sub.domain.co.uk",
    "https://domain.api.gov.uk",
    "https://thisisnotpart.butthisispartoftheps.kawasaki.jp"
  )
  ps <- public_suffix(urls)
  expect_equal(ps[1], "co.uk")
  expect_equal(ps[2], "gov.uk")
  expect_equal(ps[3], "butthisispartoftheps.kawasaki.jp")
})
