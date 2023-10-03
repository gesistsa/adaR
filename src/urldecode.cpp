#include "urldecode.h"

std::string decode(String u) {
    std::string input = u;
    std::string output;
    size_t i = 0;

    while (i < input.length()) {
      if (input[i] != '%') {
        output += input[i];
        i++;
      } else {
        unsigned int value;
        sscanf(input.substr(i + 1, 2).c_str(), "%x", &value);
        output += static_cast<char>(value);
        i += 3;
      }
    }
    return output;
}

// [[Rcpp::export]]
CharacterVector Rcpp_url_decode2(CharacterVector& url) {
  unsigned int input_size = url.size();
  CharacterVector output(input_size);
  for (unsigned int i = 0; i < input_size; i++) {
    if (url[i] == NA_STRING) {
      output[i] = NA_STRING;
    } else {
      output[i] = decode(url[i]);
    }
  }
  return output;
}

std::string str_reverse(std::string x) {
  std::reverse(x.begin(), x.end());
  return x;
}

//[[Rcpp::export]]
CharacterVector url_reverse(CharacterVector& urls) {
  unsigned int input_size = urls.size();
  CharacterVector output(input_size);
  for (unsigned int i = 0; i < input_size; i++) {
    if (urls[i] == NA_STRING) {
      output[i] = NA_STRING;
    } else {
      output[i] = str_reverse(Rcpp::as<std::string>(urls[i]));
    }
  }
  return output;
}
