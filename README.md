
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
#>                                                      href protocol username
#> 1 https://user_1:password_1@example.org:8080/api?q=1#frag   https:   user_1
#>     password             host    hostname port pathname search  hash
#> 1 password_1 example.org:8080 example.org 8080     /api   ?q=1 #frag
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
#> 1 https://www.google.com/maps/place/Pennsylvania+Station/@40.7519848,-74.0015045,14.7z/data=!4m   5!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519
#>   protocol username password           host       hostname port
#> 1   https:                   www.google.com www.google.com     
#>                                                                                                                                               pathname
#> 1 /maps/place/Pennsylvania+Station/@40.7519848,-74.0015045,14.7z/data=!4m   5!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519
#>   search hash
#> 1
```

<!-- 
and it is fast
-->
