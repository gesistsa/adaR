#pragma once

#include <Rcpp.h>

#include <string>

using namespace Rcpp;

std::string decode(const char* input, size_t len);
CharacterVector Rcpp_url_decode2(const CharacterVector& url);
std::string str_reverse(std::string x);
CharacterVector url_reverse(const CharacterVector& urls);
