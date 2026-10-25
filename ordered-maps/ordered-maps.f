\ Headerless, heap-backed ordered string maps.
\
\ User guide
\ ----------
\ Load with NEED ordered-maps. Keys and values are byte strings, not cells.
\ Assignment copies both strings into the map; the caller owns its inputs.
\ Keys are truncated to 59 bytes, uppercased, and identified only by hash$.
\ Thus key case and suffixes beyond byte 59 do not distinguish entries.
\ Different normalized keys with the same hash also denote the same entry;
\ there is deliberately no collision resolution by comparing key text.
\ Values are truncated to 255 bytes. Updates retain their insertion position.
\ Missing and empty values both read as exactly ( 0 0 ); callers handle them.
\ map-count counts stored keys, including those whose values are empty.
\
\ Example (at the REPL):
\   allocate-map constant settings
\   s" M42" settings =>" object"
\   s" 30" s" exposure" settings map!
\   s" OBJECT" settings map@ type       \ prints M42
\   settings .map                      \ prints OBJECT, then EXPOSURE
\   settings reset-map                 \ keeps both keys, empties their values
\   settings erase-map                 \ discards both keys and their order
\   settings free-map                  \ settings is now a dangling address
\
\ reset-map retains keys and order; erase-map clears every record.
\ Strings are borrowed from the map, not allocated by lookup or iteration.
\ Do not retain them across replacement, reset, erase, or free.
\ A full map accepts replacements; a new key reports "map full" and is skipped.
\ Allocation failure aborts. Deallocation failure is reported and returns.
\
\ Representation and maintenance
\ ------------------------------
\ A map is the address of a contiguous array of fixed-size records.
\ No dictionary maps, allocation registry, per-map header, or diagnostics.
\ Occupied records form a dense prefix in insertion order; a zero hash ends
\ that prefix. New keys take the first unused record; updates stay in place.
\ There is no individual deletion: clearing a hash inside the occupied prefix
\ would hide all later records from lookup, counting, reset and iteration.
\ ForthBase hash$ must return nonzero because zero denotes an unused record.
\
\ Keep ordered-map.max-records unchanged while any maps are allocated:
\ allocation, scans and erasure all use this global size, not a saved header.
\ The record layout assumes a four-byte hash cell. If changing field sizes,
\ also change the 59/255 limits, key-buffer size and reset's 256-byte erase.
\ Normalization storage is task-local, so independent maps can be used by
\ concurrent tasks. Callers must still serialize access to the same map.
\ Lookup, assignment and count scan at most max-records entries, O(capacity);
\ reset and iteration are O(count), erase and allocation O(capacity) bytes.
\ No lookup, assignment or iteration allocates memory.

NEED ForthBase

\ Global capacity for every map; set only when no allocated maps exist.
1024 value ordered-map.max-records

\ Record size and field offsets; counted strings include their length byte.
BEGIN-STRUCTURE ordered-map.record
      4 +FIELD ordered-map.key-hash     \ zero means unused
     60 +FIELD ordered-map.key          \ counted uppercase string
    256 +FIELD ordered-map.value        \ counted string
END-STRUCTURE

: erase-map ( map -- )
\ Clear the entire array, forgetting keys, values and insertion order.
    ordered-map.max-records ordered-map.record * erase
;

: allocate-map ( -- map )
\ Allocate and zero one array on the heap; the caller must later free it.
    ordered-map.max-records ordered-map.record * allocate
        abort" unable to allocate map"
    dup erase-map
;

: free-map ( map -- )
\ Release an allocated array; invalidate its address and all borrowed strings.
    free if cr ." unable to free map" cr then
;

\ Internal addressing and lookup. Every scan is bounded by max-records.
: ordered-map.entry ( index map -- entry )
\ Address a zero-based record; internal callers supply an in-range index.
    swap ordered-map.record * +
;

\ Task-local counted-string workspace, also used when map! stores a new key.
60 +USER ordered-map.key-buffer

