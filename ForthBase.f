\ FORTHbase.f

\ documentation ****************************************************************

synonym :rem \  
synonym :alias synonym


\ formatting and output *********************************************************

: TAB
	9 emit
;

: (.OnOff) ( n -- caadr u)
\ an output format
	if s" ON" else s" OFF" then
;
	
: (ud.)
\ output an unsigned double padded to 16 characters
	<# # # # # # # # # # # # # # # # # #>
;

\ data structures and memory ****************************************************

\ define an ENUM data-structure with similar syntax to a STRUCTURE
: BEGIN-ENUM 0 ;
: END-ENUM drop ;
: +ENUM dup 1+ swap CONSTANT ;

\ define a ENUMerated strings data-structure to complement ENUM
\ usage: see ForthBase_test1.f
: BEGIN-ENUMS
	CREATE ( <NAME> --)
	DOES> ( n -- c addr u)
 		( n pfa) swap 0 ?do ( pfa) 
 			dup c@ + 1+ 
 			4 / 1+ 4 * 	\ since VFX aligns the dictionary on longwords
 		loop ( addr')
 		count
;
	
: +" '"' parse $,	;			\ lay a counted string in the dictionary

: END-ENUMS ;


: ($CONSTANT) ( x caddr u)
\ create a constant with a name supplied on the stack
	($create) 
		, 
	does> 
 		@ 
;

: BUFFER: 											
\ create a named buffer of n bytes
\ overwrite VFX's word to use allocate
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
\ copy a string into the dictionary in counted string format

:alias $! place ( caddr u addr --) 
\ copy a string into memory at addr in counted string format

:alias $@ count ( addr -- caddr u) 
\ reference on the stack the counted string at addr

: $value create ( c-addr n <name> --) 
\ define a string value
	dup >R
	$,						
	255 R> - allot			\ reserve the full space, the string is 
does> ( -- c-addr n)
 	count
;

: $-> ( c-addr n <NAME>)
\ revise a string value created with $value
	' >BODY				( c-addr n pfa)	\ will abort if <NAME> is not in the dictionary
	$!												\ replace the value
;








	