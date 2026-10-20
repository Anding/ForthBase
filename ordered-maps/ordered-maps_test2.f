\ Exercise every slot and both ends of the allocation, without a header.
NEED ordered-maps
NEED simple-tester

\ Guard bytes are test-only: map operations must never touch these records.
ordered-map.max-records 2 + ordered-map.record * allocate throw constant om.storage
om.storage ordered-map.record + constant om.full
om.storage ordered-map.max-records 1+ ordered-map.record * + constant om.end
om.storage ordered-map.record 85 fill
om.end ordered-map.record 170 fill
om.full reset-map
variable om.here

: om.fill ( -- )
    ordered-map.max-records 0 ?do
        i (.) s" payload" 2swap om.full =>
    loop
;

: om.overflow ( -- )
    s" extra" s" OVERFLOW" om.full =>
;

: om.first-key ( n c-addr u -- n flag )
    s" 1023" compare abort" iterate-map did not start at the newest key"
    1+ false
;

: om.guards? ( -- flag )
    true
    ordered-map.record 0 ?do
        om.storage i + c@ 85 = and
        om.end i + c@ 170 = and
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
here om.here !
T{ om.fill }T ==
T{ om.full count-keys }T 1024 ==
T{ here }T om.here @ ==
T{ om.guards? }T -1 ==
T{ s" 0" om.full >string s" payload" compare }T 0 ==
T{ s" 1023" om.full >string s" payload" compare }T 0 ==
T{ s" missing" om.full item? }T 0 0 ==
T{ ' om.overflow catch 0<> }T -1 ==
T{ om.full count-keys }T 1024 ==
T{ om.guards? }T -1 ==
T{ s" replacement" om.full =>" 1023" }T ==
T{ s" 1023" om.full >string s" replacement" compare }T 0 ==
T{ om.full count-keys }T 1024 ==
T{ 0 ' iterator-for-counting om.full iterate-map }T 1024 ==
T{ 0 ' om.first-key om.full iterate-map }T 1 ==
T{ om.reuse }T ==
T{ om.full count-keys }T 1024 ==
T{ here }T om.here @ ==
T{ om.guards? }T -1 ==
T{ om.full reset-map om.full count-keys }T 0 ==
T{ om.guards? }T -1 ==
T{ om.storage free-map }T ==

Tend
