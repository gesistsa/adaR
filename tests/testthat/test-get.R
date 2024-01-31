test_that("all get functions work", {
    url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
    expect_equal(ada_get_href(url), "https://user_1:password_1@example.org:8080/api?q=1#frag")
    expect_equal(ada_get_username(url), "user_1")
    expect_equal(ada_get_password(url), "password_1")
    expect_equal(ada_get_host(url), "example.org:8080")
    expect_equal(ada_get_hostname(url), "example.org")
    expect_equal(ada_get_port(url), "8080")
    expect_equal(ada_get_pathname(url), "/api")
    expect_equal(ada_get_search(url), "?q=1")
    expect_equal(ada_get_hash(url), "#frag")
    expect_equal(ada_get_protocol(url), "https:")
    expect_equal(ada_get_domain(url), "example.org")
    expect_equal(ada_get_basename(url), "https://example.org")
})

get_functions <- c(
    ada_get_href, ada_get_username, ada_get_password, ada_get_host, ada_get_hostname, ada_get_port, ada_get_pathname,
    ada_get_search, ada_get_hash, ada_get_protocol, ada_get_domain, ada_get_basename
)

test_that("invalid urls should return NA, #26", {
    url <- "thisisnoturl"
    for (func in get_functions) {
        expect_error(func(url), NA)
    }
})

test_that("corners #31", {
    for (func in get_functions) {
        expect_error(func(c(NA, NA_character_, "")), NA)
    }
    for (func in get_functions) {
        expect_error(func(NULL), NA)
    }
})

test_that("decode can pass", {
    expect_equal(ada_get_search("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4"), "?q=\u30c9\u30a4\u30c4")
    expect_equal(ada_get_search("https://www.google.co.jp/search?q=\u30c9\u30a4\u30c4", decode = FALSE), "?q=%E3%83%89%E3%82%A4%E3%83%84")
})

test_that("get_domain works", {
    urls <- paste0("http://sub.domain.", setdiff(psl$raw_list, psl$wildcard))
    wild <- paste0("http://sub.domain.domain.", psl$wildcard)
    dom1 <- ada_get_domain(urls)
    dom2 <- ada_get_domain(wild)
    expect_true(all(dom1 == paste0("domain.", setdiff(psl$raw_list, psl$wildcard))))
    expect_true(all(dom2 == paste0("domain.domain.", psl$wildcard)))
})

corner_cases <- c(
    "https://example.com:8080",
    "http://user:password@example.com",
    "http://[2001:0db8:85a3:0000:0000:8a2e:0370:7334]:8080",
    "https://example.com/path/to/resource?query=value&another=thing#fragment",
    "http://sub.sub.example.com",
    "ftp://files.example.com:2121/download/file.txt",
    "http://example.com/path with spaces/and&special=characters?",
    "https://user:pa%40ssword@example.com/path",
    "http://example.com/..//a/b/../c/./d.html",
    "https://example.com:8080/over/under?query=param#and-a-fragment",
    "http://192.168.0.1/path/to/resource",
    "http://3com.com/path/to/resource",
    "http://example.com/%7Eusername/",
    "https://example.com/a?query=value&query=value2",
    "https://example.com/a/b/c/..",
    "ws://websocket.example.com:9000/chat",
    "https://example.com:65535/edge-case-port",
    "file:///home/user/file.txt",
    "http://example.com/a/b/c/%2F%2F",
    "http://example.com/a/../a/../a/../a/",
    "https://example.com/./././a/",
    "http://example.com:8080/a;b?c=d#e",
    "http://@example.com",
    "http://example.com/@test",
    "http://example.com/@@@/a/b",
    "https://example.com:0/",
    "http://example.com/%25path%20with%20encoded%20chars",
    "https://example.com/path?query=%26%3D%3F%23",
    "http://example.com:8080/?query=value#fragment#fragment2",
    "https://example.xn--80akhbyknj4f/path/to/resource",
    "https://example.co.uk/path/to/resource",
    "http://username:pass%23word@example.net",
    "ftp://downloads.example.edu:3030/files/archive.zip",
    "https://example.com:8080/this/is/a/deeply/nested/path/to/a/resource",
    "http://another-example.com/..//test/./demo.html",
    "https://sub2.sub1.example.org:5000/login?user=test#section2",
    "ws://chat.example.biz:5050/livechat",
    "http://192.168.1.100/a/b/c/d",
    "https://secure.example.shop/cart?item=123&quantity=5",
    "http://example.travel/%60%21%40%23%24%25%5E%26*()",
    "https://example.museum/path/to/artifact?search=ancient",
    "ftp://secure-files.example.co:4040/files/document.docx",
    "https://test.example.aero/booking?flight=abc123",
    "http://example.asia/%E2%82%AC%E2%82%AC/path",
    "http://subdomain.example.tel/contact?name=john",
    "ws://game-server.example.jobs:2020/match?id=xyz",
    "http://example.mobi/path/with/mobile/content",
    "https://example.name/family/tree?name=smith",
    "http://192.168.2.2/path?query1=value1&query2=value2",
    "http://example.pro/professional/services",
    "https://example.info/information/page",
    "http://example.int/internal/systems/login",
    "https://example.post/postal/services",
    "http://example.xxx/age/verification",
    "https://example.xxx/another/edge/case/path?with=query#and-fragment"
)

corner_domains <- c(
    "example.com", "example.com", NA, "example.com", "example.com",
    "example.com", "example.com", "example.com", "example.com", "example.com",
    NA, "3com.com", "example.com", "example.com", "example.com",
    "example.com", "example.com", NA, "example.com", "example.com",
    "example.com", "example.com", "example.com", "example.com", "example.com",
    "example.com", "example.com", "example.com", "example.com", NA,
    "example.co.uk", "example.net", "example.edu", "example.com",
    "another-example.com", "example.org", "example.biz", NA, "example.shop",
    "example.travel", "example.museum", "example.co", "example.aero",
    "example.asia", "example.tel", "example.jobs", "example.mobi",
    "example.name", NA, "example.pro", "example.info", "example.int",
    "example.post", "example.xxx", "example.xxx"
)

test_that("domain with path #51", {
    url <- "https://user_1:password_1@example.org:8080/dir/../api?q=1#frag"
    expect_equal(ada_get_domain(url), "example.org")
    expect_equal(ada_get_domain(corner_cases), corner_domains)
})

test_that("href fix #66", {
    url <- "http://xn--53-6kcainf4buoffq.xn--p1ai/doof/junior-programmer.html"
    yes <- ada_get_href(url)
    expect_true(url == yes)
    examples <- c(
        "http://xn--53-6kcainf4buoffq.xn--p1ai/pood/junior-electrical-engineer-jobs-remote.html",
        "http://xn--80abb0biooohbv.xn--p1ai/",
        "http://xn--alicantesueo-khb.com/insomnio",
        "https://normal-url.com/this-path-will-be-fine",
        "http://xn--53-6kcainf4buoffq.xn--p1ai/this-path-will-not-be-fine"
    )
    pathnames <- ada_get_pathname(examples, decode = FALSE)
    result_pathnames <- ada_set_pathname(examples, pathnames, decode = FALSE)
    expect_true(all(examples == result_pathnames))
})
