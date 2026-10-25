\ Registry lookup, dependency loading, one-time loading, and unknown failure.

NEED simple-tester

: library-loaded? ( caddr u -- flag )
\ Inspect a known registry flag without loading it.
    library-registry search-wordlist
    dup 0= if
        drop 1 Tfailures +! cr ." Missing test registry entry" cr 0 exit
    then
    drop >body @
;

get-current
library-registry set-current
get-order library-registry swap 1+ set-order
: load.TestWord1 ( -- )
\ Load the fixture that requests TestWord2.
    s" %libdir%\ForthBase\libraries\Test1.f" included
;
' load.TestWord1 library-loader TestWord1
: load.TestWord2 ( -- )
\ Load the second dependency fixture.
    s" %libdir%\ForthBase\libraries\Test2.f" included
;
' load.TestWord2 library-loader TestWord2
previous
set-current

Tstart

T{ s" TestWord1" library-loaded? }T 0 ==
T{ s" TestWord2" library-loaded? }T 0 ==

NEED TestWord1

T{ s" TestWord1" library-loaded? }T -1 ==
T{ s" TestWord2" library-loaded? }T -1 ==

NEED TestWord1

T{ s" TestWord1" library-loaded? }T -1 ==
T{ s" ThisLibraryDoesNotExist" need-library }T ==
T{ s" forth-map" need-library }T ==

Tend
