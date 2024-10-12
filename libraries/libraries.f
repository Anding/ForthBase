\ system dependent implemention of UHO's NEED word

have libraries 0= [IF]
create libraries

\ UNITS uncomment the below to use UHO's UNITS
\ include "%idir%\units.f"
\ ... or take the null implementation
[defined] end-unit 0= [IF] 
: unit ( <name> -- unit-sys ) CREATE ;
: internal ( unit-sys1 -- unit-sys2 ) ;
: external ( unit-sys1 -- unit-sys2 ) ;
: end-unit ( unit-sys -- ) ;
[THEN]

\ set the  root directory of the library on the local machine
 TEXTMACRO: libdir
 include "%idir%\local.f"
 
\ libname will hold the name of the library requested by NEED
\   an alternative would be to leave ( caddr u) on the stack but possibly more robust to allocate specific storage
 create libname
 256 allot

: need ( <name> --)
\ include the library <name> or do nothing if it has already been included
	BL PARSE-WORD 		  ( caddr u)
	2dup search-context ( caddr u flag)
	if
		drop 2drop
	else
		libname place
		s" %libdir%\ForthBase\libraries\manifest.f" included
	then
;

[THEN]
		
		

