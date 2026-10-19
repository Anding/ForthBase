\ Generic records, names, membership, queries and derived lists.
NEED structured-lists
NEED simple-tester

create sl.alpha 30 ,
create sl.beta 10 ,
create sl.gamma 20 ,
create sl.empty 0 ,
create sl.items sl.alpha , sl.beta , sl.gamma , sl.beta , 0 ,

: sl.at-least ( minimum item -- minimum flag )
    @ over >=
;

: sl.any ( item -- flag ) drop true ;
: sl.none ( item -- flag ) drop false ;

\ A name created from a string has the same representation.
s" sl.dynamic" ($create) 40 ,

\ The same CREATE address can be recovered after a name is redefined.
create sl.shadow 1 ,
sl.shadow constant sl.old-shadow
create sl.shadow 2 ,

Tstart

T{ sl.alpha ITEM-NAME hashS }T s" SL.ALPHA" hashS ==
T{ sl.dynamic ITEM-NAME hashS }T s" SL.DYNAMIC" hashS ==
T{ sl.old-shadow ITEM-NAME hashS }T s" SL.SHADOW" hashS ==
T{ sl.shadow ITEM-NAME hashS }T s" SL.SHADOW" hashS ==
T{ sl.items ITEM-NAME hashS }T s" SL.ITEMS" hashS ==
T{ 0 ITEM-NAME }T 0 0 ==
T{ sl.alpha cell+ ITEM-NAME }T 0 0 ==
T{ pad ITEM-NAME }T 0 0 ==

T{ sl.empty COUNT-LIST }T 0 ==
T{ sl.items COUNT-LIST }T 4 ==
T{ sl.alpha sl.items ITEM-IN-LIST? }T 0 -1 ==
T{ sl.gamma sl.items ITEM-IN-LIST? }T 2 -1 ==
T{ sl.beta sl.items ITEM-IN-LIST? }T 1 -1 ==
T{ sl.dynamic sl.items ITEM-IN-LIST? }T 0 ==
T{ sl.alpha sl.empty ITEM-IN-LIST? }T 0 ==
T{ 0 sl.items ITEM-IN-LIST? }T 0 ==

T{ ' sl.any sl.items QUERY-LIST }T sl.alpha ==
T{ ' sl.none sl.items QUERY-LIST }T 0 ==
T{ ' sl.any sl.empty QUERY-LIST }T 0 ==
T{ 20 ' sl.at-least sl.items QUERY-LIST }T 20 sl.alpha ==
T{ 31 ' sl.at-least sl.items QUERY-LIST }T 31 0 ==
T{ 20 ' sl.at-least sl.empty QUERY-LIST }T 20 0 ==

T{ 20 ' sl.at-least sl.items LIST-FROM sl.selected }T 20 ==
T{ sl.selected COUNT-LIST }T 2 ==
T{ sl.selected @ sl.selected cell+ @ }T sl.alpha sl.gamma ==
T{ sl.alpha sl.selected ITEM-IN-LIST? }T 0 -1 ==
T{ sl.alpha sl.items ITEM-IN-LIST? }T 0 -1 ==

' sl.any sl.items LIST-FROM sl.copy
' sl.none sl.items LIST-FROM sl.no-match
' sl.any sl.empty LIST-FROM sl.from-empty
T{ sl.copy COUNT-LIST }T 4 ==
T{ sl.copy 1 cells + @ sl.copy 3 cells + @ }T sl.beta sl.beta ==
T{ sl.copy sl.items <> }T -1 ==
T{ sl.no-match COUNT-LIST sl.from-empty COUNT-LIST }T 0 0 ==
T{ sl.items COUNT-LIST }T 4 ==
T{ sl.alpha @ sl.beta @ sl.gamma @ }T 30 10 20 ==

Tend
