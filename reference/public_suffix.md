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

## Details

`domains` may be either full URLs or bare hostnames; anything that does
not parse as a URL is treated as a hostname.

## Examples

``` r
public_suffix("http://example.com")
#> [1] "com"

# hostnames work too
public_suffix("example.com")
#> [1] "com"

# for general URLs the hostname is extracted first
public_suffix("http://example.com/path/to/file")
#> [1] "com"
```
