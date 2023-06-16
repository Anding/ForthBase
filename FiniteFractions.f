\ Reference the theory of partial fractions
\ Given integers x and D the rational number x/D^2 can uniquely be represented at x1 + x2/D + x3/D^2
\ 	where x1, x2, x3 are also integers and Abx(x2), Abs(x3) < D
\ We shall call the tripe of integers x1 x2 x3 a FINITE FRACTION
\ 
\ Example 1. HH MM SS with D = 60 represents a rational number HH + MM/60 + SS/3600
\ Example 2. x1 x2 x3 with D = 16 represents a rational number x1 + x2/16 + x3/256

\ Expressing finite fractions in their unique representation relies on modular arithmentic with carry
\ Example 1.  01 50 61 should be reexpressed in the unique format 01 51 01 
\ 		since 1 + 50/60 + 61/3600 = 1 + 51/60 + 1/3600
\ Example 2.  23 59 61 should be reexpressed in the unique format 24 00 01
\ 		since 23 + 59/60 + 61/3600 = 24 + 0/60 + 1/3600

60 VALUE ffBasis	\ the basis of the finite fractions, 'D'

: ~~~ ( n - x1 x2 x3)
\ convert an interger number of D^2 units into a finite fraction
	ffBasis /mod ( x3 quot)
	ffBasis /mod ( x3 x2 x1)
	swap rot		 ( x1 x2 x3)
;

: ~ ( x1 x2 x3 - n)
\ convert a finite fraction into an integer number of D^2 units
	rot ffBasis *		( x2 x3 D*x1 )
	rot +	ffBasis *	( x3 D*{x2+D*x1} )
	+						( x3+D*{x2+D*x1} )
;

: ~~~. ( x1 x2 x3)
\ print a finite fraction in the order that it would have been keyed
	swap rot		( x3 x2 x1)
	. . . 
;

: ~~~! ( x1 x2 x3 addr --)
\ store a finite fraction in a cell-size memory address
	>R ~ R> !
;

: ~~~@ ( addr -- x1 x2 x3)
\ fetch a finite fraction from a cell-size memory address
	@ ~~~
;

\ Modular arithmetic can be applied to the entire finite fraction
\ Take modulo 24
\ Example 1.  24 00 01 becomes 00 00 01
\ 		since 24 + 0/60 + 1/3600 = 24 + (0 + 0/60 + 1/3600)
\ Example 2.  22 30 50 becomes, using a different set of equivalence classes, -01 -29 -10
\ 		since 22 + 30/60 + 50/3600 = 24 - 01 -29/60 -10/3600
\ note that in Example 2, each integer of the tripe carries the negative sign

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
\ Eaample 2: MOD 6
\  	0, 1, 2,  3,  4,  5
\  	0, 1, 2, -3, -2, -1	
\ 
	over over			( n M n M)
	1+ 2/					( n M n m)
	>= IF - ELSE drop THEN
;

: upmod ( n M -- n')
\ the inverse map of downmod
\ 
	over					( n M n)
	0< IF + ELSE drop THEN
;

: ~~~/MOD ( x1 x2 x3 +-M -- y1 y2 y3 quot)
\ /MOD operation applied to a finite fraction
\ if M is supplied as a negative interger, follow with downmod
\ 
	ffBasis ffBasis * * >R ~ 							( n R:+-MM)
	R@ abs													( n +MM R:+-MM)
	/MOD swap												( quot rem R:+-MM)
	R@ 0< IF  R@ abs 2dup . . cr downmod THEN		( quot rem R:+-MM)
	R> drop swap >R ~~~ R>								( y1 y2 y3 quot)
;
		
		

		
		
		
		