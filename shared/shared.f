\ share VARIABLE, CONSTANTS, etc. between source files
\ requires maps.fs, map-tools.fs

\ the key-value table will hold the number of stack items to drop
	map constant shared.map
	s" VARIABLE"	shared.map >addr 0 swap !
	s" 2VARIABLE"	shared.map >addr 0 swap !
	s" CONSTANT"	shared.map >addr 1 swap !
	s" VALUE"		shared.map >addr 1 swap !
	s" BUFFER:"		shared.map >addr 1 swap !	\ redefined in ForthBase.f
	s" 2CONSTANT" 	shared.map >addr 2 swap !
	s" 2VALUE" 		shared.map >addr 2 swap !
	s" STRING"		shared.map >addr 2 swap !	\ defined in ForthBase.f
	
: SHARED
\ prefix for VARIABLE, CONSTANT, VALUE that will be shared between source files
	save-input								( xn...x1 n) 			\ save the state of the input buffer
	BL parse-word shared.map >addr @	( xn...x1 n m)
	have										( xn...x1 n m flag)
	if							\ name is already in the dictionary - do nothing
		>R ndrop	R> ndrop			
	else						\ otherwise restore the input buffer to just before the defining word
		drop restore-input ( ior) drop		
	then
;

\ example
\ source1.f
\ 		SHARED VARIABLE x  \ create variable x the first time
\ 
\ source2.f
\ 		SHARED VARIABLE x  \ do nothing the 2nd time, x is not redefined
\ 


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