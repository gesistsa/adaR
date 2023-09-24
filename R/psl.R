#' Extract the public suffix from a vector of domains
#'
#' @inheritParams ada_url_parse
#' @export
public_suffix <- function(url) {
    domains <- ada_get_hostname(url)
    dom_split <- strsplit(domains, ".", fixed = TRUE)
    tld_cand <- lapply(dom_split, .tld_build)
    out <- vapply(tld_cand, .ftld_lookup, character(1))
    tld_cand <- lapply(dom_split, .tld_build_wild)
    tld_cand_wild <- vapply(tld_cand, .ftld_lookup_wild, character(1))
    if (all(is.na(tld_cand_wild))) {
        return(out)
    } else {
        idx <- which(!is.na(tld_cand_wild))
        out_wild <- mapply(.replace_wildcard, domains[idx], tld_cand_wild[idx], USE.NAMES = FALSE)
        out[idx] <- out_wild
        return(out)
    }
}

.tld_build <- function(x) {
    n <- length(x)
    vapply(0:(n - 1), function(i) paste0(x[(n - i):n], collapse = "."), character(1))
}

.tld_build_wild <- function(x) {
    n <- length(x)
    vapply(0:(n - 2), function(i) paste0("*.", paste0(x[(n - i):n], collapse = ".")), character(1)) #-2 smells like trouble
}

.ftld_lookup <- function(x) {
    res <- fastmatch::fmatch(x, psl[["fixed"]])
    res <- res[!is.na(res)]
    if (length(res) != 0) {
        return(psl[["fixed"]][res[length(res)]])
    } else {
        return(NA_character_)
    }
}

.ftld_lookup_wild <- function(x) {
    res <- fastmatch::fmatch(x, psl[["wildcard"]])
    res <- res[!is.na(res)]
    if (length(res) != 0) {
        return(psl[["wildcard"]][res[length(res)]])
    } else {
        return(NA_character_)
    }
}

.replace_wildcard <- function(domain, wildcard) {
    dom_seg <- strsplit(domain, split = "\\.")[[1]]
    wild_seg <- strsplit(wildcard, split = "\\.")[[1]]

    len_diff <- length(dom_seg) - length(wild_seg)

    if (len_diff > 0) {
        wild_seg <- c(rep("", len_diff), wild_seg)
    }

    result_segments <- mapply(function(x, y) {
        if (y == "*") {
            return(x)
        }
        return(y)
    }, dom_seg, wild_seg, SIMPLIFY = TRUE)
    final <- paste(result_segments, collapse = ".")
    final <- sub("^\\.", "", final)
    return(final)
}
