# Get a specific component of URL

These functions get a specific component of URL.

## Usage

``` r
ada_get_href(url, decode = TRUE)

ada_get_username(url, decode = TRUE)

ada_get_password(url, decode = TRUE)

ada_get_port(url, decode = TRUE)

ada_get_hash(url, decode = TRUE)

ada_get_host(url, decode = TRUE)

ada_get_hostname(url, decode = TRUE)

ada_get_pathname(url, decode = TRUE)

ada_get_search(url, decode = TRUE)

ada_get_protocol(url, decode = TRUE)

ada_get_domain(url, decode = TRUE)

ada_get_basename(url)
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
ada_get_href(url)
#> [1] "https://user_1:password_1@example.org:8080/api?q=1#frag"
ada_get_username(url)
#> [1] "user_1"
ada_get_password(url)
#> [1] "password_1"
ada_get_port(url)
#> [1] "8080"
ada_get_hash(url)
#> [1] "#frag"
ada_get_host(url)
#> [1] "example.org:8080"
ada_get_hostname(url)
#> [1] "example.org"
ada_get_pathname(url)
#> [1] "/api"
ada_get_search(url)
#> [1] "?q=1"
ada_get_protocol(url)
#> [1] "https:"
ada_get_domain(url)
#> [1] "example.org"
ada_get_basename(url)
#> [1] "https://example.org"
## these functions are vectorized
urls <- c("http://www.google.com", "http://www.google.com:80", "noturl")
ada_get_port(urls)
#> [1] "" "" NA
```
