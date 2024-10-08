\ system dependent implemention of UHO's NEED word

\ uncomment the below to use UHO's UNITS
\ include "%idir%\units.f"
\ ... or take the null implementation
[defined] end-unit 0= [IF] 
: unit ( <name> -- unit-sys ) CREATE ;
: internal ( unit-sys1 -- unit-sys2 ) ;
: external ( unit-sys1 -- unit-sys2 ) ;
: end-unit ( unit-sys -- ) ;
[THEN]

\ use the forth-map data structure
TEXTMACRO: libdir
 c" e:\coding" SETMACRO libdir
 
 create libname
 256 allot

: need ( <name> --)
	BL PARSE-WORD 	( caddr u)
	2dup search-context ( caddr u flag)
	if
		2drop drop
	else
		libname place
		s" %libdir%\ForthBase\libraries\globalManifest.f" included
	then
;
		
		

