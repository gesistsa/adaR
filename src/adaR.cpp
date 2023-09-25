#include "adaR.h"

std::string charsub(const ada_string stringi) {
  const char* res = stringi.data;
  size_t len = stringi.length;
  ada_owned_string stringi_new = ada_idna_to_unicode(res, len);
  res = stringi_new.data;
  len = stringi_new.length;
  return std::string(res, 0, len);
}

// [[Rcpp::export]]
DataFrame Rcpp_ada_parse(const CharacterVector& input_vec) {
  unsigned int n = input_vec.length();
  CharacterVector href(n);
  CharacterVector protocol(n);
  CharacterVector username(n);
  CharacterVector password(n);
  CharacterVector host(n);
  CharacterVector hostname(n);
  CharacterVector port(n);
  CharacterVector pathname(n);
  CharacterVector search(n);
  CharacterVector hash(n);
  for (unsigned int i = 0; i < n; i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    ada_url url = ada_parse(input, std::strlen(input));
    if (ada_is_valid(url)) {
      href[i] = charsub(ada_get_href(url));
      protocol[i] = charsub(ada_get_protocol(url));
      username[i] = charsub(ada_get_username(url));
      password[i] = charsub(ada_get_password(url));
      host[i] = charsub(ada_get_host(url));
      hostname[i] = charsub(ada_get_hostname(url));
      port[i] = charsub(ada_get_port(url));
      pathname[i] = charsub(ada_get_pathname(url));
      search[i] = charsub(ada_get_search(url));
      hash[i] = charsub(ada_get_hash(url));
    } else {
      href[i] = s;
      protocol[i] = NA_STRING;
      username[i] = NA_STRING;
      password[i] = NA_STRING;
      host[i] = NA_STRING;
      hostname[i] = NA_STRING;
      port[i] = NA_STRING;
      pathname[i] = NA_STRING;
      search[i] = NA_STRING;
      hash[i] = NA_STRING;
    }
  }
  return (DataFrame::create(Named("href") = href, _["protocol"] = protocol,
                            _["username"] = username, _["password"] = password,
                            _["host"] = host, _["hostname"] = hostname,
                            _["port"] = port, _["pathname"] = pathname,
                            _["search"] = search, _["hash"] = hash));
}

//higher-order function for all Rcpp_ada_has_*
LogicalVector Rcpp_ada_has(const CharacterVector& url_vec, std::function<bool(ada_url)> func) {
  unsigned int n = url_vec.length();
  LogicalVector out(n);
  for (unsigned int i = 0; i < n; i++) {
    String s = url_vec[i];
    const char* input = s.get_cstring();
    ada_url url = ada_parse(input, std::strlen(input));
    if (!ada_is_valid(url)) {
      out[i] = NA_LOGICAL;
    } else {
      out[i] = func(url);
    }
  }
  return out;
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_credentials(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, &ada_has_credentials);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_empty_hostname(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, &ada_has_empty_hostname);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_hostname(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, &ada_has_hostname);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_non_empty_username(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, &ada_has_non_empty_username);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_non_empty_password(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, &ada_has_non_empty_password);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_port(const CharacterVector& url_vec) {
    return Rcpp_ada_has(url_vec, &ada_has_port);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_hash(const CharacterVector& url_vec) {
    return Rcpp_ada_has(url_vec, &ada_has_hash);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_search(const CharacterVector& url_vec) {
    return Rcpp_ada_has(url_vec, &ada_has_search);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_href(CharacterVector input_vec,
                                  IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_href(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_username(CharacterVector input_vec,
                                      IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_username(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_password(CharacterVector input_vec,
                                      IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_password(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_port(CharacterVector input_vec,
                                  IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_port(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_hash(CharacterVector input_vec,
                                  IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_hash(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_host(CharacterVector input_vec,
                                  IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_host(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_hostname(CharacterVector input_vec,
                                      IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_hostname(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_pathname(CharacterVector input_vec,
                                      IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_pathname(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_search(CharacterVector input_vec,
                                    IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_search(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_protocol(CharacterVector input_vec,
                                      IntegerVector length_vec) {
  int n = length_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < input_vec.length(); i++) {
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if (ada_is_valid(url)) {
      out[i] = charsub(ada_get_protocol(url));
    } else {
      out[i] = NA_STRING;
    }
  }
  return (out);
}
