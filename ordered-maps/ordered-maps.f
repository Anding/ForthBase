\ Headerless, heap-backed ordered string maps.
\ ordered-maps are preferred to forth-map (Forth dictionary based) for allocable and disposable data structres
\ the principal use of ordered maps will be AstroimagingInForth, which allocates large buffers for images and file headers
\ robustness and simplicity are most important since a telecope is being controlled real time and often unattended
\ hence the preferred approach is to allocate a more-than-large-enough memory buffer and oder records in sequence rather than join with links
\
\ Keep ordered-map.max-records unchanged while any maps are allocated.
\ Keys are truncated to 59 bytes, uppercased, and identified only by hash$.
\ Values are truncated to 255 bytes. Updates retain their insertion position.
\ Returned string addresses remain valid until reset-map or free-map.
\ No dictionary-map recognition, allocation registry, or per-map header.

NEED ForthBase

1024 value ordered-map.max-records

BEGIN-STRUCTURE ordered-map.record
      4 +FIELD ordered-map.key-hash     \ hash$ of UPPERCASE(key), zero means unused
     60 +FIELD ordered-map.key          \ a counted string
    256 +FIELD ordered-map.value        \ a counted string
END-STRUCTURE

: reset-map ( map -- )
    ordered-map.max-records ordered-map.record * erase
;

: allocate-map ( -- map )
\ allocate memory for a new map of max-records and return the reference
    ordered-map.max-records ordered-map.record * allocate throw
    dup reset-map
;

: free-map ( map -- )
\ free an map - no checks are made to ensure this was a valid map
    free throw
;

synonym map allocate-map
synonym ordered-map allocate-map

create ordered-map.key-buffer 60 allot

: ordered-map.hash ( c-addr u -- hash )
    59 min ordered-map.key-buffer place
    ordered-map.key-buffer count upper
    ordered-map.key-buffer count hash$
;

: ordered-map-entry ( index map -- entry )
    over ordered-map.max-records u< 0=
        abort" ordered map entry out of range"
    swap ordered-map.record * +
;

: count-keys { map -- n }
    ordered-map.max-records 0 ?do
        i map ordered-map-entry ordered-map.key-hash @ 0= if
            i unloop exit
        then
    loop
    ordered-map.max-records
;

: item? { c-addr u map | hash entry -- addr true | 0 false }
\ Lookup never creates a record. Hash equality is key identity by policy.
    c-addr u ordered-map.hash -> hash
    ordered-map.max-records 0 ?do
        i map ordered-map-entry -> entry
        entry ordered-map.key-hash @ 0= if
            0 false unloop exit
        then
        entry ordered-map.key-hash @ hash = if
            entry ordered-map.value true unloop exit
        then
    loop
    0 false
;

: new-item { c-addr u map | hash index entry -- addr }
\ Append a key known to be absent; normally called through >addr or =>.
    c-addr u ordered-map.hash -> hash
    map count-keys -> index
    index ordered-map.max-records >= abort" ordered map is full"
    index map ordered-map-entry -> entry
    ordered-map.key-buffer count entry ordered-map.key place
    0 entry ordered-map.value c!
    hash entry ordered-map.key-hash !
    entry ordered-map.value
;

: >addr ( c-addr u map -- addr )
    >r 2dup r@ item? if
        nip nip r> drop
    else
        drop r> new-item
    then
;

: >string ( c-addr u map -- c-addr u )
    item? 0= abort" map item not found"
    count
;

: >integer ( c-addr u map -- n )
    >string toInteger
;

: => { value-addr value-u key-addr key-u map -- }
    key-addr key-u map >addr
    value-addr value-u 255 min rot place
;

: =>" ( c-addr u map <key>" -- )
    state @ if
        '"' parse postpone sliteral
        postpone rot postpone =>
    else
        '"' parse rot =>
    then
; immediate

: iterate-map { xt map | n -- }
\ Callback: ( i*x key-addr key-u -- j*x continue? ), newest key first.
    map count-keys -> n
    n 0 ?do
        n 1- i - map ordered-map-entry ordered-map.key count
        xt execute 0= if unloop exit then
    loop
;

: simple-iterate-map { xt map -- }
\ Callback: ( i*x key-addr key-u map -- j*x ), insertion order.
    map count-keys 0 ?do
        i map ordered-map-entry ordered-map.key count map xt execute
    loop
;

: iterator-for-counting ( n c-addr u -- n+1 true )
    2drop 1+ true
;

: iterator-for-buffering ( buffer c-addr u -- buffer true )
    2>r cell - dup r> swap !
    cell - dup r> swap !
    true
;

: buffer-keys ( hook map -- buffer )
\ Store key address/length pairs below hook, in insertion order.
    ['] iterator-for-buffering swap iterate-map
;

: .map-iterator ( c-addr u map -- )
    >r 2dup cr type 9 emit 9 emit
    r> >string type
;

: .map ( map -- )
    ['] .map-iterator swap simple-iterate-map cr
;
