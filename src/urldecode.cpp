#include <Rcpp.h>

using namespace Rcpp;

//' Function to percent-decode characters in URLs
//'
//' Similar to [utils::URLdecode]
//'
//' @param url a character vector
//' @export
//' @examples
//' url_decode("Hello%20World")
// [[Rcpp::export]]
CharacterVector url_decode(CharacterVector url) {
  return sapply(url, [](const String& u) {
    std::string input = u;
    std::string output;
    size_t i = 0;

    while (i < input.length()) {
      if (input[i] != '%') {
        output += input[i];
        i++;
      } else {
        int value;
        sscanf(input.substr(i + 1, 2).c_str(), "%x", &value);
        output += static_cast<char>(value);
        i += 3;
      }
    }

    return output;
  });
}