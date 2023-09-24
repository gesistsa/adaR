#pragma once

#include <Rcpp.h>
#include "ada/ada.cpp" // unforunately not header only

using namespace Rcpp;

std::string charsub(ada_string stringi);

// cash cow
Rcpp::DataFrame Rcpp_ada_parse(CharacterVector input_vec, IntegerVector length_vec);

// has_*
bool Rcpp_ada_has_credentials(const char* input, size_t length);
bool Rcpp_ada_has_empty_hostname(const char* input, size_t length);
bool Rcpp_ada_has_hostname(const char* input, size_t length);
bool Rcpp_ada_has_non_empty_username(const char* input, size_t length);
bool Rcpp_ada_has_non_empty_password(const char* input, size_t length);
bool Rcpp_ada_has_port(const char* input, size_t length);
bool Rcpp_ada_has_hash(const char* input, size_t length);
bool Rcpp_ada_has_search(const char* input, size_t length);

// get_*
CharacterVector Rcpp_ada_get_href(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_username(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_password(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_port(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_hash(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_host(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_hostname(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_pathname(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_search(CharacterVector input_vec, IntegerVector length_vec);
CharacterVector Rcpp_ada_get_protocol(CharacterVector input_vec, IntegerVector length_vec);