: ordered-map.hash ( c-addr u -- hash )
\ Normalize into key-buffer and hash that copy, leaving the input unchanged.
\ Truncate BEFORE hashing so stored key text and lookup identity agree.
    59 min ordered-map.key-buffer place
    ordered-map.key-buffer count upper
    ordered-map.key-buffer count hash$
;

: ordered-map.slot { hash map | entry -- entry | 0 }
\ Find a matching hash or the first unused record; return zero if neither.
\ This is a linear scan, not hash-table probing: hashes only test identity.
\ The dense-prefix invariant makes the first unused record both a proven
\ lookup miss and the correct insertion point. A full map has no sentinel,
\ so the explicit capacity bound is essential.
    ordered-map.max-records 0 ?do
        i map ordered-map.entry -> entry
        entry ordered-map.key-hash @ dup 0= swap hash = or if
            entry unloop exit
        then
    loop
    0
;

: ordered-map.value$ ( entry -- c-addr u )
\ Borrow a record's value, canonicalizing every empty string to ( 0 0 ).
    ordered-map.value count
    dup 0= if 2drop 0 0 then
;

: map-count { map -- n }
\ Count the occupied prefix, including empty values; a full map is bounded.
    ordered-map.max-records 0 ?do
        i map ordered-map.entry ordered-map.key-hash @ 0= if
            i unloop exit
        then
    loop
    ordered-map.max-records
;

: reset-map { map -- }
\ Empty all retained values without freeing slots or changing key order.
    map map-count 0 ?do
        i map ordered-map.entry ordered-map.value 256 erase
    loop
;

: map@ { key-addr key-u map | entry -- value-addr value-u }
\ Look up a normalized key; return a borrowed value or exactly ( 0 0 ).
\ A missing key may yield an unused slot, whose zeroed value is also empty.
    key-addr key-u ordered-map.hash map ordered-map.slot -> entry
    entry 0= if 0 0 exit then
    entry ordered-map.value$
;

: map! { value-addr value-u key-addr key-u map | hash entry -- }
\ Copy a value into an existing record or append a new normalized key.
\ slot leaves key-buffer intact; copy it only on insertion, preserving the
\ original stored key and position on updates (including hash collisions).
    key-addr key-u ordered-map.hash -> hash
    hash map ordered-map.slot -> entry
    entry 0= if cr ." map full" cr exit then
    entry ordered-map.key-hash @ 0= if
        ordered-map.key-buffer count entry ordered-map.key place
        hash entry ordered-map.key-hash !
    then
    value-addr value-u 255 min entry ordered-map.value place
;

: =>" ( value-addr value-u map <key>" -- )
\ Assign using a key parsed through the next quote, e.g. map =>" OBJECT".
\ In compiled code SLITERAL saves the parsed key for runtime; ROT then puts
\ the map after that key, matching map!'s argument order in either state.
    state @ if
        '"' parse postpone sliteral
        postpone rot postpone map!
    else
        '"' parse rot map!
    then
; immediate

: map-for-each { xt map | entry -- }
\ Execute xt once per stored key, in insertion order, without key lookups.
\ Callback: ( i*x key-addr key-u value-addr value-u -- j*x ).
\ Lower stack items may carry an accumulator between callback invocations.
\ Key/value strings are borrowed; copy them if they must outlive the map data.
\ Visit retained empty values too. Do not add keys, erase, or free in callbacks.
\ The loop captures count once; structural mutation would invalidate its view.
    map map-count 0 ?do
        i map ordered-map.entry -> entry
        entry ordered-map.key count entry ordered-map.value$ xt execute
    loop
;

: ordered-map.print { key-addr key-u value-addr value-u -- }
\ Iteration callback: print a newline, key, two tabs and value.
    cr key-addr key-u type 9 emit 9 emit value-addr value-u type
;

: .map ( map -- )
\ Display every retained key/value pair in insertion order; finish with CR.
    ['] ordered-map.print swap map-for-each cr
;
