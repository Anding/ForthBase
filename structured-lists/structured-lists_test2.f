\ Ordering, stable ties, independent list membership and callback context.
NEED structured-lists
NEED simple-tester

create sl2.a 30 ,
create sl2.b 10 ,
create sl2.c 20 ,
create sl2.d 20 ,
create sl2.items sl2.a , sl2.c , sl2.b , sl2.d , sl2.c , 0 , 12345 ,
create sl2.original sl2.a , sl2.c , sl2.b , sl2.d , sl2.c , 0 ,
create sl2.empty 0 ,
create sl2.single sl2.a , 0 ,

: sl2.ascending { first second -- flag }
    first @ second @ <=
;

: sl2.descending { first second -- flag }
    first @ second @ >=
;

: sl2.nearer { origin marker first second -- origin marker flag }
\ Two context cells are consumed and returned by each comparison.
    origin marker
    first @ origin - abs second @ origin - abs <=
;

: sl2.in-range { low high item -- low high flag }
    low high item @ low >= item @ high <= and
;

: sl2.unexpected ( -- )
\ Record an unexpected callback without interrupting the regression.
    1 Tfailures +!
    cr ." Callback must not run for an empty query or a list shorter than two" cr
;

Tstart

T{ 7 8 ' sl2.unexpected sl2.empty SORT-LIST }T 7 8 ==
T{ 7 8 ' sl2.unexpected sl2.single SORT-LIST }T 7 8 ==
T{ 7 8 ' sl2.unexpected sl2.empty QUERY-LIST }T 7 8 0 ==

' sl2.ascending sl2.items SORT-LIST
T{ sl2.items @ sl2.items cell+ @ sl2.items 2 cells + @
   sl2.items 3 cells + @ sl2.items 4 cells + @ }T
   sl2.b sl2.c sl2.d sl2.c sl2.a ==
T{ sl2.items 5 cells + @ sl2.items 6 cells + @ }T 0 12345 ==
T{ sl2.original @ sl2.original cell+ @ sl2.original 2 cells + @ }T
   sl2.a sl2.c sl2.b ==

\ Sorting an already ordered list preserves the order of equal keys.
' sl2.ascending sl2.items SORT-LIST
T{ sl2.items cell+ @ sl2.items 2 cells + @ sl2.items 3 cells + @ }T
   sl2.c sl2.d sl2.c ==

' sl2.descending sl2.items SORT-LIST
T{ sl2.items @ sl2.items cell+ @ sl2.items 2 cells + @
   sl2.items 3 cells + @ sl2.items 4 cells + @ }T
   sl2.a sl2.c sl2.d sl2.c sl2.b ==

T{ 12 999 ' sl2.nearer sl2.items SORT-LIST }T 12 999 ==
T{ sl2.items @ sl2.items cell+ @ sl2.items 2 cells + @
   sl2.items 3 cells + @ sl2.items 4 cells + @ }T
   sl2.b sl2.c sl2.d sl2.c sl2.a ==

T{ 20 25 ' sl2.in-range sl2.items QUERY-LIST }T 20 25 sl2.c ==
T{ 31 40 ' sl2.in-range sl2.items QUERY-LIST }T 31 40 0 ==
T{ 10 20 ' sl2.in-range sl2.items LIST-FROM sl2.range }T 10 20 ==
T{ sl2.range COUNT-LIST }T 4 ==
T{ sl2.range @ sl2.range cell+ @ sl2.range 2 cells + @
   sl2.range 3 cells + @ }T sl2.b sl2.c sl2.d sl2.c ==
T{ 7 8 ' sl2.unexpected sl2.empty LIST-FROM sl2.from-empty }T 7 8 ==
T{ sl2.from-empty COUNT-LIST }T 0 ==

' sl2.descending sl2.range SORT-LIST
T{ sl2.range @ sl2.range 3 cells + @ }T sl2.c sl2.b ==
T{ sl2.items @ sl2.items 4 cells + @ }T sl2.b sl2.a ==
T{ sl2.a @ sl2.b @ sl2.c @ sl2.d @ }T 30 10 20 20 ==

\ Lists themselves can be records in an ordinary list of references.
create sl2.lists sl2.empty , sl2.range , sl2.items , 0 ,
: sl2.nonempty ( list -- flag ) COUNT-LIST 0<> ;
T{ ' sl2.nonempty sl2.lists QUERY-LIST }T sl2.range ==
' sl2.nonempty sl2.lists LIST-FROM sl2.nonempty-lists
T{ sl2.nonempty-lists COUNT-LIST }T 2 ==
T{ sl2.nonempty-lists @ sl2.nonempty-lists cell+ @ }T
   sl2.range sl2.items ==

Tend
