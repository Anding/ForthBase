\ simple library for building command strings for serial devices
\ .. prefer to place these single character words in a hidden wordlist only exposed during << .. >>

0 value cs.addr
0 value cs.len

: << ( c-addr --)
\ start buildings a command string. Set the address pointer to addr
\ the stack and return stack are available witout restriction
	-> cs.addr
 0 -> cs.len
;

: >> ( -- )
\ finish the command string.
;

: | ( x --)
\ lay byte value x into the command string and post-increment the address pointer
	cs.addr c!
	inc cs.addr
	inc cs.len
;

: _ ( -- x)
\ read the byte from the command string at the address pointer and leave the pointer unchanged
	cs.addr
	c@
;

: $ ( x1-x2-x3-x4 -- 00-x1-x2-x3)
\ lay the low byte of the number on the stack into the command string
\ increment the address pointer
\ right shift the remaining bytes 
	dup 255 and |
	8 rshift
;
