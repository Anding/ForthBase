\ specialized buffers with additional functions

NEED regex

\ Dedicated filepath buffer
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

\ Regex searching within a buffer
BEGIN-STRUCTURE	BUFFER_USER_SPACE_REGEX
	4 +FIELD BUFFER_SEARCH_POINTER
END-STRUCTURE

: buffer-reset-search ( buf --)
\ reset the search pointer to the start of the buffer
    >R
    R@ BUFFER_ADDR
    R> BUFFER_SEARCH_POINTER !
;

: buffer-match ( c-addrR uR buf -- c-addrM uM -1 | 0)
\ attempt to match the regex in c-addrR uR in the buffer
\ if successful, return the match in addrM uM and advance the buffer pointer after the match
\ else return 0
    >R
    R@ BUFFER_POINTER @
    R@ BUFFER_SEARCH_POINTER @ - 0 max ( c-addrR uR uT)
    R@ BUFFER_SEARCH_POINTER @ swap ( c-addrR uR c-addrT uT)
    2swap match ( start len -1 | 0)
    if
        swap R@ BUFFER_SEARCH_POINTER @ + swap ( c-addrM uM)
        2dup + R> BUFFER_SEARCH_POINTER !
        -1
    else
        R> drop 0
    then
;
        


