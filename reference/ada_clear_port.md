# Clear a specific component of URL

These functions clears a specific component of URL.

## Usage

``` r
ada_clear_port(url, decode = TRUE)

ada_clear_hash(url, decode = TRUE)

ada_clear_search(url, decode = TRUE)
```

## Arguments

- url:

  character. one or more URL to be parsed

- decode:

  logical. Whether to decode the output (see
  [`utils::URLdecode()`](https://rdrr.io/r/utils/URLencode.html)),
  default to `TRUE`

## Value

character, `NA` if not a valid URL

## Examples

``` r
url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
ada_clear_port(url)
#> [1] "https://user_1:password_1@example.org/api?q=1#frag"
ada_clear_hash(url)
#> [1] "https://user_1:password_1@example.org:8080/api?q=1"
ada_clear_search(url)
#> [1] "https://user_1:password_1@example.org:8080/api#frag"
```
