#pragma once

#include <Rcpp.h>
using namespace Rcpp;

std::string decode(String u);
CharacterVector Rcpp_url_decode2(CharacterVector& url);
std::string str_reverse(std::string x);
CharacterVector url_reverse(CharacterVector& urls);
