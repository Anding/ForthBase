\ Headerless, heap-backed ordered string maps.
\ Keep ordered-map.max-records unchanged while any maps are allocated.
\ Keys are truncated to 59 bytes, uppercased, and identified only by hash$.
\ Values are truncated to 255 bytes. Updates retain their insertion position.
\ Missing and empty values both read as exactly ( 0 0 ); callers handle them.
\ reset-map retains keys and order; erase-map clears every record.
\ Strings are borrowed from the map, not allocated by lookup or iteration.
\ Do not retain them across replacement, reset, erase, or free.
\ No dictionary maps, allocation registry, per-map header, or diagnostics.

NEED ForthBase

1024 value ordered-map.max-records

BEGIN-STRUCTURE ordered-map.record
      4 +FIELD ordered-map.key-hash     \ zero means unused
     60 +FIELD ordered-map.key          \ counted uppercase string
    256 +FIELD ordered-map.value        \ counted string
END-STRUCTURE

: erase-map ( map -- )
    ordered-map.max-records ordered-map.record * erase
;

: allocate-map ( -- map )
    ordered-map.max-records ordered-map.record * allocate throw
    dup erase-map
;

: free-map ( map -- )
    free throw
;

\ Internal addressing and lookup. Every scan is bounded by max-records.
: ordered-map.entry ( index map -- entry )
    swap ordered-map.record * +
;

create ordered-map.key-buffer 60 allot

: ordered-map.hash ( c-addr u -- hash )
    59 min ordered-map.key-buffer place
    ordered-map.key-buffer count upper
    ordered-map.key-buffer count hash$
;

: ordered-map.slot { hash map | entry -- entry | 0 }
\ Return the matching record or the first unused slot; zero means full/miss.
    ordered-map.max-records 0 ?do
        i map ordered-map.entry -> entry
        entry ordered-map.key-hash @ dup 0= swap hash = or if
            entry unloop exit
        then
    loop
    0
;

: ordered-map.value$ ( entry -- c-addr u )
    ordered-map.value count
    dup 0= if 2drop 0 0 then
;

: map-count { map -- n }
    ordered-map.max-records 0 ?do
        i map ordered-map.entry ordered-map.key-hash @ 0= if
            i unloop exit
        then
    loop
    ordered-map.max-records
;

: reset-map { map -- }
    map map-count 0 ?do
        i map ordered-map.entry ordered-map.value 256 erase
    loop
;

: map@ { key-addr key-u map | entry -- value-addr value-u }
    key-addr key-u ordered-map.hash map ordered-map.slot -> entry
    entry 0= if 0 0 exit then
    entry ordered-map.value$
;

: map! { value-addr value-u key-addr key-u map | hash entry -- }
    key-addr key-u ordered-map.hash -> hash
    hash map ordered-map.slot -> entry
    entry 0= abort" map full"
    entry ordered-map.key-hash @ 0= if
        ordered-map.key-buffer count entry ordered-map.key place
        hash entry ordered-map.key-hash !
    then
    value-addr value-u 255 min entry ordered-map.value place
;

: =>" ( value-addr value-u map <key>" -- )
    state @ if
        '"' parse postpone sliteral
        postpone rot postpone map!
    else
        '"' parse rot map!
    then
; immediate

: map-for-each { xt map | entry -- }
\ Callback: ( i*x key-addr key-u value-addr value-u -- j*x ).
\ Visit retained empty values too. Do not add keys, erase, or free in callbacks.
    map map-count 0 ?do
        i map ordered-map.entry -> entry
        entry ordered-map.key count entry ordered-map.value$ xt execute
    loop
;

: ordered-map.print { key-addr key-u value-addr value-u -- }
    cr key-addr key-u type 9 emit 9 emit value-addr value-u type
;

: .map ( map -- )
    ['] ordered-map.print swap map-for-each cr
;
