\ Given integers x and D the rational number x/D^2 can be represented at x1 + x2/D + x3/D^2
\ 	where x1, x2, x3 are also integers and Abx(x2), Abs(x3) < D (reference the theory of partial fractions)
\  we shall call the tripe of integers x1 x2 x3 a FINITE FRACTION
\
\ Example 1. HH MM SS represents a rational number HH + MM/60 + SS/3600
\ Example 2. x1 x2 x3 represents a rational number x1 + x2/16 + x3/256

\ Expressing finite fractions in their unique format relies on modular arithmetic with carry
\ Example 1.  01 50 61 should be reexpressed in the unique format 01 51 01 
\ 		since 1 + 50/60 + 61/3600 = 1 + 51/60 + 1/3600
\ Example 2.  23 59 61 should be reexpressed in the unique format 24 00 01
\ 		since 23 + 59/60 + 61/3600 = 24 + 0/60 + 1/3600

\ Modular arithmetic can optionally be applied to the leading integer x1
\ Example 1.  24 00 01 with equivalence classes 0 .. 23 applied to the leading integer becomes 00 00 01
\ 		since 24 + 0/60 + 1/3600 = 24*1 + (0 + 0/60 + 1/3600)
\ Example 2.  24 00 01 with equivalence classes -11 .. 11 applied to the leading integer becomes -11 -59 -59
\ 		since 24 + 0/60 + 1/3600 = 12*3 + (-11 - 59/60 - 59/3600)
\ both of these examples apply modulo 24 to the leading integer but with alternative representations
\ note that in Example 2, each integer of the tripe carries the negative sign
