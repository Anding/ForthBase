\ arithmetic *******************************************************************

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
\ Example 2: MOD 6
\  	0, 1, 2,  3,  4,  5
\  	0, 1, 2, -3, -2, -1	

	over over			( n M n M)
	1+ 2/					( n M n m)
	>= IF - ELSE drop THEN
;

: upmod ( n M -- n')
\ the inverse of downmod

	over					( n M n)
	0< IF + ELSE drop THEN
;

