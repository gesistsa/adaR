#include "adaR.h"

#include "urldecode.h"

std::string charsub(const ada_string stringi, bool to_unicode) {
  const char* res = stringi.data;
  size_t len = stringi.length;
  if (to_unicode) {
    ada_owned_string stringi_new = ada_idna_to_unicode(res, len);
    std::string_view output(stringi_new.data, stringi_new.length);
    std::string output2 = {output.begin(), output.end()};
    ada_free_owned_string(stringi_new);
    return output2;
  } else {
    std::string_view output(stringi.data, stringi.length);
    std::string output2 = {output.begin(), output.end()};
    return output2;
  }
}

// [[Rcpp::export]]
DataFrame Rcpp_ada_parse(const CharacterVector& input_vec, bool decode,
                         bool to_unicode) {
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
    std::string_view input(s.get_cstring());
    ada_url url = ada_parse(input.data(), input.length());
    if (ada_is_valid(url)) {
      href[i] = charsub(ada_get_href(url), to_unicode);
      protocol[i] = charsub(ada_get_protocol(url), to_unicode);
      username[i] = charsub(ada_get_username(url), to_unicode);
      password[i] = charsub(ada_get_password(url), to_unicode);
      host[i] = charsub(ada_get_host(url), to_unicode);
      hostname[i] = charsub(ada_get_hostname(url), to_unicode);
      port[i] = charsub(ada_get_port(url), to_unicode);
      pathname[i] = charsub(ada_get_pathname(url), to_unicode);
      search[i] = charsub(ada_get_search(url), to_unicode);
      hash[i] = charsub(ada_get_hash(url), to_unicode);
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
    ada_free(url);
  }
  if (decode) {
    href = Rcpp_url_decode2(href);
    protocol = Rcpp_url_decode2(protocol);
    username = Rcpp_url_decode2(username);
    password = Rcpp_url_decode2(password);
    host = Rcpp_url_decode2(host);
    hostname = Rcpp_url_decode2(hostname);
    port = Rcpp_url_decode2(port);
    pathname = Rcpp_url_decode2(pathname);
    search = Rcpp_url_decode2(search);
    hash = Rcpp_url_decode2(hash);
  }
  return (DataFrame::create(Named("href") = href, _["protocol"] = protocol,
                            _["username"] = username, _["password"] = password,
                            _["host"] = host, _["hostname"] = hostname,
                            _["port"] = port, _["pathname"] = pathname,
                            _["search"] = search, _["hash"] = hash));
}

