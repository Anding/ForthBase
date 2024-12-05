\ specialized buffers with additional functions

BEGIN-STRUCTURE	BUFFER_USER_SPACE_FILEPATH
	4 +FIELD BUFFER_LEN_DIR
END-STRUCTURE

: buffer-filepath-to-string ( buf -- caddr u)
\ provide the full filepath in string format
	buffer-to-string
;

: buffer-drive-to-string
\ provide the drive part of the buffer in string format
\  single drive letter filepath "e:\" is assumed
	BUFFER_ADDR 3
;

: buffer-dir-to-string ( buf -- caddr u)
\ provide the directory part of the buffer in string format
\ 	exclude the drive part, include final delimiter, 
	>R
	R@ BUFFER_ADDR 3 +
	R> BUFFER_LEN_DIR @ 3 -
;

: buffer-filename-to-string ( buf -- caddr u)
\ provide the filename part of the buffer in string format
	>R
	R@ BUFFER_ADDR R@ BUFFER_LEN_DIR @ + 	( caddr)
	R> BUFFER_POINTER @ over -					( caddr len)
;

: buffer-punctuate-filepath ( buf --)
\ confirm that the directory part of the filepath, including final delimiter is written
	>R 
	R@ BUFFER_POINTER @ R@ BUFFER_ADDR -
	R> BUFFER_LEN_DIR !
;

