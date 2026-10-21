\ test for ForthBase.f

need forthBase
need simple-tester

\ This four-byte FNV-1a preimage hashes to zero before the nonzero mapping.
create hash-zero-vector $cc c, $24 c, $31 c, $c4 c,

Tstart

T{ 'a' $811c9dc5 hash }T $e40c292c ==
T{ $c4 $c4 hash }T 0 ==
T{ 0 0 hash$ }T $811c9dc5 ==
T{ s" a" hash$ }T $e40c292c ==
T{ s" foobar" hash$ }T $bf9cf968 ==
T{ hash-zero-vector 4 hash$ }T 1 ==

s" First" $value my$value
T{ my$value hashS }T s" First" hashS ==
T{ s" Second" $-> my$value my$value hashS }T s" Second" hashS ==

: inside s" Third" $-> my$value ;
T{ inside my$value hashS }T s" Third" hashS ==

s" First" $value my$value01
T{ my$value01 hashS }T s" First" hashS ==
T{ s" Second" $+> my$value01 my$value01 hashS }T s" FirstSecond" hashS ==  
  
: inside01 s" Third" $+> my$value01 ;
T{ inside01 my$value01 hashS }T s" FirstSecondThird" hashS ==  

T{ <$ s" This is" $ BL _ s" a string" $ '!' _ $> hashS }T s" This is a string!" hashS ==

: inside02 <$ s" This is" $ BL _ s" a string" $ '!' _ $> ;
T{ inside02 hashS }T s" This is a string!" hashS ==

\ VFX parses signed single integers; explicit doubles and malformed input fail.
T{ s" 0" single-integer? }T 0 -1 ==
T{ s" 55490" single-integer? }T 55490 -1 ==
T{ s" 2147483647" single-integer? }T 2147483647 -1 ==
T{ s" " single-integer? }T 0 ==
T{ s" -1" single-integer? }T -1 -1 ==
T{ s" 12x" single-integer? }T 0 ==
T{ s" 123." single-integer? }T 0 ==

\ Compile the input routine against a finite sequence of mistyped readings.
0 value input-test-count
: accept { addr capacity | text u -- u }
    input-test-count case
        0 of s" bad" endof
        1 of s" -1" endof
        2 of s" 11" endof
        s" 7" rot
    endcase -> u -> text
    text addr u move
    input-test-count 1+ -> input-test-count
    u
;
include %idir%\Input.f
T{ 2 10 s" Reading: " input }T 7 ==
T{ input-test-count }T 4 ==

Tend 
