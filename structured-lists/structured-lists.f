\ Named records and zero-terminated lists of record references.
\ Declare records with CREATE and domain-specific storage; declare lists with
\ CREATE followed by references compiled with , and a final 0 ,.
\ No dictionary allocation may be interleaved with list construction.
\ Zero is reserved for the terminator; records may belong to multiple lists.
\
\ Supplied predicates and comparison words consume record references and
\ return one flag, preserving any underlying context cells. Here, context
\ means any number of caller-supplied stack values, including none.
\ These words must not alter the list being traversed; LIST-FROM predicates
\ must not allocate dictionary storage.
\ Only ITEM-NAME depends on VFX's dictionary representation.

: ITEM-NAME { ref | xt nfa -- caddr u }
\ Recover the dictionary name of a CREATE child, or 0 0 when not found.
\ Check the exact body address, not merely the nearest preceding name.
    ref body> to xt
    xt inForth? 0= if 0 0 exit then
    xt >name to nfa
    nfa name> xt = if nfa count else 0 0 then
;

: COUNT-LIST ( list -- n )
    dup
    begin dup @ while cell+ repeat
    swap - 1 cells /
;

: ITEM-IN-LIST? { ref list | index -- n TRUE | FALSE }
\ Return the first occurrence, numbered from zero.
    0 to index
    begin list @ while
        list @ ref = if index true exit then
        list cell+ to list
        index 1+ to index
    repeat
    false
;

: SORT-LIST { compare list | current position -- }
\ ( context xt list -- context )
\ xt is the execution token of the comparison word:
\ ( context item1 item2 -- context flag )
\ Return true when item1 belongs before or equal to item2, in the requested
\ top-to-bottom order.
\ Stable in-place insertion sort using adjacent swaps; no result buffer.
    list @ 0= if exit then
    list cell+ to current
    begin current @ while
        current to position
        begin
            position list > if
                position cell- @ position @ compare execute 0=
            else false then
        while
            position @ position cell- @
            position ! position cell- !
            position cell- to position
        repeat
        current cell+ to current
    repeat
;

: QUERY-LIST { predicate list -- }
\ ( context xt list -- context ref|0 )
\ xt is the execution token of the predicate:
\ ( context item -- context flag )
\ Return the first reference for which the predicate is true, or 0 if none.
    begin list @ while
        list @ predicate execute if list @ exit then
        list cell+ to list
    repeat
    0
;

: LIST-FROM { predicate list -- }
\ ( context xt list <name> -- context )
\ xt is the execution token of a predicate with the same stack effect as
\ in QUERY-LIST. Define <name> to return a new list of matching references.
\ Preserve source order and duplicates; records and source list are unchanged.
    create
    begin list @ while
        list @ predicate execute if list @ , then
        list cell+ to list
    repeat
    0 ,
;
