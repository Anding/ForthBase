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

: fp~ ( f --- x)
\ convert a floating point number to single integer finite fraction format
	ffBasis S>F fdup f* f*
	FR>S	\ float to number with rounding preferred to maintain precision
;

: fp~~~ ( f --- x1 x2 x3)
\ convert a floating point number to triple integer finite fraction format
	fp~ ~~~
;