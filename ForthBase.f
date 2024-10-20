 create FORTHbase

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

: twist ( x1-x2-x3-x4 -- x4-x3-x2-x1)
\ reverse the endian of a 4 byte integer
	dup 255 and >r 							\ x1-x2-x3-x4 R:x4
	8 rshift										\    x1-x2-x3 R:x4
	dup 255 and r> 8 lshift or >r			\    x1-x2-x3 R:x4-x3
	8 rshift										\       x1-x2 R:x4-x3
	dup 255 and r> 8 lshift or >r			\       x1-x2 R:x4-x3-x2
	8 rshift										\          x1 R:x4-x3-x2
	255 and r> 8 lshift or					\ x4-x3-x2-x1
;

: twist2 ( x1-x2 -- x2-x1)
\ reverse the endian of a 2 byte integer
	dup 255 and >r 							\       x1-x2 R:x2
	8 rshift										\       	  x1 R:x2
	255 and r> 8 lshift or 					\    	  x2-x1
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

\ secret stack ***************************************************************
\ an additional stack to use sparingly: mainly to replace global variables in reentrant code

create ss.stack 256 allot									\ 64 cells
4 value ss._pointer

: ss.pointer   ( -- addr)
\ current top-of-stack
	ss._pointer ss.stack +
;

: ++ss.pointer ( -- addr)
\ stack fills upwards - pre-increment
	ss._pointer 4 + 255 and dup -> ss._pointer		\ circular buffer without bounds checking
	ss.stack +
;

: ss.pointer-- ( -- addr)
\ stack empties downwards - post-decrement
	ss._pointer dup 4 - 255 and  -> ss._pointer
	ss.stack +
;

: >s ( x -- s:x)
	++ss.pointer !
;

: 2>s ( x y -- s:x y)
	swap >s >s
;

: s> ( s:x -- x)
	ss.pointer-- @
;

: 2s> ( s: x y -- x y)
	s> s> swap
;

: s@ ( s:x -- x s:x)
	ss.pointer @
;






	