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

Tstart

T{ s" TestWord1" library-loaded? }T 0 ==
T{ s" TestWord2" library-loaded? }T 0 ==

NEED TestWord1

T{ s" TestWord1" library-loaded? }T -1 ==
T{ s" TestWord2" library-loaded? }T -1 ==

NEED TestWord1

T{ s" TestWord1" library-loaded? }T -1 ==
T{ ' request-unknown-library catch 0<> }T -1 ==

Tend
bye
