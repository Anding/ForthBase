\ FORTHbase.f
\ Andrew Read, 9 June 2023

\ documentation ****************************************************************

synonym :rem \  
synonym :alias synonym


\ formatting *******************************************************************

: TAB
	9 emit
;


\ data structures and memory ****************************************************

\ define an ENUM data-structure with similar syntax to a STRUCTURE
: BEGIN-ENUM 0 ;
: END-ENUM drop ;
: +ENUM dup 1+ swap CONSTANT ;

: ($CONSTANT) ( x caddr u)
\ create a constant with a name supplied on the stack
	($create) 
		, 
	does> 
 		@ 
;

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


\ strings *********************************************************************

:rem $, ( caddr u --)
\ copy a string into the dictionary at HERE and ALLOT the necessary space

:alias $! place ( caddr u addr --) 
\ store the counted string referenced on the stack as a counted string at addr

:alias $@ count ( addr -- caddr u) 
\ place a reference on the stack to the counted string at addr

: STRING create ( c-addr n <name> --) 
\ define a constant string
	$,
 does> ( -- c-addr n)
 	$@
 ;
	




	