
<!-- README.md is generated from README.Rmd. Please edit that file -->

# adaR

adaR is a wrapper for [ada-url](https://github.com/ada-url/ada), a
WHATWG-compliant and fast URL parser written in modern C++ .

## Installation

You can install the development version of adaR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("schochastics/adaR")
```

## Example

This is a basic example whic hshows all the returned component.

``` r
library(adaR)
ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#> $href
#> [1] "https://user_1:password_1@example.org:8080/api?q=1#frag"
#> 
#> $protocol
#> [1] "https:"
#> 
#> $username
#> [1] "user_1"
#> 
#> $password
#> [1] "password_1"
#> 
#> $host
#> [1] "example.org:8080"
#> 
#> $hostname
#> [1] "example.org"
#> 
#> $port
#> [1] "8080"
#> 
#> $pathname
#> [1] "/api"
#> 
#> $search
#> [1] "?q=1"
#> 
#> $hash
#> [1] "#frag"
```

It solves some problems of urltools with certain urls.

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
#> $href
#> [1] "https://www.google.com/maps/place/Pennsylvania+Station/@40.7519848,-74.0015045,14.7z/data=!4m%20%20%205!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519"
#> 
#> $protocol
#> [1] "https:"
#> 
#> $username
#> [1] ""
#> 
#> $password
#> [1] ""
#> 
#> $host
#> [1] "www.google.com"
#> 
#> $hostname
#> [1] "www.google.com"
#> 
#> $port
#> [1] ""
#> 
#> $pathname
#> [1] "/maps/place/Pennsylvania+Station/@40.7519848,-74.0015045,14.7z/data=!4m%20%20%205!3m4!1s0x89c259ae15b2adcb:0x7955420634fd7eba!8m2!3d40.750568!4d-73.993519"
#> 
#> $search
#> [1] ""
#> 
#> $hash
#> [1] ""
```

and it is fast!

``` r
bench::mark(
  ada = replicate(1000, ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")),
  urltools = replicate(1000, urltools::url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")),
  iterations = 1, check = FALSE
)
#> Warning: Some expressions had a GC in every iteration; so filtering is
#> disabled.
#> # A tibble: 2 × 6
#>   expression      min   median `itr/sec` mem_alloc `gc/sec`
#>   <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
#> 1 ada          5.04ms   5.04ms    199.      2.67MB      0  
#> 2 urltools   148.13ms 148.13ms      6.75    2.59MB     40.5
```
