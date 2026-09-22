#include "urldecode.h"

#include <algorithm>

// Value of a single hex digit, or -1 if `c` is not one.
static inline int hexval(char c) {
  if (c >= '0' && c <= '9') return c - '0';
  if (c >= 'a' && c <= 'f') return c - 'a' + 10;
  if (c >= 'A' && c <= 'F') return c - 'A' + 10;
  return -1;
}

// Percent-decode `input`. A '%' that is not followed by two hex digits is not
// an escape sequence and is passed through verbatim, as WHATWG requires.
std::string decode(const char* input, size_t len) {
  std::string output;
  output.reserve(len);
  size_t i = 0;
  while (i < len) {
    if (input[i] != '%') {
      output += input[i];
      i++;
      continue;
    }
    const int hi = (i + 2 < len) ? hexval(input[i + 1]) : -1;
    const int lo = (i + 2 < len) ? hexval(input[i + 2]) : -1;
    if (hi < 0 || lo < 0) {
      output += '%';
      i++;
    } else {
      output += static_cast<char>(hi * 16 + lo);
      i += 3;
    }
  }
  return output;
}

// [[Rcpp::export]]
CharacterVector Rcpp_url_decode2(const CharacterVector& url) {
  const R_xlen_t n = url.size();
  CharacterVector output(n);
  for (R_xlen_t i = 0; i < n; i++) {
    if (CharacterVector::is_na(url[i])) {
      output[i] = NA_STRING;
    } else {
      Rcpp::String s = url[i];
      const char* cstr = s.get_cstring();
      output[i] = decode(cstr, std::char_traits<char>::length(cstr));
    }
  }
  return output;
}

std::string str_reverse(std::string x) {
  std::reverse(x.begin(), x.end());
  return x;
}

//[[Rcpp::export]]
CharacterVector url_reverse(const CharacterVector& urls) {
  const R_xlen_t n = urls.size();
  CharacterVector output(n);
  for (R_xlen_t i = 0; i < n; i++) {
    if (CharacterVector::is_na(urls[i])) {
      output[i] = NA_STRING;
    } else {
      output[i] = str_reverse(Rcpp::as<std::string>(urls[i]));
    }
  }
  return output;
}
