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

: need ( <name> -- caddr u | )
\ include the library <name> or do nothing if it has already been included
	BL PARSE-WORD 		  ( caddr u)
	2dup search-context ( caddr u xt +/-1 | caddr u 0)
	if
		drop 2drop
	else
		s" %libdir%\ForthBase\libraries\manifest.f" included
	then
;

[THEN]
		
		

