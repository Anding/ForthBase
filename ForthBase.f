\ FORTHbase.f
\ Andrew Read, 9 June 2023

\ data structures **************************************************************

\ define an ENUM data-structure with similar syntax to a STRUCTURE
: BEGIN-ENUM 0 ;
: END-ENUM drop ;
: +ENUM dup 1+ swap CONSTANT ;


\ arithmetic *******************************************************************

: downmod ( n M -- n')
\  map equivalence class, n, of the integers modulo M, according to:
\ 	0, 1, 2, ..., m,   ..., M-1  
\  0, 1, 2, ..., m-M, ..., -1
\  where m = [{M+1}/2]
\
\ Example 1: MOD 5
\  	0, 1, 2,  3,  4
\  	0, 1, 2, -2, -1
\
\ Example 2: MOD 6
\  	0, 1, 2,  3,  4,  5
\  	0, 1, 2, -3, -2, -1	

	over over			( n M n M)
	1+ 2/					( n M n m)
	>= IF - ELSE drop THEN
;

: upmod ( n M -- n')
\ the inverse of downmod

	over					( n M n)
	0< IF + ELSE drop THEN
;


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

: ($CONSTANT) ( x caddr u)
\ create a constant with a name supplied on the stack (rather than from the input stream)
	($create) 
		, 
	does> 
 		@ 
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

: TAB
	9 emit
;

	