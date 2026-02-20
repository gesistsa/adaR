# Function to percent-decode characters in URLs

Similar to [utils::URLdecode](https://rdrr.io/r/utils/URLencode.html)

## Usage

``` r
url_decode2(url)
```

## Arguments

- url:

  a character vector

## Value

precent decoded URLs as character vector

## Examples

``` r
url_decode2("Hello%20World")
#> [1] "Hello World"
```
