## Update from 0.3.5 to 0.4.0

* privately registered suffixes (e.g. `github.io`, `blogspot.com`) are now
  included in the public suffix list lookup, with a new `icann_only` argument
  to restore the previous behaviour
* fixed handling of the exception (`!`) rules of the public suffix list
* fixed `url_decode2()` on malformed percent-escapes, which previously read
  uninitialised memory and truncated the result
* long running C++ loops are now interruptible

## Reverse dependencies

`webtrackR` is the only reverse dependency and is maintained by me. It was
checked against this version and its test suite passes unchanged. The new
suffix handling does change the extracted domain for a small number of URLs
(9 of 22817 unique URLs in its own test data), which is the intended effect of
the change.
