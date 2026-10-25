\ *****************************************************************************
\ formatting and output

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

\ *****************************************************************************
\ data structures and memory

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
		allocate abort" unable to allocate buffer" ,
	does>		( -- addr)
		@
;

: DEBUFFER ( addr --)
\ free a buffer created with the word buffer
	free if cr ." unable to free buffer" cr then
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

\ *****************************************************************************
\ string convenience functions

: despace ( c-addr u -- )
\ Replace spaces in writable string storage with underscores in place.
    over + swap ?do
        i c@ bl = if '_' i c! then
    loop
;

synonym $! place ( caddr u addr --) 
\ copy a string into memory at addr in counted string format

synonym $@ count ( addr -- caddr u) 
\ reference on the stack the counted string at addr

: /string ( caddr n m --)
\ VFX does not check for 0 length strings
    2dup >= if
        dup >R -
        swap R> + swap
    else
        drop
    then
;

\ 32-bit FNV-1a mixing step, shared with simple-tester.
: hash ( x1 h0 -- h1)
    xor $01000193 * $ffffffff and
;
	
\ 32-bit FNV-1a; reserve zero for unused map records by mapping it to one.
: hash$ { c-addr u -- h }
    $811c9dc5
    u 0 ?do
        c-addr i + c@ swap hash
    loop
    dup 0= -
;

: toInteger ( caddr u -- n)
\ convert a string to an integer
    isInteger? case
        0 of 0      endof       \ failure as zero
        2 of nip    endof       \ a double number drops the high cell
    endcase                     \ end case consumes '1' and leaves the number
;

\ *****************************************************************************
\ a value type for strings

: $value ( c-addr u <name> -- ) 
\ create a value type for strings with 255 bytes
    Create 256 here swap allot place
    Does> ( -- c-addr u ) count
;

: $-> ( c-addr u <name> -- ) 
\ write the string c-addr u to <name>
    ' >body place ;
ndcs: ( <name> -- )     \ i.e. "do the following at compile time..."
    ' >body  postpone LITERAL  postpone PLACE 
;

: +place ( caddr u addr -- )
\ append a string c-addr u onto the counted string at addr
     dup >r count  dup >r +  swap dup >r
     move r> r> + r> c!
;

: $+> ( c-addr u <name> -- )
\ append the string c-addr u to <name>
    ' >body +place ;
ndcs: ( <name> -- )
     ' >body  postpone LITERAL  postpone +PLACE
;

\ *****************************************************************************
\ a string builder on the pad

 wordlist ( wid) constant stringbuilder.wid
 
 : <$  ( -- ) 
 \ start a new string on the pad     
 state @ 0= if 0 pad c!
    else 0 postpone literal postpone pad postpone c!
 then
    stringbuilder.wid +order  \ add the stringbuilder wordlist to the search order 
; immediate

: $> ( -- c-addr u )
\ finish the string and reference it on the stack
state @ 0= if pad count
    else postpone pad postpone count 
then
    stringbuilder.wid -order  \ drop the stringbuilder wordlist from the search order
; immediate
 
get-current ( wid) stringbuilder.wid set-current
\ compile the following defintions into the stringbuilder wordlist
\ these are short words and we only want them available inside of <$ ... $> to avoid conflicts

: $ ( c-addr u -- ) 
\ append the string c-addr u to the string being built on the pad
    pad +place 
;

: _ ( c -- ) 
\ append the char c to the string being built on the pad 
    pad count + c! 1 pad c+!
;

( wid) set-current
\ revert to the original wordlist to take further definitions









  

  