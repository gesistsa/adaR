# adaR 0.4.0

## Breaking changes

* privately registered suffixes (`github.io`, `blogspot.com`,
  `s3.amazonaws.com`, ...) are now part of the public suffix list lookup (#65).
  `public_suffix()` and `ada_get_domain()` gained an `icann_only` argument,
  defaulting to `FALSE`; pass `icann_only = TRUE` for the previous behaviour.

  ``` r
  public_suffix("foo.github.io")                      # "github.io" (was "io")
  ada_get_domain("https://foo.github.io/p")           # "foo.github.io"
  ada_get_domain("https://foo.github.io/p", icann_only = TRUE)  # "github.io"
  ```

## Other changes

* `public_suffix()` now honours the exception (`!`) rules of the public suffix
  list, which were previously stored with their `!` prefix and could never
  match. `public_suffix("city.kobe.jp")` is now `"kobe.jp"` rather than
  `"city.kobe.jp"`, and `ada_get_domain()` returns a domain instead of `""`
  for hosts under those rules
* `ada_get_domain()` no longer strips a leading `www.` before looking up the
  suffix; the result is unchanged for ordinary hosts but `www.ck` and similar
  no longer come back as `NA`
* the C++ loops check for a user interrupt, so long vectors can be cancelled
  with Ctrl-C (#49)
* fixed `url_decode2()` dropping the remainder of a string after a `%` that is
  not followed by two hex digits (the escape is now passed through verbatim)
* fixed `public_suffix()` erroring on two or more bare hostnames matching a
  wildcard rule, e.g. `public_suffix(c("a.b.ck", "c.d.ck"))`
* `public_suffix()` now accepts full URLs with a path (#54), and returns the
  same suffix for a URL and its hostname
* `ada_get_domain()` now accepts a bare domain, so it is idempotent (#36);
  schemeless input with a path is still `NA`
* `ada_get_basename()` gained the `decode` argument the other getters have, and
  no longer appends `//` for schemes without an authority component
* all exported functions now error on non-character input instead of silently
  returning `NA`

# adaR 0.3.5

* bumped ada-url to 3.4.2

# adaR 0.3.4

* improved ada_url_parse performance(#73)

# adaR 0.3.3

* bumped ada-url to 2.9.0

# adaR 0.3.2

* fixed #66

# adaR 0.3.1

* bumped ada-url to 2.7.3
* transferred repository from schochastics to gesistsa

# adaR 0.3.0

* bump ada_url version to 2.7.0 #58
* export all `ada_clear_*()` functions #57
* export all `ada_set_*()` functions #15 h/t @chainsawriot for the c++ template
* added `ada_get_basename()` #56

# adaR 0.2.0

* split C++ file to isolate original ada-url code h/t Chung-hong Chan (@chainsawriot)
* add support for public suffix extraction #14
* add support for punycode #18
* added `url_decode2` as a fast alternative to `utils::URLdecode` 
* improved vectorization of `ada_get_*` and `ada_has_*` #26 and #30 h/t
  Chung-hong Chan (@chainsawriot) 
* fixed #47 h/t Chung-hong Chan (@chainsawriot)
* added `ada_get_domain()` #43


# adaR 0.1.0

* added `ada_url_parser`
* added `ada_get_*`
* error handling for wrong urls #2
* fixed #5 h/t Chung-hong Chan (@chainsawriot)
* add has checks #7 
* vectorized functions #4
* tests h/t Chung-hong Chan (@chainsawriot)
