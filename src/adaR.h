#pragma once

#include <Rcpp.h>

#include "ada/ada.cpp"  // unforunately not header only

using namespace Rcpp;

std::string charsub(const ada_string stringi, bool to_unicode);

// cash cow
DataFrame Rcpp_ada_parse(CharacterVector input_vec, bool decode);

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
CharacterVector Rcpp_ada_get_href(const CharacterVector& url_vec, bool decode);
CharacterVector Rcpp_ada_get_username(const CharacterVector& url_vec,
                                      bool decode);
CharacterVector Rcpp_ada_get_password(const CharacterVector& url_vec,
                                      bool decode);
CharacterVector Rcpp_ada_get_port(const CharacterVector& url_vec, bool decode);
CharacterVector Rcpp_ada_get_hash(const CharacterVector& url_vec, bool decode);
CharacterVector Rcpp_ada_get_host(const CharacterVector& url_vec, bool decode);
CharacterVector Rcpp_ada_get_hostname(const CharacterVector& url_vec,
                                      bool decode);
CharacterVector Rcpp_ada_get_pathname(const CharacterVector& url_vec,
                                      bool decode);
CharacterVector Rcpp_ada_get_search(const CharacterVector& url_vec,
                                    bool decode);
CharacterVector Rcpp_ada_get_protocol(const CharacterVector& url_vec,
                                      bool decode);

// set_*
CharacterVector Rcpp_ada_set_href(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode);
CharacterVector Rcpp_ada_set_username(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode);
CharacterVector Rcpp_ada_set_password(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode);
CharacterVector Rcpp_ada_set_port(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode);
CharacterVector Rcpp_ada_set_host(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode);
CharacterVector Rcpp_ada_set_hostname(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode);
CharacterVector Rcpp_ada_set_pathname(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode);
CharacterVector Rcpp_ada_set_protocol(const CharacterVector& url_vec,
                                      const CharacterVector& subst,
                                      bool decode);
CharacterVector Rcpp_ada_set_search(const CharacterVector& url_vec,
                                    const CharacterVector& subst, bool decode);
CharacterVector Rcpp_ada_set_hash(const CharacterVector& url_vec,
                                  const CharacterVector& subst, bool decode);
