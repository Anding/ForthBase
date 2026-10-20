\ Standalone map tutorial: no camera, image formats, or forth-map required.
NEED ordered-maps
NEED simple-tester

allocate-map constant om.first
map constant om.second
ordered-map constant om.third
create om.long-key 80 allot
create om.long-value 300 allot
create om.key-pairs 6 cells allot
variable om.original-address
variable om.dictionary
variable om.visits

om.long-key 80 'a' fill
om.long-value 300 'x' fill

: om.key-hash ( c-addr u map -- hash )
    drop hash$
;

: om.stop ( n c-addr u -- n+1 false )
    2drop 1+ false
;

: om.visit ( c-addr u map -- )
    2drop drop 1 om.visits +!
;

: om.missing ( -- )
    s" absent" om.first >string 2drop
;

: om.negative-index ( -- )
    -1 om.first ordered-map-entry drop
;

: om.past-end ( -- )
    ordered-map.max-records om.first ordered-map-entry drop
;

Tstart

\ Standard FNV-1a vectors, including an empty key.
T{ 0 0 hash$ }T $811c9dc5 ==
T{ s" a" hash$ }T $e40c292c ==
T{ s" foobar" hash$ }T $bf9cf968 ==
T{ [defined] wordlist-map? }T 0 ==
T{ om.first count-keys om.second count-keys om.third count-keys }T 0 0 0 ==
T{ s" absent" om.first item? }T 0 0 ==
T{ om.first count-keys }T 0 ==
T{ ' om.missing catch 0<> }T -1 ==
T{ om.first count-keys }T 0 ==
T{ ' om.negative-index catch 0<> }T -1 ==
T{ ' om.past-end catch 0<> }T -1 ==
T{ 0 om.first ordered-map-entry }T om.first ==
T{ ordered-map.max-records 1- om.first ordered-map-entry om.first - }T
    ordered-map.max-records 1- ordered-map.record * ==

\ Both quoted assignment forms work; values keep their original case.
T{ s" Mixed case" om.first =>" alpha" }T ==
: om.add-second ( -- ) s" second" om.first =>" beta" ;
T{ om.add-second }T ==
T{ om.first count-keys }T 2 ==
T{ s" ALPHA" om.first >string s" Mixed case" compare }T 0 ==
T{ s" aLpHa" om.first item? nip }T -1 ==
T{ 0 om.first ordered-map-entry ordered-map.key count s" ALPHA" compare }T 0 ==
T{ 0 om.first ordered-map-entry ordered-map.key-hash @ }T s" ALPHA" hash$ ==
T{ s" alpha" om.first >addr }T
    0 om.first ordered-map-entry ordered-map.value ==
s" alpha" om.first >addr om.original-address !
T{ s" replacement" s" ALpha" om.first => }T ==
T{ s" ALPHA" om.first >addr }T om.original-address @ ==
T{ om.first count-keys }T 2 ==
T{ s" ALPHA" om.first >string s" replacement" compare }T 0 ==
T{ ' om.key-hash om.first simple-iterate-map }T
    s" ALPHA" hash$ s" BETA" hash$ ==
T{ 0 ' iterator-for-counting om.first iterate-map }T 2 ==
T{ 0 ' om.stop om.first iterate-map }T 1 ==

\ buffer-keys exposes address/length pairs in insertion order.
T{ om.key-pairs 6 cells + om.first buffer-keys }T om.key-pairs 2 cells + ==
T{ om.key-pairs 2 cells + 2@ swap s" ALPHA" compare }T 0 ==
T{ om.key-pairs 4 cells + 2@ swap s" BETA" compare }T 0 ==
T{ 1234 om.first .map }T 1234 ==

\ Truncation precedes hashing. Different suffixes after byte 59 are one key.
T{ om.long-value 300 om.long-key 80 om.second => }T ==
T{ om.second count-keys }T 1 ==
T{ om.long-key 59 om.second >string nip }T 255 ==
T{ om.long-key 80 om.second >string om.long-value 255 compare }T 0 ==
T{ 0 om.second ordered-map-entry ordered-map.key count nip }T 59 ==
'b' om.long-key 79 + c!
T{ s" truncated" om.long-key 80 om.second => }T ==
T{ om.second count-keys }T 1 ==
T{ om.long-key 59 om.second >string s" truncated" compare }T 0 ==
T{ om.long-key c@ }T 'a' ==
T{ om.long-value c@ }T 'x' ==
T{ om.long-value 255 om.long-key 60 om.second => }T ==
T{ om.long-key 60 om.second >string nip }T 255 ==
T{ om.long-value 256 om.long-key 59 om.second => }T ==
T{ om.long-key 59 om.second >string om.long-value 255 compare }T 0 ==
T{ om.second count-keys }T 1 ==

\ Empty strings and empty keys are valid; a read of a miss remains an error.
T{ 0 0 0 0 om.third => }T ==
T{ om.third count-keys }T 1 ==
T{ 0 0 om.third >string nip }T 0 ==
T{ 0 om.third ordered-map-entry ordered-map.key-hash @ }T $811c9dc5 ==
T{ s" created" om.third >addr c@ }T 0 ==
T{ om.third count-keys }T 2 ==
T{ s" 42" om.third =>" NUMBER" }T ==
T{ s" number" om.third >integer }T 42 ==
T{ s" -17" om.third =>" NUMBER" }T ==
T{ s" NUMBER" om.third >integer }T -17 ==
T{ s" not a number" om.third =>" NUMBER" }T ==
T{ s" NUMBER" om.third >integer }T 0 ==

\ Maps own independent storage. Reset reuses the same allocation and slots.
T{ s" ALPHA" om.second item? }T 0 0 ==
T{ 1234 om.first reset-map }T 1234 ==
T{ om.first count-keys }T 0 ==
T{ s" ALPHA" om.first item? }T 0 0 ==
0 om.visits !
T{ ' om.visit om.first simple-iterate-map om.visits @ }T 0 ==
T{ 0 ' om.stop om.first iterate-map }T 0 ==
T{ om.key-pairs om.first buffer-keys }T om.key-pairs ==
here om.dictionary !
T{ s" fresh" s" FIRST" om.first => }T ==
T{ here }T om.dictionary @ ==
T{ s" FIRST" om.first >addr }T om.original-address @ ==
T{ om.second count-keys }T 1 ==
T{ 1234 om.first free-map }T 1234 ==
T{ om.second free-map om.third free-map }T ==

Tend
