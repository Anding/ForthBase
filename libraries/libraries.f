\ system dependent implemention of UHO's NEED word

[DEFINED] libraries 0= [IF]
create libraries

\ UNITS uncomment the below to use UHO's UNITS
\ include "%idir%\units.f"
\ ... or take the null implementation
[DEFINED] end-unit 0= [IF] 
: unit ( <name> -- unit-sys ) CREATE ;
: internal ( unit-sys1 -- unit-sys2 ) ;
: external ( unit-sys1 -- unit-sys2 ) ;
: end-unit ( unit-sys -- ) ;
[THEN]

\ set the  root directory of the library on the local machine
 TEXTMACRO: libdir
 include "%idir%\local.f"

wordlist constant library-registry

: library-loader ( loader-xt "<name>" -- )
\ A registry entry owns both its load action and its one-time loaded flag.
    create 0 , ,
    does> dup @ if
        drop
    else
        -1 over !
        cell+ @ execute
    then
;

: need-library ( caddr u -- )
\ Existing public words still count as already loaded for compatibility.
    2dup search-context if
        drop 2drop
        exit
    then
    library-registry search-wordlist
    dup 0= abort" Unknown library"
    drop execute
;

: need ( "<name>" -- )
    BL parse-word need-library
;

get-current
library-registry set-current
get-order library-registry swap 1+ set-order
include "%libdir%\ForthBase\libraries\manifest.f"
previous
set-current

[THEN]
		
		
