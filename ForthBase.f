
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
 			4 /mod swap if 1+ then 4 * 	\ since VFX aligns the dictionary on longwords
 		loop ( addr')
 		count
;
	
: +" '"' parse $,	;					\ lay a counted string in the dictionary

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

CODE twist ( x1-x2-x3-x4 -- x4-x3-x2-x1)
\ reverse the endian of a 4 byte integer   
    BSWAP EBX
    NEXT,
END-CODE

CODE twist2 ( x1-x2 -- x2-x1)
\ reverse the endian of a 2 byte integer
    ROR BX, 8
    NEXT,
END-CODE

\ strings *********************************************************************

: /string ( caddr n m --)
\ VFX does not check for 0 length strings
    2dup >= if
        dup >R -
        swap R> + swap
    else
        drop
    then
;

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
	256 R> - allot			\ reserve the full space for a counted string
does> ( -- c-addr n)
 	count
;

: $-> ( c-addr n <NAME>)
\ revise a string value created with $value
state @ 
    if
    \ compiling mode
        ' >BODY
        postpone literal    \ postpone to execute when $-> is compiled because literal is immediate
        postpone $!         \ postpone to execute when $-> is executed
    else
   \ interpreting mode
	    ' ( <NAME>) >BODY	( c-addr n pfa)	\ will abort if <NAME> is not in the dictionary
	    $!					\ replace the string
	then
; immediate

: $+> ( c-addr n <NAME>)
\ append in a string value created with $value
\ length check to total 256 bytes must be handled by the user
state @ 
    if
    \ compiling mode
        ' >BODY             ( c-addr n pfa)
        postpone literal    \ postpone to execute when $-> is compiled because literal is immediate
        postpone 2>R postpone 2R@ postpone dup postpone c@ postpone + postpone 1+ 
        postpone swap postpone move postpone 2R> postpone c+!
    else
   \ interpreting mode
	    ' ( <NAME>) >BODY   ( c-addr n pfa)	\ will abort if <NAME> is not in the dictionary
	    2>R                 ( c-addr R: n pfa)
	    2R@ dup c@ + 1+     ( c-addr n dest R: n pfa)
	    swap move            \ append to the string
	    2R> c+!             ( n pfa R:n pfa)
	then
; immediate

\ compute a hash h1 by hashing x1 and h0
\ 	borrowed from simple-tester and used in scanning a .wcs file
: hash ( x1 h0 -- h1)
	31 * swap 13 + xor
;	
	
\ hash a string to a single value on stack
: hash$ ( c-addr u -- h)
	swap 2dup + swap ( u end+1 start)
	?do											\ Let h0 = u
		i c@ ( h_i x) swap hash ( h_j) 	\ j = i + 1
	loop
;

: toInteger ( caddr u -- n)
\ convert a string to an integer
    isInteger? case
        0 of 0      endof       \ failure as zero
        2 of nip    endof       \ a double number drops the high cell
    endcase                     \ end case consumes '1' and leaves the number
;
     