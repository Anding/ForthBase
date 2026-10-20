\ share VARIABLE, CONSTANTS, etc. between source files
NEED ForthBase

\ Each private constant returns the number of initialization items to drop.
\ Never add this wordlist to the search order: its names are not definers.
wordlist constant shared.definers
get-current
shared.definers set-current
	0 constant VARIABLE
	0 constant 2VARIABLE
	1 constant CONSTANT
	1 constant VALUE
	1 constant BUFFER:
	2 constant 2CONSTANT
	2 constant 2VALUE
	2 constant $VALUE
set-current
	
: SHARED
\ prefix for VARIABLE, CONSTANT, VALUE that will be shared between source files
	save-input								( xn...x1 n) 					\ save the state of the input buffer
	BL parse-word 		 					( xn...x1 n c-addr u)		\ the defining word
	have										( xn...x1 n c-addr u flag)	\ the name of the word to be defined
	if							\ name is already in the dictionary
		shared.definers search-wordlist
		0= abort" Unsupported SHARED defining word"
		execute >R ndrop				\ drop the input buffer
		R> ndrop								\ drop the value(s) and the count of values	
	else						\ otherwise restore the input buffer to just before the defining word
		2drop									\ drop the name
		restore-input ( ior) drop		
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