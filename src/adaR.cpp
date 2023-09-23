#include "adaR.hpp"

std::string charsub(ada_string stringi){
  const char* res = stringi.data;
  size_t len = stringi.length;
  return std::string(res, 0, len); 
}

// [[Rcpp::export]]
DataFrame Rcpp_ada_parse(CharacterVector input_vec, IntegerVector length_vec) {
  int n = length_vec.length();
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
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        href[i]     = charsub(ada_get_href(url));
        protocol[i] = charsub(ada_get_protocol(url));
        username[i] = charsub(ada_get_username(url));
        password[i] = charsub(ada_get_password(url));
        host[i]     = charsub(ada_get_host(url));
        hostname[i] = charsub(ada_get_hostname(url));
        port[i]     = charsub(ada_get_port(url));
        pathname[i] = charsub(ada_get_pathname(url));
        search[i]   = charsub(ada_get_search(url));
        hash[i]     = charsub(ada_get_hash(url));
    } else{
        href[i]     = s;
        protocol[i] = NA_STRING;
        username[i] = NA_STRING;
        password[i] = NA_STRING;
        host[i]     = NA_STRING;
        hostname[i] = NA_STRING;
        port[i]     = NA_STRING;
        pathname[i] = NA_STRING;
        search[i]   = NA_STRING;
        hash[i]     = NA_STRING;
    }
  }
  return(DataFrame::create( 
    Named("href") = href , 
    _["protocol"] = protocol,
    _["username"] = username,
    _["password"] = password,
    _["host"] = host,
    _["hostname"] = hostname,
    _["port"] = port,
    _["pathname"] = pathname,
    _["search"] = search,
    _["hash"] = hash ));
}

// [[Rcpp::export]]
bool Rcpp_ada_has_credentials(const char* input, size_t length){
  ada_url url = ada_parse(input, length);
  if(ada_is_valid(url)){
    return ada_has_credentials(url);
  } else{
    stop("input is not a valid url");
  }
}

// [[Rcpp::export]]
bool Rcpp_ada_has_empty_hostname(const char* input, size_t length){
  ada_url url = ada_parse(input, length);
  if(ada_is_valid(url)){
    return ada_has_empty_hostname(url);
  } else{
    stop("input is not a valid url");
  }
}

// [[Rcpp::export]]
bool Rcpp_ada_has_hostname(const char* input, size_t length){
  ada_url url = ada_parse(input, length);
  if(ada_is_valid(url)){
    return ada_has_hostname(url);
  } else{
    stop("input is not a valid url");
  }
}

// [[Rcpp::export]]
bool Rcpp_ada_has_non_empty_username(const char* input, size_t length){
  ada_url url = ada_parse(input, length);
  if(ada_is_valid(url)){
    return ada_has_non_empty_username(url);
  } else{
    stop("input is not a valid url");
  }
}

// [[Rcpp::export]]
bool Rcpp_ada_has_non_empty_password(const char* input, size_t length){
  ada_url url = ada_parse(input, length);
  if(ada_is_valid(url)){
    return ada_has_non_empty_password(url);
  } else{
    stop("input is not a valid url");
  }
}

// [[Rcpp::export]]
bool Rcpp_ada_has_port(const char* input, size_t length){
  ada_url url = ada_parse(input, length);
  if(ada_is_valid(url)){
    return ada_has_port(url);
  } else{
    stop("input is not a valid url");
  }
}

// [[Rcpp::export]]
bool Rcpp_ada_has_hash(const char* input, size_t length){
  ada_url url = ada_parse(input, length);
  if(ada_is_valid(url)){
    return ada_has_hash(url);
  } else{
    stop("input is not a valid url");
  }
}

// [[Rcpp::export]]
bool Rcpp_ada_has_search(const char* input, size_t length){
  ada_url url = ada_parse(input, length);
  if(ada_is_valid(url)){
    return ada_has_search(url);
  } else{
    stop("input is not a valid url");
  }
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_href(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_href(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_username(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_username(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_password(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_password(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_port(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_port(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_hash(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_hash(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_host(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_host(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_hostname(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_hostname(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_pathname(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_pathname(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_search(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_search(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}

// [[Rcpp::export]]
CharacterVector Rcpp_ada_get_protocol(CharacterVector input_vec, IntegerVector length_vec){
  int n = length_vec.length();
  CharacterVector out(n);
  for(int i=0; i<input_vec.length();i++){
    String s = input_vec[i];
    const char* input = s.get_cstring();
    size_t length = length_vec[i];
    ada_url url = ada_parse(input, length);
    if(ada_is_valid(url)){
        out[i] = charsub(ada_get_protocol(url));
    } else{
        out[i]     = NA_STRING;
    }
  }
  return(out);  
}
