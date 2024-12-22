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

: .2r ( n --)
\ print a number with at least two digits padded with a leading zero
	<# S>D ( double number) # #s #> type space
	\ note S>D is required to correctly convert negative single numbers to doubles
;

: ~~~. ( x1 x2 x3 --)
\ print a triple integer format finite fraction in the order that it would have been keyed
	swap rot		( x3 x2 x1)
	.2r .2r .2r 
;

: ~. ( x --)
\ print a single integer format finite fraction in triple integer format
	~~~ ~~~.
;

: ~~~$ ( x1 x2 x3 -- c-addr u)
\ format a triple integer format finite fraction as a string x1cx2cx3 where c is ffSeparator
	<# 				\ proceeds from the rightmost character in the string
	abs 0 # #s 2drop	\ numeric output works with double numbers
	ff1separator HOLD
	abs 0 # #s 2drop
	ff2separator HOLD
	dup >R 
	abs 0 # #s
	R> 0 < if '-' HOLD else ffForcePlus if '+' HOLD then then
	#>
;

: ~$ ( x -- c-addr u)
\ format a single integer format finite fraction as a string x1cx2cx3 where c is specified
	~~~ ~~~$
;

: check-sign ( caddr u -- caddr u +/-1)
\ test for a sign character (including blank) at the start of a string
\ inc/decrement caddr u if a sign character is found
\ VFX's SKIP-SIGN may not handle blank	
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

: >number~~~ ( caddr u -- x y z)
\ split a three part string of the form sXX:YY:ZZ into 3 integers
\ the sign s is applied to each of x, y and z
\ XX, YY, ZZ can be any number of digits
\ ':' can be any non-digit character
\ ZZ may be followed by a non-digit and the rest of the string is ignored
\ ZZ may be omitted in which case z = 0
	check-sign >R				( caddr u R:+/-1)
	3 0 do
		0 0 2swap				( ud caddr u)	
		>number 					( ud caddr u)
		1- swap 1+ swap		( xd [yd zd] caddr' u') \ skip the non-printing
	loop
	2drop	R>						( xd yd zd +/-1)
	nip swap over * >R
	nip swap over * >R
	nip * R> R>
;

: ~~~fp ( x1 x2 x3 -- f)
\ convert a triple integer format finite fraction into a floating point number on the floating point stack
	S>F ffBasis S>F f/
	S>F f+ ffBasis S>F f/
	S>F f+
;

: ~fp ( x --- f)
\ convert a single integer format finite fraction into a floating point number on the floating point stack
	~~~ ~~~fp
;

\ debug - these routines need to be reviewed and debugged or deleted

: ~~~f$ ( x1 x2 x3 -- c-addr u)			\ debug - assumes base 60
\ format format a triple integer format finite fraction as a fixed point string iii.dddd
	swap ffBasis * + 100 *	\ documented in finite-fractions.xlxs
	over 0< 2* 1+ 18 * +		\ for rounding - equivalent to int(x + 0.5)
	36 /							( iii ddd)
	<#
	abs 0 # # # # 2drop		\ 4 d.p.
	'.' HOLD
	dup abs 0 #s
	rot sign
	#>
;

: ~f$ ( x -- c-addr u)
\ format format a single integer format finite fraction as a fixed point string iii.dddd
	~~~ ~~~f$
;

: f$~ ( c-addr u - x)						\ debug - assumes base 60 
\ parse a fixed point decimal string iii.dddd into a finite fraction in single integer format
	'.' csplit ( raddr ru laddr lu)	\ r = fractional part with dot l = integer part
	isinteger? 0= if 0 then >R
	dup if						\ ru <> 0 there was a decimal point
		swap 1+ swap 1-		\ skip the decimal point
		isinteger? 0= if 0 then
	then							\ if no decimal point 0 is on stack
		36 *						\ documented in finite-fractions.xlxs
		R@ 0< 2* 1+	*			\ fractional part takes the sign of the integer part		
		R@ 0< 2* 1+ 50 * +	\ for rounding - equivalent to int(x + 0.5)
		100 /
		R> 3600 * +
;

: f$~~~ ( c-addr u - x1 x2 x3)
\ parse a fixed point decimal string iii.dddd  into a finite fraction in triple integer format
	f$~ ~~~
;


