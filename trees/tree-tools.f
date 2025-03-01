\ data
0 value pen_column
16 value column_width

: draw-down-connector ( column --)
\ draw -- from the current column into the next column
;

: draw-next



: print-node ( node2 MOVEMENT TRUE | node1 MOVEMENT FALSE -- ) 
	0= if 2dup exit then		\ ignore searching moves not made
	CASE
		GO_DOWN OF 
			dup NEXT_NODE @ IF ( mark the current column as active) THEN
			pen_column draw-down
			inc pen_column 
		ENDOF
		GO_NEXT OF
			\ start a new row
			\ draw | in each active column until the current column
			\ move the cursor up to the current column
		ENDOF
		GO_BACK OF
			\ no action
		ENDOF
		GO_UP OF
			\ decrement the current column
		ENDOF
	ENDCASE
	\ print the node name and pad with spaces
	
;