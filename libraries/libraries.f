\ VFX implementation of UHO's NEED word.

[DEFINED] libraries 0= [IF]
\ This public marker prevents startup.f or nested includes from constructing a
\ second registry in the same Forth session.
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
\ Loader implementation words and public library names live in this private
\ wordlist. It is exposed as a constant for diagnostics but is not left in the
\ normal search order.

: run-library-loader { body | ior -- }
\ Mark before execution to break dependency cycles, but restore the unloaded
\ state when an include throws so an interactive session can retry.
    body @ if exit then
    -1 body !
    body cell+ @ catch -> ior
    ior if
        0 body !
        ior throw
    then
;

: library-loader ( loader-xt "<name>" -- )
\ Define a registry entry with body layout:
\   cell 0: loaded flag
\   cell 1: loader execution token
\ run-library-loader sets the flag before the action to break cycles and clears
\ it if the action throws.
    create 0 , ,
    does> run-library-loader
;

: need-library ( caddr u -- )
\ First preserve the historical convention that a visible word named for a
\ library means it is already available. Otherwise resolve the name with one
\ search of the private registry and execute its stateful loader.
    2dup search-context if
        drop 2drop
        exit
    then
    library-registry search-wordlist
    dup 0= abort" Unknown library"
    drop execute
;

: need ( "<name>" -- )
\ Source-level convenience form. Runtime code with a computed name should call
\ need-library directly with caddr/u.
    BL parse-word need-library
;

\ Save the caller's compilation wordlist. The manifest is compiled into the
\ private registry and that wordlist is temporarily searchable so each
\ registration line can tick its preceding load.<name> action. Restore both
\ search and compilation state afterward.
get-current
library-registry set-current
get-order library-registry swap 1+ set-order
include "%libdir%\ForthBase\libraries\manifest.f"
previous
set-current

[THEN]
		
		
