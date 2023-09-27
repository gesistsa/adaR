# Benchmarking adaR

``` r
library(adaR)
library(urltools)
```


    Attaching package: 'urltools'

    The following object is masked from 'package:adaR':

        url_decode

## Data

We will use several different datasets provided by
[ada-url](https://github.com/ada-url/url-various-datasets) and by the
[webtrackR](https://github.com/schochastics/webtrackR) package

``` r
node_files <- readLines("https://raw.githubusercontent.com/ada-url/url-various-datasets/main/files/node_files.txt")
linux_files <- readLines("https://raw.githubusercontent.com/ada-url/url-various-datasets/main/files/linux_files.txt")
top100 <- readLines("https://raw.githubusercontent.com/ada-url/url-various-datasets/main/top100/top100.txt")
wiki <- readLines("https://raw.githubusercontent.com/ada-url/url-various-datasets/main/wikipedia/wikipedia_100k.txt")
corner <- readLines("corner.txt")
```

- `node_files.txt`: all source files from a given Node.js snapshot as
  URLs (43415 URLs)
- `linux_files.txt`: all files from a Linux systems as URLs (169312
  URLs).
- `wikipedia_100k.txt`: 100k URLs from a snapshot of all Wikipedia
  articles as URLs (March 6th 2023)
- `top100.txt`: crawl of the top visited 100 websites and extracts
  unique URLs
- `corner.txt`: a small set of fictional urls which represent corner
  cases

## Tools

We benchmark `adaR` with the R package
[`urltools`](https://github.com/Ironholds/urltools).

``` r
bench::mark(
    ada = ada_get_hostname(top100),
    urltools = domain(top100),
    iterations = 1, check = FALSE
)
```

    Warning: Some expressions had a GC in every iteration; so filtering is
    disabled.

    # A tibble: 2 × 6
      expression      min   median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    1 ada           961ms    961ms      1.04    2.73MB    15.6 
    2 urltools      126ms    126ms      7.92    6.27MB     7.92
