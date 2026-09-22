#include "adaR.h"

#include "urldecode.h"

std::string charsub(const ada_string stringi, bool to_unicode) {
  // to_unicode = false should only be used for href, see #66
  if (!to_unicode) {
    return std::string(stringi.data, stringi.length);
  }
  ada_owned_string stringi_new = ada_idna_to_unicode(stringi.data, stringi.length);
  std::string output(stringi_new.data, stringi_new.length);
  ada_free_owned_string(stringi_new);
  return output;
}

// Give the user a chance to interrupt long vectors. checkUserInterrupt()
// throws, which is safe here because AdaUrl releases its handle while the
// stack unwinds.
static inline void poll_interrupt(R_xlen_t i) {
  if ((i & 0x3FFF) == 0) Rcpp::checkUserInterrupt();
}

// [[Rcpp::export]]
List Rcpp_ada_parse(const CharacterVector& input_vec, bool decode) {
  const R_xlen_t n = input_vec.length();
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
  Rcpp::IntegerVector row_name(n);
  for (R_xlen_t i = 0; i < n; i++) {
    poll_interrupt(i);
    String s = input_vec[i];
    std::string_view input(s.get_cstring());
    AdaUrl url(input);
    if (url.is_valid()) {
      href[i] = charsub(ada_get_href(url.get()), false);
      protocol[i] = charsub(ada_get_protocol(url.get()));
      username[i] = charsub(ada_get_username(url.get()));
      password[i] = charsub(ada_get_password(url.get()));
      host[i] = charsub(ada_get_host(url.get()));
      hostname[i] = charsub(ada_get_hostname(url.get()));
      port[i] = charsub(ada_get_port(url.get()));
      pathname[i] = charsub(ada_get_pathname(url.get()));
      search[i] = charsub(ada_get_search(url.get()));
      hash[i] = charsub(ada_get_hash(url.get()));
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
    row_name[i] = i + 1;
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

  List result = List::create(Named("href") = href, _["protocol"] = protocol,
                             _["username"] = username, _["password"] = password,
                             _["host"] = host, _["hostname"] = hostname,
                             _["port"] = port, _["pathname"] = pathname,
                             _["search"] = search, _["hash"] = hash);
  // as data.frame is expensive - create from the list
  result.attr("row.names") = row_name;
  result.attr("class") = "data.frame";

  return result;
}

// higher-order function for all Rcpp_ada_has_*
// templated rather than taking std::function, so that the ada call inlines
template <typename F>
LogicalVector Rcpp_ada_has(const CharacterVector& url_vec, F func) {
  const R_xlen_t n = url_vec.length();
  LogicalVector out(n);
  for (R_xlen_t i = 0; i < n; i++) {
    poll_interrupt(i);
    String s = url_vec[i];
    std::string_view input(s.get_cstring());
    AdaUrl url(input);
    out[i] = url.is_valid() ? static_cast<int>(func(url.get())) : NA_LOGICAL;
  }
  return out;
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_credentials(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, ada_has_credentials);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_empty_hostname(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, ada_has_empty_hostname);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_hostname(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, ada_has_hostname);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_non_empty_username(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, ada_has_non_empty_username);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_non_empty_password(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, ada_has_non_empty_password);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_port(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, ada_has_port);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_hash(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, ada_has_hash);
}

// [[Rcpp::export]]
LogicalVector Rcpp_ada_has_search(const CharacterVector& url_vec) {
  return Rcpp_ada_has(url_vec, ada_has_search);
}

// higher-order function for all Rcpp_ada_get_*
template <typename F>
CharacterVector Rcpp_ada_get(const CharacterVector& url_vec, F func,
                             bool decode, bool to_unicode = true) {
  const R_xlen_t n = url_vec.length();
  CharacterVector out(n);
  for (R_xlen_t i = 0; i < n; i++) {
    poll_interrupt(i);
    String s = url_vec[i];
    std::string_view input(s.get_cstring());
    AdaUrl url(input);
    if (!url.is_valid()) {
      out[i] = NA_STRING;
    } else {
      out[i] = charsub(func(url.get()), to_unicode);
    }
  }
  if (decode) {
    out = Rcpp_url_decode2(out);
  }
  return out;
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_href(const CharacterVector& url_vec, bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_href, decode, false);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_username(const CharacterVector& url_vec,
                                      bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_username, decode, false);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_password(const CharacterVector& url_vec,
                                      bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_password, decode, false);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_port(const CharacterVector& url_vec, bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_port, decode, false);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_hash(const CharacterVector& url_vec, bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_hash, decode, false);
}

// host and hostname are the only components IDNA applies to
// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_host(const CharacterVector& url_vec, bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_host, decode, true);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_hostname(const CharacterVector& url_vec,
                                      bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_hostname, decode, true);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_pathname(const CharacterVector& url_vec,
                                      bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_pathname, decode, false);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_search(const CharacterVector& url_vec,
                                    bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_search, decode, false);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_protocol(const CharacterVector& url_vec,
                                      bool decode) {
  return Rcpp_ada_get(url_vec, ada_get_protocol, decode, false);
}

// higher-order function for Rcpp_ada_set_*
// the setters return either bool or void; the result is discarded either way
template <typename F>
CharacterVector Rcpp_ada_set(const CharacterVector& url_vec, F func,
                             const CharacterVector& subst, bool decode) {
  const R_xlen_t n = url_vec.length();
  CharacterVector out(n);
  for (R_xlen_t i = 0; i < n; i++) {
    poll_interrupt(i);
    String s = url_vec[i];
    String s2 = subst[i];
    std::string_view input(s.get_cstring());
    std::string_view replace(s2.get_cstring());
    AdaUrl url(input);
    if (!url.is_valid()) {
      out[i] = NA_STRING;
    } else {
      func(url.get(), replace.data(), replace.length());
      out[i] = charsub(ada_get_href(url.get()), false);
    }
  }
  if (decode) {
    out = Rcpp_url_decode2(out);
  }
  return out;
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_href(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_href, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_username(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_username, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_password(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_password, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_port(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_port, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_host(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_host, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_hostname(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_hostname, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_pathname(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_pathname, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_protocol(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_protocol, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_search(const CharacterVector& url_vec,
                                    const CharacterVector& subst, bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_search, subst, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_set_hash(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode) {
  return Rcpp_ada_set(url_vec, ada_set_hash, subst, decode);
}

// higher order function for ada_clear_*
template <typename F>
CharacterVector Rcpp_ada_clear(const CharacterVector& url_vec, F func,
                               bool decode) {
  const R_xlen_t n = url_vec.length();
  CharacterVector out(n);
  for (R_xlen_t i = 0; i < n; i++) {
    poll_interrupt(i);
    String s = url_vec[i];
    std::string_view input(s.get_cstring());
    AdaUrl url(input);
    if (!url.is_valid()) {
      out[i] = NA_STRING;
    } else {
      func(url.get());
      out[i] = charsub(ada_get_href(url.get()), false);
    }
  }
  if (decode) {
    out = Rcpp_url_decode2(out);
  }
  return out;
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_clear_port(const CharacterVector& url_vec,
                                    bool decode) {
  return Rcpp_ada_clear(url_vec, ada_clear_port, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_clear_hash(const CharacterVector& url_vec,
                                    bool decode) {
  return Rcpp_ada_clear(url_vec, ada_clear_hash, decode);
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_clear_search(const CharacterVector& url_vec,
                                      bool decode) {
  return Rcpp_ada_clear(url_vec, ada_clear_search, decode);
}
