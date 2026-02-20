# Introduction to adaR

``` r
library(adaR)
```

This vignette gives an overview over `adaR` and url parsing in general.

## A primer on URLs

A URL (Uniform Resource Locator) serves as a reference to a web resource
and has specific components that give information about how the resource
can be fetched. The table below gives an overview of the components of a
valid URL.

| Name                | Description                                                                                   | Example                                     |
|---------------------|-----------------------------------------------------------------------------------------------|---------------------------------------------|
| Protocol            | Indicates the protocol to access the resource.                                                | `http://`                                   |
| Username & Password | Contains authentication info. Separated by a colon and followed by an `@`.                    | `username:password@`                        |
| Hostname            | Refers to the domain name or IP of the server where the resource resides.                     | `example.com` or `192.168.1.1`              |
| Port                | Specifies the technical gate used to access the resources on the server.                      | `:8080`                                     |
| Pathname            | Provides info about the location of the resource on the server, often like a filesystem path. | `/directory/file.html` or `/images/pic.jpg` |
| Query               | Provides additional parameters, often for search queries or data retrieval.                   | `?key1=value1&key2=value2`                  |
| Fragment            | Refers to a specific part of a web resource or document, like an anchor.                      | `#section2`                                 |

A full URL might look something like this:

    https://username:password@example.com:8080/directory/file.html?key1=value1&key2=value2#section2

However, URLs can be as simple as just a scheme and host (e.g.,
`http://example.com`). The presence and specific combination of these
components can vary based on the exact nature and purpose of the URL.

The terms are not necessarily unambiguous and there are further (sub)
terms that need explanation. The `protocol` can also be called `scheme`.
`hostname`+`port` is called `host` in `adaR`. Additionally, the `query`
is referred to as `search` and the `fragment` as `hash` in `adaR`.

Some more relevant subcomponents are given in the following table.

| Term                   | Description                                                                                                                                                                         | Example                        |
|------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------|
| Domain                 | A name that represents an IP address of the server which hosts the website. It’s a human-readable form of an address where web resources can be accessed.                           | `example.com`                  |
| Subdomain              | A subset or a smaller part of the main domain. It’s used to organize and navigate to different sections or services of a website.                                                   | `blog.example.com`             |
| Top-Level Domain (TLD) | The last segment of the domain name. It follows the last dot in the domain name. Indicates the purpose or origin of a domain.                                                       | `.com`, `.net`, `.org`         |
| Public Suffix          | A domain under which Internet users can directly register their own domain names. Public suffixes include TLDs as well as certain subdomains under which domains can be registered. | `co.uk`, `com.au`, `github.io` |

But wait, there is more. The table below gives the definition of several
terms that are of relevance when dealing with URLs and the `adaR`
package.

| Term                 | Description                                                                                                       | Example                                                                              |
|----------------------|-------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------|
| Authority            | Combines user info, hostname, and port. Identifies the party responsible for the resource.                        | `userinfo@host:port`                                                                 |
| Relative URL         | A URL without the scheme and host, often starting with a path. Relative to a base URL.                            | `/path/to/file.html`                                                                 |
| Absolute URL         | A full URL specifying scheme and host.                                                                            | `https://example.com/path/to/file.html`                                              |
| Base URL             | The URL to which relative URLs are resolved.                                                                      | `<base href="https://example.com/page/">`                                            |
| Percent Encoding     | Encodes special characters within a URI using `%` followed by two hexadecimal digits.                             | `Hello%20World` (represents “Hello World”)                                           |
| Punycode             | Represents Unicode characters in domain names using ASCII.                                                        | `xn--80akhbyknj4f` (represents `пример`)                                             |
| URL Canonicalization | Converts a URL into a standardized or normalized format.                                                          | From `https://example.com:443/../a.html` to `https://example.com/a.html`             |
| URL Shortening       | Converts a long URL into a significantly shorter version that redirects to the original URL.                      | Shortening `https://example.com/some-long-path` might give `https://exmpl.co/abc123` |
| URL Slug             | Part of a URL derived from the title of a webpage, usually human-readable and used for SEO.                       | For a post titled “How to Bake”, slug might be `how-to-bake`                         |
| URI vs URL           | URI is a broader category including URLs (locator) and URNs (name). All URLs are URIs, but not all URIs are URLs. | URI: `mailto:john.doe@example.com`, URL: `https://example.com`                       |

