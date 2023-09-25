#pragma once

#include <Rcpp.h>
#include "ada/ada.cpp" // unforunately not header only

using namespace Rcpp;

std::string charsub(ada_string stringi);

// cash cow
DataFrame Rcpp_ada_parse(CharacterVector input_vec, IntegerVector length_vec);

// has_*
LogicalVector Rcpp_ada_has_credentials(const CharacterVector& url_vec);
LogicalVector Rcpp_ada_has_empty_hostname(const CharacterVector& url_vec);
LogicalVector Rcpp_ada_has_hostname(const CharacterVector& url_vec);
LogicalVector Rcpp_ada_has_non_empty_username(const CharacterVector& url_vec);
LogicalVector Rcpp_ada_has_non_empty_password(const CharacterVector& url_vec);
LogicalVector Rcpp_ada_has_port(const CharacterVector& url_vec);
LogicalVector Rcpp_ada_has_hash(const CharacterVector& url_vec);
LogicalVector Rcpp_ada_has_search(const CharacterVector& url_vec);

// get_*
CharacterVector Rcpp_ada_get_href(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_username(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_password(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_port(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_hash(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_host(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_hostname(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_pathname(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_search(const CharacterVector& url_vec);
CharacterVector Rcpp_ada_get_protocol(const CharacterVector& url_vec);
