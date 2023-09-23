test_that("public_suffix works", {
  urls <- c(
    "https://subsub.sub.domain.co.uk",
    "https://domain.api.gov.uk",
    "https://thisisnotpart.butthisispartoftheps.kawasaki.jp",
    "https://a.what.nodebalancer.linode.com"
  )
  ps <- public_suffix(urls)
  expect_equal(ps[1], "co.uk")
  expect_equal(ps[2], "co.uk")
  expect_equal(ps[3], "butthisispartoftheps.kawasaki.jp")
  expect_equal(ps[4], "what.nodebalancer.linode.com")
})