## “WHATWG compliant”

The underlying C++ code of `adaR`, [ada-url](https://www.ada-url.com/)
is “WHATWG copliant”.

**Who/What is the WHATWG?**

The Web Hypertext Application Technology Working Group (WHATWG) is a
community of people interested in evolving the web through standards and
tests.

It was founded by individuals of Apple, the Mozilla Foundation, and
Opera Software in 2004, after a W3C workshop. Apple, Mozilla and Opera
were becoming increasingly concerned about the W3C’s direction with
XHTML, lack of interest in HTML, and apparent disregard for the needs of
real-world web developers. So, in response, these organisations set out
with a mission to address these concerns and the Web Hypertext
Application Technology Working Group was born.

**What is the WHATWG working on?**  
The WHATWG’s focus is on standards implementable in web browsers, and
their associated tests. Their existing work can be found
[here](https://spec.whatwg.org/).

The standard of relevance for this package, is the [url
standard](https://url.spec.whatwg.org/). Being “WHATWG compliant” means,
that ada-url follows this url standard.

## Parsing urls

The function
[`ada_url_parse()`](https://schochastics.github.io/adaR/reference/ada_url_parse.md)
decomposes a url into the components shown in the first table.

``` r
ada_url_parse("https://user_1:password_1@example.org:8080/dir/../api?q=1#frag")
#>                                                      href protocol username
#> 1 https://user_1:password_1@example.org:8080/api?q=1#frag   https:   user_1
#>     password             host    hostname port pathname search  hash
#> 1 password_1 example.org:8080 example.org 8080     /api   ?q=1 #frag
```

The function can deal with punycode and percent encoding and does
generally handle all types of edge cases well.

``` r
corner_cases <- c(
    "https://example.com:8080", "http://user:password@example.com",
    "http://[2001:0db8:85a3:0000:0000:8a2e:0370:7334]:8080", "https://example.com/path/to/resource?query=value&another=thing#fragment",
    "http://sub.sub.example.com", "ftp://files.example.com:2121/download/file.txt",
    "http://example.com/path with spaces/and&special=characters?",
    "https://user:pa%40ssword@example.com/path", "http://example.com/..//a/b/../c/./d.html",
    "https://example.com:8080/over/under?query=param#and-a-fragment",
    "http://192.168.0.1/path/to/resource", "http://3com.com/path/to/resource",
    "http://example.com/%7Eusername/", "https://example.com/a?query=value&query=value2",
    "https://example.com/a/b/c/..", "ws://websocket.example.com:9000/chat",
    "https://example.com:65535/edge-case-port", "file:///home/user/file.txt",
    "http://example.com/a/b/c/%2F%2F", "http://example.com/a/../a/../a/../a/",
    "https://example.com/./././a/", "http://example.com:8080/a;b?c=d#e",
    "http://@example.com", "http://example.com/@test", "http://example.com/@@@/a/b",
    "https://example.com:0/", "http://example.com/%25path%20with%20encoded%20chars",
    "https://example.com/path?query=%26%3D%3F%23", "http://example.com:8080/?query=value#fragment#fragment2",
    "https://example.xn--80akhbyknj4f/path/to/resource", "https://example.co.uk/path/to/resource",
    "http://username:pass%23word@example.net", "ftp://downloads.example.edu:3030/files/archive.zip",
    "https://example.com:8080/this/is/a/deeply/nested/path/to/a/resource",
    "http://another-example.com/..//test/./demo.html", "https://sub2.sub1.example.org:5000/login?user=test#section2",
    "ws://chat.example.biz:5050/livechat", "http://192.168.1.100/a/b/c/d",
    "https://secure.example.shop/cart?item=123&quantity=5", "http://example.travel/%60%21%40%23%24%25%5E%26*()",
    "https://example.museum/path/to/artifact?search=ancient", "ftp://secure-files.example.co:4040/files/document.docx",
    "https://test.example.aero/booking?flight=abc123", "http://example.asia/%E2%82%AC%E2%82%AC/path",
    "http://subdomain.example.tel/contact?name=john", "ws://game-server.example.jobs:2020/match?id=xyz",
    "http://example.mobi/path/with/mobile/content", "https://example.name/family/tree?name=smith",
    "http://192.168.2.2/path?query1=value1&query2=value2", "http://example.pro/professional/services",
    "https://example.info/information/page", "http://example.int/internal/systems/login",
    "https://example.post/postal/services", "http://example.xxx/age/verification",
    "https://example.xxx/another/edge/case/path?with=query#and-fragment"
)

df <- ada_url_parse(corner_cases)
df[, -1]
#>    protocol username  password                                host
#> 1    https:                                       example.com:8080
#> 2     http:     user  password                         example.com
#> 3     http:                    [2001:db8:85a3::8a2e:370:7334]:8080
#> 4    https:                                            example.com
#> 5     http:                                    sub.sub.example.com
#> 6      ftp:                                 files.example.com:2121
#> 7     http:                                            example.com
#> 8    https:     user pa@ssword                         example.com
#> 9     http:                                            example.com
#> 10   https:                                       example.com:8080
#> 11    http:                                            192.168.0.1
#> 12    http:                                               3com.com
#> 13    http:                                            example.com
#> 14   https:                                            example.com
#> 15   https:                                            example.com
#> 16      ws:                             websocket.example.com:9000
#> 17   https:                                      example.com:65535
#> 18    file:                                                       
#> 19    http:                                            example.com
#> 20    http:                                            example.com
#> 21   https:                                            example.com
#> 22    http:                                       example.com:8080
#> 23    http:                                            example.com
#> 24    http:                                            example.com
#> 25    http:                                            example.com
#> 26   https:                                          example.com:0
#> 27    http:                                            example.com
#> 28   https:                                            example.com
#> 29    http:                                       example.com:8080
#> 30   https:                                      example.испытание
#> 31   https:                                          example.co.uk
#> 32    http: username pass#word                         example.net
#> 33     ftp:                             downloads.example.edu:3030
#> 34   https:                                       example.com:8080
#> 35    http:                                    another-example.com
#> 36   https:                             sub2.sub1.example.org:5000
#> 37      ws:                                  chat.example.biz:5050
#> 38    http:                                          192.168.1.100
#> 39   https:                                    secure.example.shop
#> 40    http:                                         example.travel
#> 41   https:                                         example.museum
#> 42     ftp:                           secure-files.example.co:4040
#> 43   https:                                      test.example.aero
#> 44    http:                                           example.asia
#> 45    http:                                  subdomain.example.tel
#> 46      ws:                          game-server.example.jobs:2020
#> 47    http:                                           example.mobi
#> 48   https:                                           example.name
#> 49    http:                                            192.168.2.2
#> 50    http:                                            example.pro
#> 51   https:                                           example.info
#> 52    http:                                            example.int
#> 53   https:                                           example.post
#> 54    http:                                            example.xxx
#> 55   https:                                            example.xxx
#>                          hostname  port
#> 1                     example.com  8080
#> 2                     example.com      
#> 3  [2001:db8:85a3::8a2e:370:7334]  8080
#> 4                     example.com      
#> 5             sub.sub.example.com      
#> 6               files.example.com  2121
#> 7                     example.com      
#> 8                     example.com      
#> 9                     example.com      
#> 10                    example.com  8080
#> 11                    192.168.0.1      
#> 12                       3com.com      
#> 13                    example.com      
#> 14                    example.com      
#> 15                    example.com      
#> 16          websocket.example.com  9000
#> 17                    example.com 65535
#> 18                                     
#> 19                    example.com      
#> 20                    example.com      
#> 21                    example.com      
#> 22                    example.com  8080
#> 23                    example.com      
#> 24                    example.com      
#> 25                    example.com      
#> 26                    example.com     0
#> 27                    example.com      
#> 28                    example.com      
#> 29                    example.com  8080
#> 30              example.испытание      
#> 31                  example.co.uk      
#> 32                    example.net      
#> 33          downloads.example.edu  3030
#> 34                    example.com  8080
#> 35            another-example.com      
#> 36          sub2.sub1.example.org  5000
#> 37               chat.example.biz  5050
#> 38                  192.168.1.100      
#> 39            secure.example.shop      
#> 40                 example.travel      
#> 41                 example.museum      
#> 42        secure-files.example.co  4040
#> 43              test.example.aero      
#> 44                   example.asia      
#> 45          subdomain.example.tel      
#> 46       game-server.example.jobs  2020
#> 47                   example.mobi      
#> 48                   example.name      
#> 49                    192.168.2.2      
#> 50                    example.pro      
#> 51                   example.info      
#> 52                    example.int      
#> 53                   example.post      
#> 54                    example.xxx      
#> 55                    example.xxx      
#>                                       pathname                       search
#> 1                                            /                             
#> 2                                            /                             
#> 3                                            /                             
#> 4                            /path/to/resource   ?query=value&another=thing
#> 5                                            /                             
#> 6                           /download/file.txt                             
#> 7     /path with spaces/and&special=characters                             
#> 8                                        /path                             
#> 9                                 //a/c/d.html                             
#> 10                                 /over/under                 ?query=param
#> 11                           /path/to/resource                             
#> 12                           /path/to/resource                             
#> 13                                 /~username/                             
#> 14                                          /a    ?query=value&query=value2
#> 15                                       /a/b/                             
#> 16                                       /chat                             
#> 17                             /edge-case-port                             
#> 18                         /home/user/file.txt                             
#> 19                                   /a/b/c///                             
#> 20                                         /a/                             
#> 21                                         /a/                             
#> 22                                        /a;b                         ?c=d
#> 23                                           /                             
#> 24                                      /@test                             
#> 25                                    /@@@/a/b                             
#> 26                                           /                             
#> 27                   /%path with encoded chars                             
#> 28                                       /path                  ?query=&=?#
#> 29                                           /                 ?query=value
#> 30                           /path/to/resource                             
#> 31                           /path/to/resource                             
#> 32                                           /                             
#> 33                          /files/archive.zip                             
#> 34 /this/is/a/deeply/nested/path/to/a/resource                             
#> 35                            //test/demo.html                             
#> 36                                      /login                   ?user=test
#> 37                                   /livechat                             
#> 38                                    /a/b/c/d                             
#> 39                                       /cart         ?item=123&quantity=5
#> 40                                /`!@#$%^&*()                             
#> 41                           /path/to/artifact              ?search=ancient
#> 42                        /files/document.docx                             
#> 43                                    /booking               ?flight=abc123
#> 44                                    /€€/path                             
#> 45                                    /contact                   ?name=john
#> 46                                      /match                      ?id=xyz
#> 47                   /path/with/mobile/content                             
#> 48                                /family/tree                  ?name=smith
#> 49                                       /path ?query1=value1&query2=value2
#> 50                      /professional/services                             
#> 51                           /information/page                             
#> 52                     /internal/systems/login                             
#> 53                            /postal/services                             
#> 54                           /age/verification                             
#> 55                     /another/edge/case/path                  ?with=query
#>                   hash
#> 1                     
#> 2                     
#> 3                     
#> 4            #fragment
#> 5                     
#> 6                     
#> 7                     
#> 8                     
#> 9                     
#> 10     #and-a-fragment
#> 11                    
#> 12                    
#> 13                    
#> 14                    
#> 15                    
#> 16                    
#> 17                    
#> 18                    
#> 19                    
#> 20                    
#> 21                    
#> 22                  #e
#> 23                    
#> 24                    
#> 25                    
#> 26                    
#> 27                    
#> 28                    
#> 29 #fragment#fragment2
#> 30                    
#> 31                    
#> 32                    
#> 33                    
#> 34                    
#> 35                    
#> 36           #section2
#> 37                    
#> 38                    
#> 39                    
#> 40                    
#> 41                    
#> 42                    
#> 43                    
#> 44                    
#> 45                    
#> 46                    
#> 47                    
#> 48                    
#> 49                    
#> 50                    
#> 51                    
#> 52                    
#> 53                    
#> 54                    
#> 55       #and-fragment
```

[`ada_url_parse()`](https://schochastics.github.io/adaR/reference/ada_url_parse.md)
is the power horse of `adaR` which always returns all components of a
URL. Specific components can be parsed with the `ada_get_*()` set of
functions.

``` r
ada_get_hostname(corner_cases)
#>  [1] "example.com"                    "example.com"                   
#>  [3] "[2001:db8:85a3::8a2e:370:7334]" "example.com"                   
#>  [5] "sub.sub.example.com"            "files.example.com"             
#>  [7] "example.com"                    "example.com"                   
#>  [9] "example.com"                    "example.com"                   
#> [11] "192.168.0.1"                    "3com.com"                      
#> [13] "example.com"                    "example.com"                   
#> [15] "example.com"                    "websocket.example.com"         
#> [17] "example.com"                    ""                              
#> [19] "example.com"                    "example.com"                   
#> [21] "example.com"                    "example.com"                   
#> [23] "example.com"                    "example.com"                   
#> [25] "example.com"                    "example.com"                   
#> [27] "example.com"                    "example.com"                   
#> [29] "example.com"                    "example.испытание"             
#> [31] "example.co.uk"                  "example.net"                   
#> [33] "downloads.example.edu"          "example.com"                   
#> [35] "another-example.com"            "sub2.sub1.example.org"         
#> [37] "chat.example.biz"               "192.168.1.100"                 
#> [39] "secure.example.shop"            "example.travel"                
#> [41] "example.museum"                 "secure-files.example.co"       
#> [43] "test.example.aero"              "example.asia"                  
#> [45] "subdomain.example.tel"          "game-server.example.jobs"      
#> [47] "example.mobi"                   "example.name"                  
#> [49] "192.168.2.2"                    "example.pro"                   
#> [51] "example.info"                   "example.int"                   
#> [53] "example.post"                   "example.xxx"                   
#> [55] "example.xxx"
```

`ada_has_*()` can be used to check if certain components are present or
not.

``` r
ada_has_search(corner_cases)
#>  [1] FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE
#> [13] FALSE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE FALSE FALSE
#> [25] FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE FALSE  TRUE
#> [37] FALSE FALSE  TRUE FALSE  TRUE FALSE  TRUE FALSE  TRUE  TRUE FALSE  TRUE
#> [49]  TRUE FALSE FALSE FALSE FALSE FALSE  TRUE
```

`ada_set_*()` can be used to set specific components of a URL.

``` r
ada_set_hostname("https://example.de/test", "example.com")
#> [1] "https://example.com/test"
```

`ada_clear_*()` can be used to remove certain components.

``` r
url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
ada_clear_port(url)
#> [1] "https://user_1:password_1@example.org/api?q=1#frag"
ada_clear_hash(url)
#> [1] "https://user_1:password_1@example.org:8080/api?q=1"
ada_clear_search(url)
#> [1] "https://user_1:password_1@example.org:8080/api#frag"
```

## Public suffic extraction

The package also implements a public suffix extractor public_suffix(),
based on a lookup of the [Public Suffix
List](https://publicsuffix.org/). Note that from this list, we only
include registry suffixes (e.g., com, co.uk), which are those controlled
by a domain name registry and governed by ICANN. We do not include
“private” suffixes (e.g., blogspot.com) that allow people to register
subdomains. Hence, we use the term domain in the sense of “top domain
under a registry suffix”. See
<https://github.com/google/guava/wiki/InternetDomainNameExplained> for
more details.

``` r
urls <- c(
    "https://subsub.sub.domain.co.uk",
    "https://domain.api.gov.uk",
    "https://thisisnotpart.butthisispartoftheps.kawasaki.jp"
)
public_suffix(urls)
#> [1] "co.uk"                            "gov.uk"                          
#> [3] "butthisispartoftheps.kawasaki.jp"
```

If you are wondering about the last url. The list also contains wildcard
suffixes such as `*.kawasaki.jp` which need to be matched.
