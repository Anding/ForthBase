\ simple library for building command strings for serial devices
\ .. prefer to place these single character words in a hidden wordlist only exposed during << .. >>

0 value cs.addr
0 value cs.pointer

: << ( c-addr --)
\ start buildings a command string. Set the address pointer to addr
\ the stack and return stack are available witout restriction
	dup -> cs.addr -> cs.pointer
;

: >> ( -- addr u)
\ finish the command string return its address and length
	cs.addr
	cs.pointer over -
;

: | ( x --)
\ lay byte value x into the command string and post-increment the address pointer
	cs.pointer c!
	inc cs.pointer
;

: _ ( -- x)
\ read the byte from the command string at the address pointer and leave the pointer unchanged
	cs.pointer
	c@
;

: $ ( x1-x2-x3-x4 -- x1-x2-x3-x4 x4 )
\ extract the low byte of an integer 
\ right shift the remaining bytes 
	dup 8 rshift
	swap 255 and
;

: ..| ( caddr u --)
\ copy the referenced string into the command string
	0 ?do
		dup i + c@ |
	loop
	drop
;