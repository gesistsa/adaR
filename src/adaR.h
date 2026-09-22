#pragma once

#include <Rcpp.h>

#include "ada/ada.cpp"  // unforunately not header only

using namespace Rcpp;

// Owning wrapper around an ada_url handle, so that the handle is released even
// if Rcpp throws while the result vector is being filled.
class AdaUrl {
 public:
  explicit AdaUrl(std::string_view input)
      : url_(ada_parse(input.data(), input.length())) {}
  ~AdaUrl() { ada_free(url_); }

  AdaUrl(const AdaUrl&) = delete;
  AdaUrl& operator=(const AdaUrl&) = delete;

  bool is_valid() const { return ada_is_valid(url_); }
  ada_url get() const { return url_; }

 private:
  ada_url url_;
};

std::string charsub(const ada_string stringi, bool to_unicode = true);
