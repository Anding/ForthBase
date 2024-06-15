\ LIST functions
\	Default list structure is a circular, double-linked list
\ 	All nodes are 12 bytes organized as:
\		Forward link reference
\		Backward link reference
\		Value (user defined, typically 0 for a header node)
\	List pointers always point to the list node's byte zero
\ 	A list header is 24 bytes long and comprises two adjacent nodes that circular reference each other

: LIST.fwd ( n -- n, given a list node reference return the next forward list node)
	@
;

: LIST.bck ( n -- n, given a list node reference return the next back list node)
	4 + @
;

: LIST.val ( n -- x, given a list node reference return address of the value field)
	8 + 
;

: LIST.rem ( n --, given a list node remove it from the list)
	dup LIST.FWD over LIST.BCK !	\ back node now references forward node 
	dup LIST.BCK swap LIST.FWD 4 + !	\ forward node now references back node
;

: LIST.ins ( m n --, insert list node m in front of list node n)
	swap over over 4 + !			\ node m references back to node n
	over over swap LIST.FWD swap !	\ node m references forward to node n+1
	over over swap LIST.FWD 4 + !	\ node n+1 references back to node m
	swap !					\ node n references forward to node m
;

: LIST.init ( addr --, initialize a 24 byte circular list header at addr)
	dup 12 +	( addrF addrB)	\ address of front and back nodes
	dup LIST.VAL 0 swap !			\ zero back node
	over over !
	over over 4 + !
	swap
	dup LIST.VAL 0 swap !			\ zero front node
	over over !
	4 + !		
;

\ : LIST.initLin ( addr --, initialize a 24 byte linear list header at addr)
\	dup 12 +	( addrF addrB)		\ address of front and back nodes
\	over over 4 + !	
\	dup 0 swap !
\	over 4 + 0 swap !
\	swap !
\ ;

: LIST.? ( addr -- iterate over a circular list showing references and values)
	dup CR
	BEGIN
		dup . dup LIST.VAL @ . CR
		LIST.FWD 
		over over =
	UNTIL
	drop drop
;
