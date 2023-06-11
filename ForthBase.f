\ FORTHbase.f
\ Andrew Read, 9 June 2023

\ data structures **************************************************************

\ define an ENUM data-structure with similar syntax to a STRUCTURE
: BEGIN-ENUM 0 ;
: END-ENUM drop ;
: +ENUM dup 1+ swap CONSTANT ;

\ memory management ************************************************************

: BUFFER	 											
\ create a named buffer of n bytes
\ VFX's word, BUFFER:, has failed with large sizes
	create	( n <name> --)
		allocate ( addr ior) throw ( addr) ,
	does>		( -- addr)
		@
;

: DEBUFFER ( addr --)
\ free a buffer created with the word buffer
	free throw
;

: SHARED
\ share a VARIABLE or CONSTANT between source files
\ 
\ source1.f
\ 		SHARED VARIABLE x  \ create variable x the first time
\ 
\ source2.f
\ 		SHARED VARIBALE x  \ do nothing the 2nd time, x is not redefined
\ 
	save-input					( xn...x1 n) 			\ save the state of the input buffer
	BL parse-word 2drop 									\ skip the defining word
	BL parse-word 				( ... c-addr n) 		\ find the name
	search-context if			( ... 0 | xt -1)
		drop ndrop				\ name is already in the dictionary - do nothing
	else
		restore-input drop	\ otherwise restore the input buffer to just before the defiining word
	then
;

\ synomyns *********************************************************************

: $! ( caddr u addr --) \ string-store
\ store the counted string referenced on the stack as a counted string at addr
	place
;

: $@ ( addr -- caddr u) \ string-fetch
\ place a reference on the stack to the counted string at addr
	count
;

	