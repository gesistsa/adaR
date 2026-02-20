# Check if URL has a certain component

These functions check if URL has a certain component.

## Usage

``` r
ada_has_credentials(url)

ada_has_empty_hostname(url)

ada_has_hostname(url)

ada_has_non_empty_username(url)

ada_has_non_empty_password(url)

ada_has_port(url)

ada_has_hash(url)

ada_has_search(url)
```

## Arguments

- url:

  character. one or more URL to be parsed

## Value

logical, `NA` if not a valid URL.

## Examples

``` r
url <- c("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
ada_has_credentials(url)
#> [1] TRUE
ada_has_empty_hostname(url)
#> [1] FALSE
ada_has_hostname(url)
#> [1] TRUE
ada_has_non_empty_username(url)
#> [1] TRUE
ada_has_non_empty_password(url)
#> [1] TRUE
ada_has_port(url)
#> [1] TRUE
ada_has_hash(url)
#> [1] TRUE
ada_has_search(url)
#> [1] TRUE
## these functions are vectorized
urls <- c("http://www.google.com", "http://www.google.com:80", "noturl")
ada_has_port(urls)
#> [1] FALSE FALSE    NA
```
