# Benchmarking adaR

``` r
library(adaR)
library(urltools)
```

## Setup

We will use several different datasets provided by
[ada-url](https://github.com/ada-url/url-various-datasets) and by the
[webtrackR](https://github.com/schochastics/webtrackR) package.

``` r
top100 <- readLines("https://raw.githubusercontent.com/ada-url/url-various-datasets/main/top100/top100.txt")
node_files <- readLines("https://raw.githubusercontent.com/ada-url/url-various-datasets/main/files/node_files.txt")
linux_files <- readLines("https://raw.githubusercontent.com/ada-url/url-various-datasets/main/files/linux_files.txt")
wiki <- readLines("https://raw.githubusercontent.com/ada-url/url-various-datasets/main/wikipedia/wikipedia_100k.txt")
corner <- readLines("corner.txt")
data("testdt_tracking", package = "webtrackR")
```

- `node_files.txt`: all source files from a given Node.js snapshot as
  URLs (43415 URLs)
- `linux_files.txt`: all files from a Linux systems as URLs (169312
  URLs).
- `wikipedia_100k.txt`: 100k URLs from a snapshot of all Wikipedia
  articles as URLs (March 6th 2023)
- `top100.txt`: crawl of the top visited 100 websites and extracted
  unique URLs (98000 URLs)
- `corner.txt`: a small set of fictional urls which represent corner
  cases

We benchmark `adaR` with the R package
[`urltools`](https://github.com/Ironholds/urltools), the standard
package for this job.

## Parsing urls: correctness

Let us first compare the standard output of the respective url parsing
functions.

``` r
urltools::url_parse("http://sub.domain.co.uk/path/to/place")
```

      scheme           domain port          path parameter fragment
    1   http sub.domain.co.uk <NA> path/to/place      <NA>     <NA>

``` r
ada_url_parse("http://sub.domain.co.uk/path/to/place")
```

                                       href protocol username password
    1 http://sub.domain.co.uk/path/to/place    http:                  
                  host         hostname port       pathname search hash
    1 sub.domain.co.uk sub.domain.co.uk      /path/to/place            

For fairly regular looking urls, they do provide the same output,
however with a slighlty different naming scheme. The introductory
vignette `vignette("adaR")` gives an explanation of the meaning of each
term.

Let us know look at a more complex example.

``` r
urltools::url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
```

      scheme      domain port       path parameter fragment
    1  https example.org 8080 dir/../api       q=1     frag

``` r
ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
```

                                                         href protocol username
    1 https://user_1:password_1@example.org:8080/api?q=1#frag   https:   user_1
        password             host    hostname port pathname search  hash
    1 password_1 example.org:8080 example.org 8080     /api   ?q=1 #frag

`urltools` does not parse for username and password. Additionally, it
returns the path “as-is”, while ada returns the
[WHATWG](https://url.spec.whatwg.org/#url-class) conform path if it
contains double-dots.

The must striking difference between the two packages occurs for URLs
tha contain the “@” symbol, which is quite common for URLs of social
media posts.

``` r
urltools::url_parse("https://fosstodon.org/@schochastics/111105280215225729")
```

      scheme       domain port               path parameter fragment
    1  https schochastics <NA> 111105280215225729      <NA>     <NA>

``` r
ada_url_parse("https://fosstodon.org/@schochastics/111105280215225729")[,-1]
```

      protocol username password          host      hostname port
    1   https:                   fosstodon.org fosstodon.org     
                               pathname search hash
    1 /@schochastics/111105280215225729            

`urltool` does not parse the links correctly, while `adaR` does catch
this special case. To answer the question of differences between the
packages a bit more broadly, we run the two parsers on the benchmark
URLs described above.

First, in terms of when they fail to parse anything, independent if the
output is correct or not.

``` r
parse_na <- function(urls) {
    ada <- ada_url_parse(urls)
    utl <- urltools::url_parse(urls)
    ada_na_lst <- list(urls[is.na(ada$hostname)])
    utl_na_lst <- list(urls[is.na(utl$domain)])
    tibble::tibble(
        ada_na_abs = sum(is.na(ada$hostname)),
        utl_na_abs = sum(is.na(utl$domain)),
        ada_na_frac = ada_na_abs / length(urls),
        utl_na_frac = utl_na_abs / length(urls),
        ada_na_lst = ada_na_lst,
        utl_na_lst = utl_na_lst
    )
}

res <- purrr::map_dfr(list(top100, node_files, linux_files, wiki, corner, testdt_tracking$url), parse_na)
res[["dataset"]] <- c("top100", "node_files", "linux_files", "wiki", "corner", "webtrack")
res
```

    # A tibble: 6 × 7
      ada_na_abs utl_na_abs ada_na_frac utl_na_frac ada_na_lst utl_na_lst dataset   
           <int>      <int>       <dbl>       <dbl> <list>     <list>     <chr>     
    1         32          8    0.000320   0.0000800 <chr [32]> <chr [8]>  top100    
    2          0          0    0          0         <chr [0]>  <chr [0]>  node_files
    3          0     169312    0          1         <chr [0]>  <chr>      linux_fil…
    4         13          0    0.00013    0         <chr [13]> <chr [0]>  wiki      
    5          0          1    0          0.0182    <chr [0]>  <chr [1]>  corner    
    6          0         29    0          0.000585  <chr [0]>  <chr [29]> webtrack  

`urltools` fails to parse all of `linux_files`, which look like this

``` r
linux_files[12345]
```

    [1] "file:///var/lib/dpkg/info/ruby2.7-doc.md5sums"

adaR does parse them correctly.

``` r
ada_url_parse(linux_files[12345])
```

                                               href protocol username password host
    1 file:///var/lib/dpkg/info/ruby2.7-doc.md5sums    file:                       
      hostname port                               pathname search hash
    1               /var/lib/dpkg/info/ruby2.7-doc.md5sums            

What do the 32 failures of the `top100` dataset look like?

``` r
res$ada_na_lst[[1]]
```

     [1] "Researchers from the Vera Institute of Justice, with support from Google.org Fellows, collected data on the number of people in local jails at midyear in both 2018 and 2019 to provide timely information on how incarceration is changing in the United States. This report fills a gap u"                                                                                                                                                                                                                                                                                                             
     [2] "http://rupaul%27s%20drag%20race%20all%20stars%207%20winners%20cast%20on%20this%20season%27s/"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
     [3] "http://application%20guidelines%20for%20registration%20of%20vetted%20mcs%20experts%20then%20international%20mcs%20network%20is%20dedicated%20to%20maintaining%20an%20updated%20register%20of%20vetted%20mcs%20experts.%20in%20order%20to%20reinvigorate%20the%202012%20register%2C%20the%20following%20terms%20detail%20the%20rules%20and%20procedures%20for%20interested%20individuals%20to%20apply%20for%20listing%20as%20network%20vetted%20mcs%20experts.%20the%20network%20invites%20you%20to%20submit%20an%20application%20in%20accordance%20with%20the%20rules%20set%20out%20in%20this%20notice./"
     [4] "http://Learn More"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
     [5] ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
     [6] ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
     [7] "At the Vera Institute of Justice, we envision a society that respects the dignity of every person and safeguards justice for all—and our workplace reflects that same vision."                                                                                                                                                                                                                                                                                                                                                                                                                           
     [8] ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
     [9] ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    [10] ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    [11] "Why Vera?"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    [12] "We are agents of change, fighting for transformation of the criminal legal and immigration systems during a pivotal moment in American history. At the Vera Inst"                                                                                                                                                                                                                                                                                                                                                                                                                                        
    [13] "Vera Institute of Justice (Vera) researchers collected year-end 2017 and 2018 prison population data directly from state departments of corrections and the federal Bureau of Prisons (BOP) on the number of people in state and federal prisons on December 31, 2018, in order to provide "                                                                                                                                                                                                                                                                                                             
    [14] "http://In addition, this research has informed the development of the new IDA Vitality Index"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    [15] ""                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
    [16] "http://A source close to the production of Chicago Fire confirmed to PEOPLE that star Taylor Kinney is taking a leave of absence from the series. Deadline was the first to report the news."                                                                                                                                                                                                                                                                                                                                                                                                            
    [17] "http://Poland, Czech Republic, and Bulgaria have taken in the highest number of refugees"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    [18] "http://Netflix's Our Great National Parks"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
    [19] "http://The Most Expensive (and Explosive) Celebrity Divorces of All Time"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
    [20] "http://Screen Actors Guild Awards"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    [21] "http://Cardi B Appears in N.Y.C. Court as She's Given Deadline Extension to Finish Community Service"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    [22] "http://Aria Vera Floral Design"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    [23] "http://In 2006, Toews was the No. 3 pick in the NHL draft."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
    [24] "http://Jessica Alba Celebrates Daughter Honor's Graduation: 'Off to High School, Baby Girl!'"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
    [25] "http://venus%20williams%20designed%20her%20latest%20athletic%20wear%20collection%20to%20%27bring%20energy%20to%20your%20workout%27/"                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    [26] "http://RuPaul's Drag Race All Stars 7 Winners Cast on This Season's"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
    [27] "http://happy thanksgiving from us"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    [28] "http://seeking%20information%20about%20the%20government's%20use%20and%20interpretation%20of%20Patriot%20Act%20Section%20215"                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
    [29] "/"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
    [30] "https%3A%2F%2Fbit.ly%2F32G1ciy"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
    [31] "&url=https://www.fao.org/europe/en"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    [32] "&url=https://www.fao.org/europe/en"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      

These are clearly invalid urls and thus should not be parsed into
anything else then `NA`. Before parsing `adaR` always checks if a URL is
WHATWG conform. If it is not, `NA` is returned. `urltools` does not
provide such a test and tries its best to parse any input.

A downside of this strict rule is that URLS without a protocol are not
parsed.

``` r
ada_url_parse("domain.de/path/to/file") 
```

                        href protocol username password host hostname port pathname
    1 domain.de/path/to/file     <NA>     <NA>     <NA> <NA>     <NA> <NA>     <NA>
      search hash
    1   <NA> <NA>

One can argue if this is either a [bug or a
feature](https://github.com/schochastics/adaR/issues/36), but for the
time being, we remain conform with the underlying c++ library in this
case.

As a second test, we look at the urls that where parsed differently by
urltools and adaR

``` r
diff <- function(urls) {
    ada <- ada_url_parse(urls)
    utl <- urltools::url_parse(urls)
    idx <- which(ada$hostname != utl$domain)
    tibble::tibble(url = urls[idx],ada = ada$hostname[idx], urltools = utl$domain[idx])
}

res2 <- purrr::map_dfr(list(top100, wiki, corner, testdt_tracking$url), diff)
nrow(res2)
```

    [1] 963

``` r
res2
```

    # A tibble: 963 × 3
       url                                                            ada   urltools
       <chr>                                                          <chr> <chr>   
     1 https://www.tiktok.com/@people                                 www.… people  
     2 https://flipboard.com/@people                                  flip… people  
     3 https://medium.com/@circulareconomy                            medi… circula…
     4 https://tiktok.com/@ellenmacarthurfoundation                   tikt… ellenma…
     5 https://mastodon.social/@Mozilla                               mast… mozilla 
     6 https://www.tiktok.com/@mozilla                                www.… mozilla 
     7 https://www.tiktok.com/@goodwillintl                           www.… goodwil…
     8 https://medium.com/@codeorg/cs-helps-students-outperform-in-s… medi… codeorg 
     9 https://medium.com/@codeorg/code-org-resourceful-teachers-hig… medi… codeorg 
    10 https://medium.com/@codeorg/study-computer-science-students-m… medi… codeorg 
    # ℹ 953 more rows

``` r
table(res2$ada)
```


                                                          
                                                      215 
                           [2001:db8:85a3::8a2e:370:7334] 
                                                        1 
                                               abs.gov.au 
                                                        1 
                                     blog.kaporcenter.org 
                                                       12 
                                      careers.walmart.com 
                                                        1 
                                          docs.github.com 
                                                        3 
                                              example.com 
                                                        2 
                                        example.испытание 
                                                        1 
                                            flipboard.com 
                                                       10 
    hqepc&list=plkdbwuz2pblxz1h9g8snvlu6ug5hq2x-u&index=2 
                                                        1 
                                              journa.host 
                                                        1 
                                           mastodon.green 
                                                        1 
                                          mastodon.social 
                                                        1 
                                               medium.com 
                                                      444 
                                        scamawareness.org 
                                                        1 
                                    social.opensource.org 
                                                        1 
                                  support.theguardian.com 
                                                        1 
                                               tiktok.com 
                                                        2 
                                          truthsocial.com 
                                                        1 
                                              twitter.com 
                                                        3 
                                               w3c.social 
                                                        1 
                                          web.archive.org 
                                                        1 
                                         www.7‐eleven.com 
                                                        2 
                                              www.bsa.org 
                                                        1 
                                           www.flickr.com 
                                                        5 
                                           www.google.com 
                                                       12 
                                              www.ilo.org 
                                                        1 
                                           www.tiktok.com 
                                                      228 
                                          www.twitter.com 
                                                        1 
                                             www.wqln.org 
                                                        1 
                                          www.youtube.com 
                                                        7 

In most of these cases, the reason why the two yield different results
is because the URL does contain an “@” symbol from social media posts
which urltools is not able to pick up.

## Parsing urls: runtime

``` r
bench::mark(
    urltools = url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"),
    ada = ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag", decode = FALSE), iterations = 1000, check = FALSE
)
```

    # A tibble: 2 × 6
      expression      min   median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    1 urltools      338µs    384µs     2411.    2.49KB    12.1 
    2 ada           516µs    580µs     1612.    2.49KB     9.73

``` r
bench::mark(
    urltools = url_parse(top100),
    ada = ada_url_parse(top100, decode = FALSE), iterations = 1, check = FALSE
)
```

    Warning: Some expressions had a GC in every iteration; so filtering is
    disabled.

    # A tibble: 2 × 6
      expression      min   median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    1 urltools      230ms    230ms      4.34    6.08MB     4.34
    2 ada           245ms    245ms      4.09    9.18MB     0   

In terms of runtime, both are almost indiscernible. The advantage of
adaR is its added accuracy.

## Public Suffic extraction

Here we compare `adaR` with `urltools` and additionally with
[`psl`](https://github.com/hrbrmstr/psl), a wrapper for a C library to
extract public suffix.

``` r
bench::mark(
    urltools = suffix_extract("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"),
    ada = public_suffix("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"),
    psl = psl::public_suffix("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"),iterations = 1000, check = FALSE
)
```

    # A tibble: 3 × 6
      expression      min   median `itr/sec` mem_alloc `gc/sec`
      <bch:expr> <bch:tm> <bch:tm>     <dbl> <bch:byt>    <dbl>
    1 urltools   368.29µs 448.09µs     2047.     103KB     10.3
    2 ada         18.87µs  20.47µs    45943.    35.9KB      0  
    3 psl          3.85µs   5.62µs   163250.    17.6KB    163. 

(*This comparison is not fair for `urltools` since the function
`suffix_extract` does more than just extracting the public suffix.*)

psl is clearly the fastest, which is not surprising given that it is
based on extremely efficient C code. Our implementation is quite similar
to how urltools handles suffixes and is not too far behind psl.

So, while psl is clearly favored in terms of runtime, it comes with the
drawback that it is only available via GitHub (which is not optimal if
you want to depend on it) and has a system requirement that (according
to GitHub) is not available on Windows. If those two things do not
matter to you and you need to process an enormous amount of URLs, then
you should use psl.

## Summary

adaR complements existing packages quite well. It is for most taks
competitive in terms of runtime but comes with the added value of
complying to URL standards which can be important in certain situations.
