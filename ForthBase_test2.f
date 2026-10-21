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

\ Decimal parsing rejects signs, suffixes and values outside a signed cell.
T{ s" 0" nonnegative-integer? }T 0 -1 ==
T{ s" 55490" nonnegative-integer? }T 55490 -1 ==
T{ s" 2147483647" nonnegative-integer? }T 2147483647 -1 ==
T{ s" " nonnegative-integer? }T 0 ==
T{ s" -1" nonnegative-integer? }T 0 ==
T{ s" 12x" nonnegative-integer? }T 0 ==
T{ s" 2147483648" nonnegative-integer? }T 0 ==
: invalid-range ( -- ) 11 2 10 check-range ;
T{ ' invalid-range catch 0<> }T -1 ==

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
T{ 2 10 s" Reading: " read-nonnegative }T 7 ==
T{ input-test-count }T 4 ==

Tend 
