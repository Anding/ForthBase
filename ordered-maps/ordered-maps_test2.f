\ Exercise all 1024 slots, reset versus erase, and both allocation boundaries.
NEED ordered-maps
NEED simple-tester

\ Guard records exist only in this test, not in the implementation.
ordered-map.max-records 2 + ordered-map.record * allocate throw constant om.storage
om.storage ordered-map.record + constant om.full
om.storage ordered-map.max-records 1+ ordered-map.record * + constant om.end
om.storage ordered-map.record 85 fill
om.end ordered-map.record 170 fill
om.full erase-map
variable om.here

: om.fill ( -- )
    ordered-map.max-records 0 ?do
        i (.) s" payload" 2swap om.full map!
    loop
;

: om.overflow ( -- )
    s" extra" s" OVERFLOW" om.full map!
;

: om.quoted-overflow ( -- )
    s" extra" om.full =>" OVERFLOW"
;

: om.check-pair { index key-addr key-u value-addr value-u -- index+1 }
    key-addr key-u index (.) compare abort" wrong iteration order"
    value-addr value-u s" payload" compare abort" wrong iteration value"
    index 1+
;

: om.check-empty { index key-addr key-u value-addr value-u -- index+1 }
    key-addr key-u index (.) compare abort" reset changed a key"
    value-addr value-u or abort" reset value is not 0 0"
    index 1+
;

: om.guards? ( -- flag )
    true
    ordered-map.record 0 ?do
        om.storage i + c@ 85 = and
        om.end i + c@ 170 = and
    loop
;

: om.erased? ( -- flag )
    true
    ordered-map.max-records ordered-map.record * 0 ?do
        om.full i + c@ 0= and
    loop
;

: om.reuse ( -- )
    3 0 do
        om.full reset-map
        om.fill
    loop
;

Tstart

T{ ordered-map.max-records }T 1024 ==
T{ om.erased? }T -1 ==
here om.here !
T{ om.fill }T ==
T{ om.full map-count }T 1024 ==
T{ here }T om.here @ ==
T{ om.guards? }T -1 ==
T{ s" 0" om.full map@ s" payload" compare }T 0 ==
T{ s" 1023" om.full map@ s" payload" compare }T 0 ==
T{ s" missing" om.full map@ }T 0 0 ==
T{ ' om.overflow catch }T -2 ==
T{ ' om.quoted-overflow catch }T -2 ==
T{ om.full map-count }T 1024 ==
T{ s" OVERFLOW" om.full map@ }T 0 0 ==
T{ om.guards? }T -1 ==
T{ 0 ' om.check-pair om.full map-for-each }T 1024 ==

\ Replacement succeeds even at capacity and never creates another record.
T{ s" replacement" om.full =>" 1023" }T ==
T{ s" 1023" om.full map@ s" replacement" compare }T 0 ==
T{ om.full map-count }T 1024 ==
T{ s" payload" om.full =>" 1023" }T ==

\ Reset retains ALL occupied slots; only the existing keys can be rewritten.
T{ om.full reset-map om.full map-count }T 1024 ==
T{ 0 ' om.check-empty om.full map-for-each }T 1024 ==
T{ s" 0" om.full map@ }T 0 0 ==
T{ s" 1023" om.full map@ }T 0 0 ==
T{ ' om.overflow catch }T -2 ==
T{ om.guards? }T -1 ==
T{ om.reuse }T ==
T{ om.full map-count }T 1024 ==
T{ 0 ' om.check-pair om.full map-for-each }T 1024 ==
T{ here }T om.here @ ==
T{ om.guards? }T -1 ==

\ Erase clears every byte, recovers capacity and leaves the guards untouched.
T{ om.full erase-map om.full map-count }T 0 ==
T{ om.erased? }T -1 ==
T{ om.guards? }T -1 ==
T{ s" recovered" om.full =>" OVERFLOW" }T ==
T{ s" OVERFLOW" om.full map@ s" recovered" compare }T 0 ==
T{ om.full map-count }T 1 ==
T{ om.guards? }T -1 ==
T{ om.storage free-map }T ==

Tend
