#' Extract the public suffix from a vector of domains or hostnames
#'
#' @param domains character. vector of domains or hostnames
#' @param icann_only logical. Whether to use only the ICANN section of the
#' public suffix list, ignoring privately registered suffixes such as
#' `github.io` or `blogspot.com`. Defaults to `FALSE`.
#' @details `domains` may be either full URLs or bare hostnames; anything that
#' does not parse as a URL is treated as a hostname. Wildcard (`*`) and
#' exception (`!`) rules of the public suffix list are both honoured.
#' @export
#' @return public suffixes of domains as character vector
#' @examples
#' public_suffix("http://example.com")
#'
#' # hostnames work too
#' public_suffix("example.com")
#'
#' # for general URLs the hostname is extracted first
#' public_suffix("http://example.com/path/to/file")
#'
#' # *.kobe.jp is a wildcard rule, !city.kobe.jp an exception to it
#' public_suffix(c("foo.kobe.jp", "city.kobe.jp"))
#'
#' # privately registered suffixes are included by default
#' public_suffix("foo.github.io")
#' public_suffix("foo.github.io", icann_only = TRUE)
public_suffix <- function(domains, icann_only = FALSE) {
    domains <- .check_url(domains, arg = "domains")
    if (is.null(domains)) {
        return(character(0))
    }
    rules <- .psl_rules(icann_only)
    host <- .as_hostname(domains)
    suffix_match <- triebeard::longest_match(rules$trie, url_reverse(host))

    # A wildcard rule such as *.ck means the label *before* the matched suffix
    # is part of the public suffix too.
    w <- which(suffix_match %in% rules$wildcard & !is.na(host))
    if (length(w) > 0L) {
        # host == suffix already is the full suffix, nothing to extend
        w <- w[host[w] != suffix_match[w]]
    }
    if (length(w) > 0L) {
        remainder <- .strip_suffix(host[w], suffix_match[w])
        has_label <- .has_dot(remainder)
        suffix_match[w[has_label]] <- paste0(
            sub(".*\\.([^\\.]+)$", "\\1", remainder[has_label]), ".",
            suffix_match[w[has_label]]
        )
        suffix_match[w[!has_label]] <- host[w[!has_label]]
    }

    # Exception rules beat wildcard rules, so they are applied last.
    .apply_exceptions(host, suffix_match, rules$exception)
}

#' Apply the public suffix list's exception (`!`) rules
#'
#' A rule such as `!city.kobe.jp` cancels the `*.kobe.jp` wildcard: where the
#' rule matches, the public suffix is the rule minus its leftmost label, so
#' `city.kobe.jp` and `www.city.kobe.jp` both have the suffix `kobe.jp`.
#' There is a handful of these, so looping over the rules is cheaper than
#' another trie lookup.
#' @noRd
.apply_exceptions <- function(host, suffix, exception) {
    for (rule in exception) {
        hit <- !is.na(host) & (host == rule | endsWith(host, paste0(".", rule)))
        if (any(hit)) {
            suffix[hit] <- sub("^[^.]+\\.", "", rule)
        }
    }
    suffix
}

#' Treat each element as a hostname, parsing it out of a URL where possible
#'
#' Elements that parse as a URL contribute their hostname. Anything else is
#' only accepted if it is a bare hostname: no scheme, path, query, fragment,
#' credentials, port or whitespace. Such a candidate is normalised through
#' ada (lower-casing, IDNA, trailing dots) so that it is handled exactly like
#' a hostname extracted from a URL. Everything else stays `NA`, rather than
#' being passed through verbatim and matched against the suffix trie.
#' @noRd
.as_hostname <- function(x) {
    host <- ada_get_hostname(x)
    candidate <- which(is.na(host) & !is.na(x))
    if (length(candidate) == 0L) {
        return(host)
    }
    bare <- x[candidate]
    is_bare <- nzchar(bare) & !grepl("[/?#@:[:space:]]", bare)
    host[candidate[is_bare]] <- ada_get_hostname(paste0("http://", bare[is_bare]))
    host
}

#' Drop a known suffix (and its leading dot) from each element of `host`
#'
#' `suffix` must be a suffix of `host` element-wise; this is a vectorised
#' equivalent of `sub(paste0("\\.", suffix, "$"), "", host)`.
#' @noRd
.strip_suffix <- function(host, suffix) {
    substr(host, 1L, nchar(host) - nchar(suffix) - 1L)
}

.has_dot <- function(x) {
    grepl("\\.", x)
}
