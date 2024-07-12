# adaR - A Fast ‘WHATWG’ Compliant URL Parser


## Description

<!-- - Provide a brief and clear description of the method, its purpose, and what it aims to achieve. Add a link to a related paper from social science domain and show how your method can be applied to solve that research question.   -->

A wrapper for ‘ada-url’, a ‘WHATWG’ compliant and fast URL parser
written in modern ‘C++’. Also contains auxiliary functions such as a
public suffix extractor.

## Keywords

<!-- EDITME -->

- URL Parsing
- Webtracking Data
- Webscraping

## Science Usecase(s)

<!-- - Include usecases from social sciences that would make this method applicable in a certain scenario.  -->
<!-- The use cases or research questions mentioned should arise from the latest social science literature cited in the description. -->

URL parsing is an important process in the analysis of webtracking data,
e.g. [GESIS Web
Tracking](https://www.gesis.org/en/services/planning-studies-and-collecting-data/tools-for-the-collection-of-digital-behavioral-data/gesis-web-tracking).
Although not using this package, the technique has been used in various
social science publications, e.g. [de León et
al. (2023)](https://doi.org/10.5117/CCR2023.2.4.DELE).

The package was used in various webscraping projects for communication
research, e.g. [paperboy](https://github.com/JBGruber/paperboy).

## Repository structure

This repository follows [the standard structure of an R
package](https://cran.r-project.org/doc/FAQ/R-exts.html#Package-structure).

## Environment Setup

With R installed:

``` r
install.packages("adaR")
```

<!-- ## Hardware Requirements (Optional) -->
<!-- - The hardware requirements may be needed in specific cases when a method is known to require more memory/compute power.  -->
<!-- - The method need to be executed on a specific architecture (GPUs, Hadoop cluster etc.) -->

## Input Data

<!-- - The input data has to be a Digital Behavioral Data (DBD) Dataset -->
<!-- - You can provide link to a public DBD dataset. GESIS DBD datasets (https://www.gesis.org/en/institute/digital-behavioral-data) -->

The input data has to be a vector of URLs.

## Sample Input and Output Data

<!-- - Show how the input data looks like through few sample instances -->
<!-- - Providing a sample output on the sample input to help cross check  -->

The input data looks like this:

``` r
urls <- c("https://www.google.de/search?q=GESIS&client=ubuntu&hs=ixb&sca_esv=dccc38f8e2930152&sca_upv=1")

urls
```

    [1] "https://www.google.de/search?q=GESIS&client=ubuntu&hs=ixb&sca_esv=dccc38f8e2930152&sca_upv=1"

The output data is a data frame of parsed URLs.

## How to Use

<!-- - Providing HowTos on the method for different types of usages -->
<!-- - Describe how the method should be used, including installation, configuration, and any specific instructions for users. -->

Please refer to the [“Introduction to
adaR”](https://gesistsa.github.io/adaR/articles/adaR.html) for a
comprehensive introduction of the package.

The main function of this package is `ada_url_parse()` and it decomposes
a url into its components.

``` r
library(adaR)

urls <- c("https://www.google.de/search?q=GESIS&client=ubuntu&hs=ixb&sca_esv=dccc38f8e2930152&sca_upv=1",
          "https://www.nytimes.com/2024/06/19/world/africa/sudan-darfur-takeaways.html",
          "https://www.sueddeutsche.de/thema/Fu%C3%9Fball-EM")

ada_url_parse(urls)
```

                                                                                              href
    1 https://www.google.de/search?q=GESIS&client=ubuntu&hs=ixb&sca_esv=dccc38f8e2930152&sca_upv=1
    2                  https://www.nytimes.com/2024/06/19/world/africa/sudan-darfur-takeaways.html
    3                                                 https://www.sueddeutsche.de/thema/Fußball-EM
      protocol username password                host            hostname port
    1   https:                         www.google.de       www.google.de     
    2   https:                       www.nytimes.com     www.nytimes.com     
    3   https:                   www.sueddeutsche.de www.sueddeutsche.de     
                                                  pathname
    1                                              /search
    2 /2024/06/19/world/africa/sudan-darfur-takeaways.html
    3                                    /thema/Fußball-EM
                                                                search hash
    1 ?q=GESIS&client=ubuntu&hs=ixb&sca_esv=dccc38f8e2930152&sca_upv=1     
    2                                                                      
    3                                                                      

## Contact Details

Maintainer: David Schoch <david@schochastics.net>

Issue Tracker: <https://github.com/gesistsa/adaR/issues>

<!-- ## Publication -->
<!-- - Include information on publications or articles related to the method, if applicable. -->
<!-- ## Acknowledgements -->
<!-- - Acknowledgements if any -->
<!-- ## Disclaimer -->
<!-- - Add any disclaimers, legal notices, or usage restrictions for the method, if necessary. -->
