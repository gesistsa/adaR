# Extract the public suffix from a vector of domains or hostnames

Extract the public suffix from a vector of domains or hostnames

## Usage

``` r
public_suffix(domains)
```

## Arguments

- domains:

  character. vector of domains or hostnames

## Value

public suffixes of domains as character vector

## Examples

``` r
public_suffix("http://example.com")
#> [1] "com"

# doesn't work for general URLs
public_suffix("http://example.com/path/to/file")
#> [1] NA

# extracting hostname first does the trick
public_suffix(ada_get_hostname("http://example.com/path/to/file"))
#> [1] "com"
```
