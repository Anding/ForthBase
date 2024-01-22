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

: SHARED
\ share a VARIABLE between source files
\ 	further work... extend to CONSTANT by dropping the integer from the stack
\ source1.f
\ 		SHARED VARIABLE x  \ create variable x the first time
\ 
\ source2.f
\ 		SHARED VARIABLE x  \ do nothing the 2nd time, x is not redefined
\ 
	save-input					( xn...x1 n) 			\ save the state of the input buffer
	BL parse-word 2drop 									\ skip the defining word
	BL parse-word 				( ... c-addr n) 		\ find the name
	search-context if			( ... 0 | xt -1)		\ ? can this be done with [UNDEFINED]
		drop ndrop				\ name is already in the dictionary - do nothing
	else
		restore-input drop	\ otherwise restore the input buffer to just before the defiining word
	then
;
\ Notes (UH 2023-06-23)
\ Typically
\ 		[UNDEFINED] ... [IF] ...
\ UH privately 
\ 		?: 2dup over over ;
\ 		require x ( the system knows about x)
\ VolksForth 
\ 		\needs 2dup : 2dup over over ;
\ Albert vDH
\ 		want x ( the system knows about x)


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

	