# Use ada-url to parse a url

Use ada-url to parse a url

## Usage

``` r
ada_url_parse(url, decode = TRUE)
```

## Arguments

- url:

  character. one or more URL to be parsed

- decode:

  logical. Whether to decode the output (see
  [`utils::URLdecode()`](https://rdrr.io/r/utils/URLencode.html)),
  default to `TRUE`

## Value

A data frame of the url components: href, protocol, username, password,
host, hostname, port, pathname, search, and hash

## Details

For details on the returned components refer to the introductory
vignette.

## Examples

``` r
ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#>                                                      href protocol username
#> 1 https://user_1:password_1@example.org:8080/api?q=1#frag   https:   user_1
#>     password             host    hostname port pathname search  hash
#> 1 password_1 example.org:8080 example.org 8080     /api   ?q=1 #frag
```
