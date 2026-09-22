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

percent decoded URLs as character vector

## Details

A `%` that is not followed by two hexadecimal digits is not a valid
escape sequence and is returned unchanged.

## Examples

``` r
url_decode2("Hello%20World")
#> [1] "Hello World"
```
