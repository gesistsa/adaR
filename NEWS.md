# adaR 0.3.4

* improved ada_url_parse performance(#73)

# adaR 0.3.3

* * bumped ada-url to 2.9.0

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
