\ Ordered string maps: assignment, lookup, iteration, reset and erase.
\ No hardware, image formats, or forth-map is loaded.
NEED ordered-maps
NEED simple-tester

allocate-map constant om.first
allocate-map constant om.second
allocate-map constant om.third
create om.long-key 80 allot
create om.long-value 300 allot
variable om.original-address
variable om.dictionary
variable om.visits

om.long-key 80 'a' fill
om.long-value 300 'x' fill

: om.pair-hashes { key-addr key-u value-addr value-u -- key-hash value-hash }
    key-addr key-u hash$ value-addr value-u hash$
;

: om.empty-pair { key-addr key-u value-addr value-u -- key-hash value-addr value-u }
    key-addr key-u hash$ value-addr value-u
;

: om.count-pair ( n key-addr key-u value-addr value-u -- n+1 )
    2drop 2drop 1+
;

: om.visit ( key-addr key-u value-addr value-u -- )
    2drop 2drop 1 om.visits +!
;

: om.projection-bytes { total key-addr key-u value-addr value-u -- total' }
    total key-u + value-u + 3 +
;

Tstart

\ Only the new map API is loaded, not compatibility words from forth-map.
T{ [defined] wordlist-map? }T 0 ==
T{ [defined] >addr }T 0 ==
T{ [defined] >string }T 0 ==
T{ [defined] => }T 0 ==
T{ [defined] iterate-map }T 0 ==
T{ [defined] simple-iterate-map }T 0 ==
T{ [defined] buffer-keys }T 0 ==
T{ om.first map-count om.second map-count om.third map-count }T 0 0 0 ==
T{ s" absent" om.first map@ }T 0 0 ==
T{ 1234 s" absent" om.first map@ }T 1234 0 0 ==
T{ om.first map-count }T 0 ==
T{ 0 ' om.count-pair om.first map-for-each }T 0 ==
T{ 1234 om.first .map }T 1234 ==

\ Quoted assignment works in interpretation and compilation.
T{ s" Mixed case" om.first =>" alpha" }T ==
: om.add-second ( -- ) s" second" om.first =>" beta" ;
T{ om.add-second }T ==
T{ om.first map-count }T 2 ==
T{ s" ALPHA" om.first map@ s" Mixed case" compare }T 0 ==
T{ s" aLpHa" om.first map@ s" Mixed case" compare }T 0 ==
T{ s" alpha" om.first map@ drop }T
    om.first ordered-map.value 1+ ==
s" alpha" om.first map@ drop om.original-address !
T{ s" replacement" s" ALpha" om.first map! }T ==
T{ s" ALPHA" om.first map@ drop }T om.original-address @ ==
T{ om.first map-count }T 2 ==
T{ s" ALPHA" om.first map@ s" replacement" compare }T 0 ==

\ Iteration supplies key AND value, in insertion order, without another lookup.
T{ ' om.pair-hashes om.first map-for-each }T
    s" ALPHA" hash$ s" replacement" hash$
    s" BETA" hash$ s" second" hash$ ==
T{ 0 ' om.count-pair om.first map-for-each }T 2 ==
T{ 1234 0 ' om.projection-bytes om.first map-for-each }T 1234 32 ==
T{ 1234 om.first .map }T 1234 ==

\ Truncation precedes hashing; suffixes after byte 59 do not identify new keys.
T{ om.long-value 300 om.long-key 80 om.second map! }T ==
T{ om.second map-count }T 1 ==
T{ om.long-key 59 om.second map@ nip }T 255 ==
T{ om.long-key 80 om.second map@ om.long-value 255 compare }T 0 ==
T{ om.second ordered-map.key count nip }T 59 ==
'b' om.long-key 79 + c!
T{ s" truncated" om.long-key 80 om.second map! }T ==
T{ om.second map-count }T 1 ==
T{ om.long-key 59 om.second map@ s" truncated" compare }T 0 ==
T{ om.long-key c@ }T 'a' ==
T{ om.long-value c@ }T 'x' ==
T{ om.long-value 255 om.long-key 60 om.second map! }T ==
T{ om.long-key 60 om.second map@ nip }T 255 ==
T{ om.long-value 256 om.long-key 59 om.second map! }T ==
T{ om.long-key 59 om.second map@ om.long-value 255 compare }T 0 ==
T{ om.second map-count }T 1 ==

\ Missing and empty values BOTH return exactly ( 0 0 ), including empty keys.
T{ 0 0 0 0 om.third map! }T ==
T{ om.third map-count }T 1 ==
T{ 0 0 om.third map@ }T 0 0 ==
T{ s" empty-key value" 0 0 om.third map! }T ==
T{ 0 0 om.third map@ s" empty-key value" compare }T 0 ==
T{ 0 0 om.third =>" EMPTY" }T ==
T{ s" EMPTY" om.third map@ }T 0 0 ==
T{ s" 42" om.third =>" NUMBER" }T ==
T{ s" number" om.third map@ toInteger }T 42 ==
T{ om.third map-count }T 3 ==

\ Hash equality, not a second key comparison, is the identity rule.
T{ s" ALIAS" hash$ om.third ordered-map.key-hash ! }T ==
T{ s" alias" om.third map@ s" empty-key value" compare }T 0 ==
T{ s" changed" s" alias" om.third map! }T ==
T{ om.third map-count }T 3 ==
T{ om.third ordered-map.key count nip }T 0 ==

\ Reset keeps keys, hashes, order and count; it empties only value storage.
T{ 1234 om.first reset-map }T 1234 ==
T{ om.first map-count }T 2 ==
T{ s" ALPHA" om.first map@ }T 0 0 ==
T{ s" BETA" om.first map@ }T 0 0 ==
T{ s" absent" om.first map@ }T 0 0 ==
T{ ' om.empty-pair om.first map-for-each }T
    s" ALPHA" hash$ 0 0 s" BETA" hash$ 0 0 ==
0 om.visits !
T{ ' om.visit om.first map-for-each om.visits @ }T 2 ==
T{ 1234 om.first .map }T 1234 ==
here om.dictionary !
T{ s" beta again" om.first =>" beta" }T ==
T{ s" alpha again" om.first =>" ALPHA" }T ==
T{ here }T om.dictionary @ ==
T{ s" ALPHA" om.first map@ drop }T om.original-address @ ==
T{ ' om.pair-hashes om.first map-for-each }T
    s" ALPHA" hash$ s" alpha again" hash$
    s" BETA" hash$ s" beta again" hash$ ==
T{ om.first map-count }T 2 ==
T{ s" third" om.first =>" GAMMA" }T ==
T{ om.first map-count }T 3 ==
T{ om.second map-count }T 1 ==

\ Erase recovers all capacity and allows a fresh insertion sequence.
T{ 1234 om.first erase-map }T 1234 ==
T{ om.first map-count }T 0 ==
T{ s" ALPHA" om.first map@ }T 0 0 ==
T{ 0 ' om.count-pair om.first map-for-each }T 0 ==
T{ om.first reset-map om.first map-count }T 0 ==
T{ s" fresh" om.first =>" GAMMA" }T ==
T{ s" next" om.first =>" ALPHA" }T ==
T{ ' om.pair-hashes om.first map-for-each }T
    s" GAMMA" hash$ s" fresh" hash$ s" ALPHA" hash$ s" next" hash$ ==
T{ 1234 om.first free-map }T 1234 ==
T{ om.second free-map om.third free-map }T ==

Tend
