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

60 VALUE ffBasis	\ the basis of the finite fractions, 'D'

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

: ~~~. ( x1 x2 x3 --)
\ print a triple integer format finite fraction in the order that it would have been keyed
	swap rot		( x3 x2 x1)
	. . . 
;

: ~. ( x --)
\ print a single integer format finite fraction in triple integer format
	~~~ ~~~.
;

: ~~~$ ( x1 x2 x3 c -- c-addr u)
\ format a triple integer format finite fraction as a string x1cx2cx3 where c is specified
	>R 
	<# 				\ proceeds from the rightmost character in the string
	abs 0 # #s 2drop	\ numeric output works with double numbers
	R@ HOLD
	abs 0 # #s 2drop
	R> HOLD
	dup >R 
	abs 0 # #s
	R> sign
	#>
;

: ~$ ( x c -- c-addr u)
\ format a single integer format finite fraction as a string x1cx2cx3 where c is specified
	>R ~~~ R> ~~~$
;

: ~~~f$ ( x1 x2 x3 -- c-addr u)
\ format format a triple integer format finite fraction as a fixed point string iii.ddd
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

: f$~ ( c-addr u - x)
\ parse a fixed point decimal string into a finite fraction in single integer format
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
\ parse a fixed point decimal string into a finite fraction in triple integer format
	f$~ ~~~
;
: ~f$ ( x -- c-addr u)
\ format format a single integer format finite fraction as a fixed point string iii.ddd
	~~~ ~~~f$
;