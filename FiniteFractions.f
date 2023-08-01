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

: ~~~ ( f - x1 x2 x3)
\ convert a finite fraction from single to triple integer format
	ffBasis /mod ( x3 quot)
	ffBasis /mod ( x3 x2 x1)
	swap rot		 ( x1 x2 x3)
;

: ~ ( x1 x2 x3 - f)
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

: ~. ( f --)
\ print a single integer format finite fraction in triple integer format
	~~~ ~~~.
;

: ~~~$ ( x1 x2 x3 c -- c-addr u)
\ format a triple integer format finte fraction as a string x1cx2cx3 where c is specified
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