\ Reference the theory of partial fractions
\ Given integers f and D the rational number f/D^2 can uniquely be represented at x1 + x2/D + x3/D^2
\ 	where x1, x2, x3 are also integers and 0 <= Abx(x2), Abs(x3) < D
\ We shall call both the triple-integer format, x1 x2 x3, and the single-integer format, f, a FINITE FRACTION
\ 
\ Example 1. HH MM SS with D = 60 represents a rational number HH + MM/60 + SS/3600
\ Example 2. x1 x2 x3 with D = 16 represents a rational number x1 + x2/16 + x3/256
\ 
\ Expressing triple-integer format finite fractions in their unique representation relies on modular arithmentic with carry
\ Example 1.  01 50 61 is uniquely 01 51 01 
\ 		since 1 + 50/60 + 61/3600 = 1 + 51/60 + 1/3600
\ Example 2.  23 59 61 is uniquely 24 00 01
\ 		since 23 + 59/60 + 61/3600 = 24 + 0/60 + 1/3600
\ 
\ Modular arithmetic can be applied to the finite fractions
\ Take modulo 24 00 00
\ Example 1.  24 00 01 becomes 00 00 01
\ 		since 24 + 0/60 + 1/3600 = 24 + (0 + 0/60 + 1/3600)
\ Example 2.  22 30 50 becomes, using a different set of equivalence classes, -01 -29 -10
\ 		since 22 + 30/60 + 50/3600 = 24 - 01 -29/60 -10/3600
\ 		note that each integer of the tripe-integer format carries the negative sign

 60 VALUE ffBasis			\ the basis of the finite fractions, 'D'
':' VALUE ff1separator 	\ for string conversion, e.g. 23:10:00
':' VALUE ff2separator 	\ e.g. 130*10:00 for 10Micron mount commands
  0 VALUE ffForcePlus   \ for string conversion, e.g. +179:59:59

: ~~~ ( x - x1 x2 x3)
\ convert a finite fraction from single to triple integer format
	ffBasis /mod ( x3 quot)
	ffBasis /mod ( x3 x2 x1)
	swap rot		 ( x1 x2 x3)
;

: ~ ( x1 x2 x3 - x)
\ convert a finite fraction from triple to single integer format
	rot ffBasis *		( x2 x3 D*x1 )
	rot +	ffBasis *	( x3 D*{x2+D*x1} )
	+						( x3+D*{x2+D*x1} )
;

: ~~~custom$ { x1 x2 x3 c1 c2 fp -- c-addr u }
\ Format three components with explicit separators, without changing defaults.
	x1 x2 x3
	3dup or or >R	\ Retain the sign when the leading components are zero.
	<# 				\ proceeds from the rightmost character in the string
	abs 0 # #s 2drop	\ numeric output works with double numbers
	c2 HOLD
	abs 0 # #s 2drop
	c1 HOLD
	abs 0 # #s
	R> 0 < if '-' HOLD else fp if '+' HOLD then then
	#>
;

: ~~~$ ( x1 x2 x3 -- c-addr u)
\ Format three components using the configured separators and sign policy.
	ff1separator ff2separator ffForcePlus ~~~custom$
;

: ~$ ( x -- c-addr u)
\ format a single integer format finite fraction as a string x1cx2cx3
	~~~ ~~~$
;

: ~custom$ { x c1 c2 fp -- c-addr u }
\ Format one packed coordinate without temporarily changing shared defaults.
	x ~~~ c1 c2 fp ~~~custom$
;

: check-sign ( caddr u -- caddr u +/-1)
\ test for a sign character (including blank) at the start of a string
\ inc/decrement caddr u if a sign character is found
\ VFX's SKIP-SIGN may not handle blank	
	dup 0> 0= abort" Missing finite fraction"
	over c@ case
	'+' of  1 >R endof
	BL  of  1 >R endof
	'-' of -1 >R endof
	0 >R endcase
	R@ 0= if 
		R> drop 1
	else
		1- swap 1+ swap R> 
	then
;

: >number-component { caddr u | low high rest remaining -- rest u' n }
\ Read one unsigned integer without consuming its following separator.
\ Require digits and a single-cell result; never inspect an empty input.
	u 0> 0= abort" Missing finite-fraction component"
	0 0 caddr u >number -> remaining -> rest -> high -> low
	remaining u = high 0<> or abort" Invalid finite-fraction component"
	rest remaining low
;

: >number~~~ { caddr u | sign component -- x y z }
\ Parse up to three signed components, separated by any non-digit character.
\ Omitted trailing components are zero; text after the third integer is ignored.
\ Example: s" 23*10" >number~~~ returns 23 10 0, without reading past the string.
\ Empty input, a sign alone or a nonnumeric present component aborts.
	caddr u check-sign -> sign -> u -> caddr
	u 0= abort" Missing finite-fraction component"
	3 0 do
		u if
			caddr u >number-component -> component -> u -> caddr
			u if caddr 1+ -> caddr u 1- -> u then
			component sign *
		else
			0
		then
	loop
;

: >number~ ( caddr u - x)
\ convert a three part string of the form sXX:YY:ZZ into a finite fraction in single integer format
	 >number~~~ ~
;

: >number3~ { caddr u separator | sign -- n }
\ Require all three fields and the requested separators; ':' also accepts spaces.
\ The final field must be numeric, with optional fractional seconds discarded.
\ Example: s" 04:29:05.0" ':' >number3~ returns 16145 (4 29 5 ~).
\ Use >number~ instead when omitted trailing fields or protocol suffixes are valid.
	caddr u check-sign -> sign -> u -> caddr
	2 0 do
		caddr u >number-component -rot -> u -> caddr
		u 0= abort" Missing finite-fraction separator"
		caddr c@ dup separator =
		swap bl = separator ':' = and or
			0= abort" Invalid finite-fraction separator"
		caddr 1+ -> caddr u 1- -> u
	loop
	caddr u -white dup 0= abort" Missing finite-fraction component"
	>float 0= abort" Invalid finite-fraction component"
	f>s ~ sign *
;

: ~~~. ( x1 x2 x3 --)
\ print a triple integer format finite fraction in the order that it would have been keyed
 rot . swap . .
;

: ~. ( x --)
\ print a single integer format finite fraction in triple integer format
	~~~ ~~~.
;
