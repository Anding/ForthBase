\ Registry lookup, dependency loading, one-time loading, and unknown failure.

NEED simple-tester

: library-loaded? ( caddr u -- flag )
    library-registry search-wordlist
    dup 0= abort" Missing test registry entry"
    drop >body @
;

: request-unknown-library ( -- )
    s" ThisLibraryDoesNotExist" need-library
;

0 value retry-loader-attempts

: load.retry-test ( -- )
    retry-loader-attempts 1+ -> retry-loader-attempts
    retry-loader-attempts 1 = if -999 throw then
;

get-current
library-registry set-current
' load.retry-test library-loader RetryTest
set-current

: request-retry-test ( -- )
    s" RetryTest" need-library
;

Tstart

T{ s" TestWord1" library-loaded? }T 0 ==
T{ s" TestWord2" library-loaded? }T 0 ==

NEED TestWord1

T{ s" TestWord1" library-loaded? }T -1 ==
T{ s" TestWord2" library-loaded? }T -1 ==

NEED TestWord1

T{ s" TestWord1" library-loaded? }T -1 ==
T{ ' request-unknown-library catch 0<> }T -1 ==
T{ ' request-retry-test catch }T -999 ==
T{ s" RetryTest" library-loaded? }T 0 ==
T{ request-retry-test }T ==
T{ retry-loader-attempts }T 2 ==
T{ s" RetryTest" library-loaded? }T -1 ==

Tend
bye
