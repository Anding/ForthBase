\ simple binary trees based on descriptors

NEED ForthBase

32 value NODE_PAYLOAD_SIZE

BEGIN-STRUCTURE TREE_DESCRIPTOR
	4 +FIELD TREE_SIZE				\ size of the tree in bytes
	4 +FIELD	TREE_POINTER			\ pointer to the current node
	0 +FIELD TREE_ADDR				\ the tree itself immediately follows the descroptor
END-STRUCTURE

BEGIN-STRUCTURE NODE_DESCRIPTOR
	4 +FIELD UP_NODE					\ pointer to the up node, or 0
	4 +FIELD DOWN_NODE
	4 +FIELD BACK_NODE
	4 +FIELD NEXT_NODE
 	NODE_PAYLOAD_SIZE 
 	  +FIELD NODE_PAYLOAD			\ typically a counted string
END-STRUCTURE

: tree_used ( tree -- x)
\ used tree bytes
	dup >R TREE_POINTER @
	R> TREE_ADDR -
;

: tree_space ( bux -- x)
\ free tree bytes
	dup >R TREE_SIZE @
	R> tree_used -
;

: reset-tree ( tree --)
\ reset the tree_pointer
\ zero the tree
	dup >R TREE_ADDR
	R@ TREE_POINTER !
	R@ TREE_ADDR R> TREE_SIZE @ erase
;

: declare-tree ( size tree --)
\ prepare the descriptor of already allocated memory
\ size = sizeof(TREE), but size + TREE_DESCRIPTOR must be already allocated
	>R 
	R@ TREE_SIZE !
	R@ reset-tree
	R> drop
;

: allocate-tree ( size -- tree)
	\ allocate memory for a tree structure
	dup TREE_DESCRIPTOR + allocate abort" unable to allocate tree"
	dup -rot
	( tree size tree) declare-tree
	( tree)
;

: free-tree ( tree --)
\ free the tree memory and descriptor
	free abort" unable to free buffer"
;

: node! ( x node --)
	NODE_PAYLOAD !
;

: node@ ( node -- x)
	NODE_PAYLOAD @
;

: node$! ( c-addr u node --)
	NODE_PAYLOAD place
;

: node$@ ( node -- c-addr u)
	NODE_PAYLOAD count
;

: new-node ( tree -- new)
	\ initialize a 0 node descriptor and return its address
	>R 
	R@ tree_space NODE_DESCRIPTOR < abort" insufficent memory for a new node"
	R@ TREE_POINTER @								( new)
	NODE_DESCRIPTOR R> TREE_POINTER +! 
;

: new-next-node ( current tree -- new)
	new-node dup -rot 2dup ( new current new current new)
	\ point the current node next field to new
	swap NEXT_NODE !
	\ point the new node back node to current
	BACK_NODE !
;

: new-down-node ( current new --)
	new-node dup -rot 2dup ( new current new current new)
	\ point the current node down field to new
	swap DOWN_NODE !
	\ point the new node up node to current
	UP_NODE !
;

BEGIN-ENUM
	+ENUM NO_MOVE
	+ENUM GO_NEXT
	+ENUM GO_BACK
	+ENUM GO_UP
	+ENUM GO_DOWN
END-ENUM

BEGIN-ENUMS MOVEMENT_CODES
	+" NO_MOVE"
	+" GO_NEXT"
	+" GO_BACK"
	+" GO_UP"
	+" GO_DOWN"
END-ENUMS	

DEFER do-after-move ( node2 MOVEMENT TRUE | node1 MOVEMENT FALSE -- [x0...xn])

: do-nothing ( node2 MOVEMENT TRUE | node1 MOVEMENT FALSE -- ) 
	3drop
;
	
	
: explain-move ( node2 MOVEMENT TRUE | node1 MOVEMENT FALSE -- )
	0= IF 
		." FAILED:" 
		MOVEMENT_CODES type BL emit
		drop
	ELSE
		MOVEMENT_CODES type
		CR ." Node "
		node@ .
	THEN
;

ASSIGN do-nothing TO-DO do-after-move

: test-node ( node1 node2 MOVEMENT -- node2 MOVEMENT TRUE | node1 MOVEMENT FALSE)
	\ test the validity (non-zero) of node2 as a step from node1
	over IF rot drop TRUE ELSE nip FALSE THEN
	\ call a user definable function
	3dup >R >R >R do-after-move R> R> R>
;

: go-next ( current -- next GO_NEXT TRUE | current GO_NEXT FALSE)
	\ take the next field of the current node and return TRUE
	\ if there is no next node return the current node and FALSE
	dup NEXT_NODE @ GO_NEXT test-node 
;

: go-back ( current -- back GO_BACK TRUE | current GO_BACK FALSE)
	dup BACK_NODE @ GO_BACK test-node 
;

: go-up ( current -- up GO_UP TRUE | current GO_UP FALSE)
	dup UP_NODE @ GO_UP test-node 
;

: go-down ( current -- down GO_DOWN TRUE | current GO_DOWN FALSE)
	dup DOWN_NODE @ GO_DOWN test-node 
;

: go-on ( next MOVEMENT TRUE | current MOVEMENT FALSE -- next MOVEMENT TRUE | current MOVEMENT FALSE )
	IF
		\ successful movement
		CASE
			GO_DOWN OF go-down ENDOF
			GO_NEXT OF go-down ENDOF
			GO_BACK OF go-up ENDOF
			GO_UP OF go-next ENDOF
		ENDCASE
	ELSE
		\ no move
		CASE
			GO_DOWN OF go-next ENDOF
			GO_NEXT OF go-up ENDOF
			GO_BACK OF go-up ENDOF
			GO_UP OF go-back ENDOF
		ENDCASE
	THEN
;

: traverse ( tree)
	TREE_ADDR dup >R GO_DOWN TRUE   
	BEGIN ( current MOVEMENT TRUE|FALSE)
		go-on ( current MOVEMENT TRUE|FALSE)
		dup 0= IF -rot 2dup
			GO_UP = 
			swap R@ = 
			AND IF R> drop 3drop exit THEN 
			rot
		THEN
	AGAIN
;
		 