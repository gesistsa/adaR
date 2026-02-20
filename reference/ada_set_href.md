# Set a specific component of URL

These functions set a specific component of URL.

## Usage

``` r
ada_set_href(url, input, decode = TRUE)

ada_set_username(url, input, decode = TRUE)

ada_set_password(url, input, decode = TRUE)

ada_set_port(url, input, decode = TRUE)

ada_set_host(url, input, decode = TRUE)

ada_set_hostname(url, input, decode = TRUE)

ada_set_pathname(url, input, decode = TRUE)

ada_set_protocol(url, input, decode = TRUE)

ada_set_search(url, input, decode = TRUE)

ada_set_hash(url, input, decode = TRUE)
```

## Arguments

- url:

  character. one or more URL to be parsed

- input:

  character. containing new component for URL. Vector of length 1 or
  same length as url.

- decode:

  logical. Whether to decode the output (see
  [`utils::URLdecode()`](https://rdrr.io/r/utils/URLencode.html)),
  default to `TRUE`

## Value

character, `NA` if not a valid URL

## Examples

``` r
url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
ada_set_href(url, "https://google.de")
#> [1] "https://google.de/"
ada_set_username(url, "user_2")
#> [1] "https://user_2:password_1@example.org:8080/api?q=1#frag"
ada_set_password(url, "hunter2")
#> [1] "https://user_1:hunter2@example.org:8080/api?q=1#frag"
ada_set_port(url, "1234")
#> [1] "https://user_1:password_1@example.org:1234/api?q=1#frag"
ada_set_hash(url, "#section1")
#> [1] "https://user_1:password_1@example.org:8080/api?q=1#section1"
ada_set_host(url, "example.de")
#> [1] "https://user_1:password_1@example.de:8080/api?q=1#frag"
ada_set_hostname(url, "example.de")
#> [1] "https://user_1:password_1@example.de:8080/api?q=1#frag"
ada_set_pathname(url, "path/")
#> [1] "https://user_1:password_1@example.org:8080/path/?q=1#frag"
ada_set_search(url, "q=2")
#> [1] "https://user_1:password_1@example.org:8080/api?q=2#frag"
ada_set_protocol(url, "ws:")
#> [1] "ws://user_1:password_1@example.org:8080/api?q=1#frag"
```