// higher-order function for all Rcpp_ada_has_*
LogicalVector Rcpp_ada_has(const CharacterVector& url_vec,
                           std::function<bool(ada_url)> func) {
  unsigned int n = url_vec.length();
  LogicalVector out(n);
  for (unsigned int i = 0; i < n; i++) {
    String s = url_vec[i];
    std::string_view input(s.get_cstring());
    ada_url url = ada_parse(input.data(), input.length());
    if (!ada_is_valid(url)) {
      out[i] = NA_LOGICAL;
    } else {
      out[i] = func(url);
    }
    ada_free(url);
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

// higher-order function for all Rcpp_ada_get_*
CharacterVector Rcpp_ada_get(const CharacterVector& url_vec,
                             std::function<ada_string(ada_url)> func,
                             bool decode, bool to_unicode) {
  unsigned int n = url_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < url_vec.length(); i++) {
    String s = url_vec[i];
    std::string_view input(s.get_cstring());
    ada_url url = ada_parse(input.data(), input.length());
    if (!ada_is_valid(url)) {
      out[i] = NA_STRING;
    } else {
      out[i] = charsub(func(url), to_unicode);
    }
    ada_free(url);
  }
  if (decode) {
    out = Rcpp_url_decode2(out);
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_href(const CharacterVector& url_vec, bool decode,
                                  bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_href, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_username(const CharacterVector& url_vec,
                                      bool decode, bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_username, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_password(const CharacterVector& url_vec,
                                      bool decode, bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_password, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_port(const CharacterVector& url_vec, bool decode,
                                  bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_port, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_hash(const CharacterVector& url_vec, bool decode,
                                  bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_hash, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_host(const CharacterVector& url_vec, bool decode,
                                  bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_host, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_hostname(const CharacterVector& url_vec,
                                      bool decode, bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_hostname, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_pathname(const CharacterVector& url_vec,
                                      bool decode, bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_pathname, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_search(const CharacterVector& url_vec, bool decode,
                                    bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_search, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_protocol(const CharacterVector& url_vec,
                                      bool decode, bool to_unicode) {
  return Rcpp_ada_get(url_vec, &ada_get_protocol, decode, to_unicode);
}

// higher-order function for Rcpp_ada_set_*
template <typename T>
CharacterVector Rcpp_ada_set(
    const CharacterVector& url_vec,
    std::function<T(ada_url, const char*, size_t)> func,
    const CharacterVector& subst, bool decode, bool to_unicode) {
  unsigned int n = url_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < url_vec.length(); i++) {
    String s = url_vec[i];
    String s2 = subst[i];
    std::string_view input(s.get_cstring());
    std::string_view replace(s2.get_cstring());
    ada_url url = ada_parse(input.data(), input.length());
    if (!ada_is_valid(url)) {
      out[i] = NA_STRING;
    } else {
      func(url, replace.data(), replace.length());
      out[i] = charsub(ada_get_href(url), to_unicode);
    }
    ada_free(url);
  }
  if (decode) {
    out = Rcpp_url_decode2(out);
  }
  return (out);
}
// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_href(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode,
                                  bool to_unicode) {
  return Rcpp_ada_set<bool>(url_vec, &ada_set_href, subst, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_username(const CharacterVector& url_vec,
                                      const CharacterVector& subst, bool decode,
                                      bool to_unicode) {
  return Rcpp_ada_set<bool>(url_vec, &ada_set_username, subst, decode,
                            to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_password(const CharacterVector& url_vec,
                                      const CharacterVector& subst, bool decode,
                                      bool to_unicode) {
  return Rcpp_ada_set<bool>(url_vec, &ada_set_password, subst, decode,
                            to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_port(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode,
                                  bool to_unicode) {
  return Rcpp_ada_set<bool>(url_vec, &ada_set_port, subst, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_host(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode,
                                  bool to_unicode) {
  return Rcpp_ada_set<bool>(url_vec, &ada_set_host, subst, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_hostname(const CharacterVector& url_vec,
                                      const CharacterVector& subst, bool decode,
                                      bool to_unicode) {
  return Rcpp_ada_set<bool>(url_vec, &ada_set_hostname, subst, decode,
                            to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_pathname(const CharacterVector& url_vec,
                                      const CharacterVector& subst, bool decode,
                                      bool to_unicode) {
  return Rcpp_ada_set<bool>(url_vec, &ada_set_pathname, subst, decode,
                            to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_protocol(const CharacterVector& url_vec,
                                      const CharacterVector& subst, bool decode,
                                      bool to_unicode) {
  return Rcpp_ada_set<bool>(url_vec, &ada_set_protocol, subst, decode,
                            to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_search(const CharacterVector& url_vec,
                                    const CharacterVector& subst, bool decode,
                                    bool to_unicode) {
  return Rcpp_ada_set<void>(url_vec, &ada_set_search, subst, decode,
                            to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_hash(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode,
                                  bool to_unicode) {
  return Rcpp_ada_set<void>(url_vec, &ada_set_hash, subst, decode, to_unicode);
}

// higher order function for ada_clear_*
CharacterVector Rcpp_ada_clear(const CharacterVector& url_vec,
                               std::function<void(ada_url)> func, bool decode,
                               bool to_unicode) {
  unsigned int n = url_vec.length();
  CharacterVector out(n);
  for (int i = 0; i < url_vec.length(); i++) {
    String s = url_vec[i];
    std::string_view input(s.get_cstring());
    ada_url url = ada_parse(input.data(), input.length());
    if (!ada_is_valid(url)) {
      out[i] = NA_STRING;
    } else {
      func(url);
      out[i] = charsub(ada_get_href(url), to_unicode);
    }
    ada_free(url);
  }
  if (decode) {
    out = Rcpp_url_decode2(out);
  }
  return (out);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_clear_port(const CharacterVector& url_vec, bool decode,
                                    bool to_unicode) {
  return Rcpp_ada_clear(url_vec, &ada_clear_port, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_clear_hash(const CharacterVector& url_vec, bool decode,
                                    bool to_unicode) {
  return Rcpp_ada_clear(url_vec, &ada_clear_hash, decode, to_unicode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_clear_search(const CharacterVector& url_vec,
                                      bool decode, bool to_unicode) {
  return Rcpp_ada_clear(url_vec, &ada_clear_search, decode, to_unicode);
}
