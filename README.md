
<!-- README.md is generated from README.Rmd. Please edit that file -->

# adaR <img src="man/figures/logo.png" align="right" height="139" alt="" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/schochastics/adaR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/schochastics/adaR/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

adaR is a wrapper for [ada-url](https://github.com/ada-url/ada), a
[WHATWG](https://url.spec.whatwg.org/#url-parsing)-compliant and fast
URL parser written in modern C++ .

It implements several auxilliary functions to work with urls:

- public suffix extraction (top level domain excluding private domains)
  like [psl](https://github.com/hrbrmstr/psl)
- fast c++ implementation of `utils::URLdecode` (~40x speedup)

`adaR` is part of a series of R packages to analyse webtracking data:

- [webtrackR](https://github.com/schochastics/webtrackR): preprocess raw
  webtracking data
- [domainator](https://github.com/schochastics/domainator): classify
  domains
- [adaR](https://github.com/schochastics/adaR): parse urls

## Installation

You can install the development version of adaR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("schochastics/adaR")
```

## Example

This is a basic example which shows all the returned components of a URL

``` r
library(adaR)
ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#>                                                      href protocol username
#> 1 https://user_1:password_1@example.org:8080/api?q=1#frag   https:   user_1
#>     password             host    hostname port pathname search  hash
#> 1 password_1 example.org:8080 example.org 8080     /api   ?q=1 #frag
```

``` cpp
  /*
   * https://user:pass@example.com:1234/foo/bar?baz#quux
   *       |     |    |          | ^^^^|       |   |
   *       |     |    |          | |   |       |   `----- hash_start
   *       |     |    |          | |   |       `--------- search_start
   *       |     |    |          | |   `----------------- pathname_start
   *       |     |    |          | `--------------------- port
   *       |     |    |          `----------------------- host_end
   *       |     |    `---------------------------------- host_start
   *       |     `--------------------------------------- username_end
   *       `--------------------------------------------- protocol_end
   */
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

A “raw” url parse using ada is extremely fast (see
[ada-url.com](https://www.ada-url.com/)) but the implemented interface
is not yet optimized. The performance is still very compatible with
`urltools::url_parse` with the noted advantage in accuracy in some
practical circumstances.

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
#> 1 ada           456ms    456ms      2.19    2.67MB     19.7
#> 2 urltools      316ms    316ms      3.16    2.59MB     22.1
```

## Public Suffix extraction

`public_suffix()` extracts their top level domain from the [public
suffix list](https://publicsuffix.org/), **excluding** private domains.
This functionality already exists in the R package
[psl](https://github.com/hrbrmstr/psl).

psl relies on a C library and is very fast. However, the package is not
on CRAN and has the C library as system requirement. If these are no
issues for you and you need that speed, please use that package.

## Acknowledgement

The logo is created from [this
portrait](https://commons.wikimedia.org/wiki/File:Ada_Lovelace_portrait.jpg)
of [Ada Lovelace](https://de.wikipedia.org/wiki/Ada_Lovelace), a very
early pioneer in Computer Science.
