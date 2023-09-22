
<!-- README.md is generated from README.Rmd. Please edit that file -->

# adaR

<!-- badges: start -->

[![R-CMD-check](https://github.com/schochastics/adaR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/schochastics/adaR/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/schochastics/adaR/branch/main/graph/badge.svg)](https://app.codecov.io/gh/schochastics/adaR?branch=main)
<!-- badges: end -->

adaR is a wrapper for [ada-url](https://github.com/ada-url/ada), a
[WHATWG](https://url.spec.whatwg.org/#url-parsing)-compliant and fast
URL parser written in modern C++ .

## Installation

You can install the development version of adaR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("schochastics/adaR")
```

## Example

This is a basic example which shows all the returned components

``` r
library(adaR)
ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#>                                                      href 
#> "https://user_1:password_1@example.org:8080/api?q=1#frag" 
#>                                                  protocol 
#>                                                  "https:" 
#>                                                  username 
#>                                                  "user_1" 
#>                                                  password 
#>                                              "password_1" 
#>                                                      host 
#>                                        "example.org:8080" 
#>                                                  hostname 
#>                                             "example.org" 
#>                                                      port 
#>                                                    "8080" 
#>                                                  pathname 
#>                                                    "/api" 
#>                                                    search 
#>                                                    "?q=1" 
#>                                                      hash 
#>                                                   "#frag"
```

It solves some problems of urltools with more complex urls.

``` r
urltools::url_parse("https://www.google.com/maps/place/Pennsylvania+Station/@40.7519848,-74.0015045,14.
   7z/data=!4m5!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519")
#>   scheme                            domain port
#> 1  https 40.7519848,-74.0015045,14.\n   7z <NA>
#>                                                                                 path
#> 1 data=!4m5!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519
#>   parameter fragment
#> 1      <NA>     <NA>

ada_url_parse("https://www.google.com/maps/place/Pennsylvania+Station/@40.7519848,-74.0015045,14.7z/data=!4m
   5!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519")
#>                                                                                                                                                                         href 
#> "https://www.google.com/maps/place/Pennsylvania+Station/@40.7519848,-74.0015045,14.7z/data=!4m   5!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519" 
#>                                                                                                                                                                     protocol 
#>                                                                                                                                                                     "https:" 
#>                                                                                                                                                                     username 
#>                                                                                                                                                                           "" 
#>                                                                                                                                                                     password 
#>                                                                                                                                                                           "" 
#>                                                                                                                                                                         host 
#>                                                                                                                                                             "www.google.com" 
#>                                                                                                                                                                     hostname 
#>                                                                                                                                                             "www.google.com" 
#>                                                                                                                                                                         port 
#>                                                                                                                                                                           "" 
#>                                                                                                                                                                     pathname 
#>                       "/maps/place/Pennsylvania+Station/@40.7519848,-74.0015045,14.7z/data=!4m   5!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519" 
#>                                                                                                                                                                       search 
#>                                                                                                                                                                           "" 
#>                                                                                                                                                                         hash 
#>                                                                                                                                                                           ""
```

and it is fast

``` r
bench::mark(
  ada = replicate(1000, ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag", decode = FALSE)),
  urltools = replicate(1000, urltools::url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")),
  iterations = 1, check = FALSE
)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 ada          23.2ms   23.2ms     43.2     2.67MB     43.2
#> 2 urltools    177.5ms  177.5ms      5.64    2.59MB     33.8
```
