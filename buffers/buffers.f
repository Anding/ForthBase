\ a descriptor based approach to buffers

\ descriptor data structure for an buffer
BEGIN-STRUCTURE	BUFFER_DESCRIPTOR
	4 	+FIELD	BUFFER_SIZE				\ size of the buffer in bytes
	4 	+FIELD 	BUFFER_POINTER			\ pointer to the current write location
	0 	+FIELD 	BUFFER_ADDR				\ the buffer itself immediately follows the descriptor
END-STRUCTURE

: reset-buffer ( buf --)
\ reset the buffer_pointer
\ zero the buffer
	dup >R BUFFER_ADDR
	R@ BUFFER_POINTER !
	R@ BUFFER_ADDR R> BUFFER_SIZE @ ERASE
;

: declare-buffer ( size buf -- )
\ prepare the descriptor of already allocated memory
\ size = sizeof(BUFFER), but size + BUFFER_DESCRIPTOR must be already allocated
	>R 
	R@ BUFFER_SIZE !
	R@ reset-buffer
	R> drop
;

: allocate-buffer ( size -- buf)
\ allocate space on the heap and prepare the descriptor
\ size = sizeof(BUFFER), but size + BUFFER_DESCRIPTOR will be allocated
	dup BUFFER_DESCRIPTOR + allocate abort" unable to allocate buffer"
	dup -rot
	( buf size buf) declare-buffer
	( buf)
; 

: free-buffer ( buf --)
\ free the buffer memory and descriptor
	free abort" unable to free buffer"
;

: buffer_used ( buf -- x)
\ used buffer bytes
	dup >R BUFFER_POINTER @
	R> BUFFER_ADDR -
;

: buffer_space ( bux -- x)
\ free buffer bytes
	dup >R BUFFER_SIZE @
	R> buffer_used -
;

: write-buffer ( addr n buf -- ior)
\ write (type) a string to the buffer, advance the buffer pointer and return the number of written characters
\ bounds checked, ior  = -1 if insufficent space
	>R 								( addr n R: buf)
	R@ buffer_space over < if 2drop R> drop -1 exit then	\ insufficient space
	dup -rot							( n' addr n' R: buf)
	R@ BUFFER_POINTER @ swap 	( n' addr addr2 n') move 
	R> BUFFER_POINTER +!
	0
;

: echo-buffer ( c buf -- ior)
\ write (echo) a character to the buffer advance the buffer pointer
\ bounds checked, ior  = -1 if insufficient space
	>R
	R@ buffer_space 0> not if drop R> drop -1 exit then
	R@ BUFFER_POINTER @ c!
	1 R> BUFFER_POINTER +!
	0
;

: backspace-buffer ( buf -- ior)
\ decrement the buffer pointer, as if a backspace had been keyed
	>R
	R@ buffer_used
	if ( buffer_used <> 0)
		-1 R> BUFFER_POINTER +!  ( ior) 0
	else 
		R> drop ( ior) -1
	then 
;

: file-to-buffer ( fileid -- buf)
\ memory map a file to a newly allocated buffer and return the descriptor
	dup file-size abort" cannot access file" drop	( fileid size)					\ file-size returns a double			
	over 0 0 rot reposition-file abort" cannot access file"
	dup allocate-buffer >R									( fileid size R:buf)			\ allocate a suitable buffer
	dup rot R@ BUFFER_ADDR -rot							( n addr n fileid R:buf)
	read-file abort" cannot access file" drop			( n R:buf)
	R@ BUFFER_POINTER +! R>									
;

: buffer-to-string ( buf -- c-addr u)
\ provide the buffer address and size in string format
	>R
	R@ BUFFER_ADDR
	R> buffer_used
;

: buffer-to-file ( buf fileid --)
\ save the contents (used portion) of the buffer to fileid
	>R
	buffer-to-string
 	R>				  ( addr n fileid)
	write-file abort" cannot access file"	
;
		
