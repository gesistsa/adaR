# Changelog

## adaR 0.3.5

- bumped ada-url to 3.4.2

## adaR 0.3.4

CRAN release: 2025-01-16

- improved ada_url_parse
  performance([\#73](https://github.com/gesistsa/adaR/issues/73))

## adaR 0.3.3

CRAN release: 2024-07-12

- bumped ada-url to 2.9.0

## adaR 0.3.2

CRAN release: 2024-02-08

- fixed [\#66](https://github.com/gesistsa/adaR/issues/66)

## adaR 0.3.1

CRAN release: 2023-11-16

- bumped ada-url to 2.7.3
- transferred repository from schochastics to gesistsa

## adaR 0.3.0

CRAN release: 2023-10-16

- bump ada_url version to 2.7.0
  [\#58](https://github.com/gesistsa/adaR/issues/58)
- export all `ada_clear_*()` functions
  [\#57](https://github.com/gesistsa/adaR/issues/57)
- export all `ada_set_*()` functions
  [\#15](https://github.com/gesistsa/adaR/issues/15) h/t
  [@chainsawriot](https://github.com/chainsawriot) for the c++ template
- added
  [`ada_get_basename()`](https://schochastics.github.io/adaR/reference/ada_get_href.md)
  [\#56](https://github.com/gesistsa/adaR/issues/56)

## adaR 0.2.0

CRAN release: 2023-10-01

- split C++ file to isolate original ada-url code h/t Chung-hong Chan
  ([@chainsawriot](https://github.com/chainsawriot))
- add support for public suffix extraction
  [\#14](https://github.com/gesistsa/adaR/issues/14)
- add support for punycode
  [\#18](https://github.com/gesistsa/adaR/issues/18)
- added `url_decode2` as a fast alternative to
  [`utils::URLdecode`](https://rdrr.io/r/utils/URLencode.html)
- improved vectorization of `ada_get_*` and `ada_has_*`
  [\#26](https://github.com/gesistsa/adaR/issues/26) and
  [\#30](https://github.com/gesistsa/adaR/issues/30) h/t Chung-hong Chan
  ([@chainsawriot](https://github.com/chainsawriot))
- fixed [\#47](https://github.com/gesistsa/adaR/issues/47) h/t
  Chung-hong Chan ([@chainsawriot](https://github.com/chainsawriot))
- added
  [`ada_get_domain()`](https://schochastics.github.io/adaR/reference/ada_get_href.md)
  [\#43](https://github.com/gesistsa/adaR/issues/43)

## adaR 0.1.0

- added `ada_url_parser`
- added `ada_get_*`
- error handling for wrong urls
  [\#2](https://github.com/gesistsa/adaR/issues/2)
- fixed [\#5](https://github.com/gesistsa/adaR/issues/5) h/t Chung-hong
  Chan ([@chainsawriot](https://github.com/chainsawriot))
- add has checks [\#7](https://github.com/gesistsa/adaR/issues/7)
- vectorized functions [\#4](https://github.com/gesistsa/adaR/issues/4)
- tests h/t Chung-hong Chan
  ([@chainsawriot](https://github.com/chainsawriot))
