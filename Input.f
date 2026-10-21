\ Decimal non-negative integers, limited to the positive signed-cell range.

: nonnegative-integer? { caddr u | n digit -- n true | false }
    u 0= if false exit then
    0 -> n
    caddr u bounds ?do
        i c@ dup '0' < over '9' > or if drop false unloop exit then
        '0' - -> digit
        n 214748364 > n 214748364 = digit 7 > and or if
            false unloop exit
        then
        n 10 * digit + -> n
    loop
    n true
;

: check-range { n low high -- }
    n low < n high > or abort" Integer outside permitted range"
;

: read-nonnegative { low high prompt u -- n }
\ Retry malformed or out-of-range input; LOW and HIGH are inclusive.
    begin
        prompt u type
        pad 31 accept pad swap nonnegative-integer? if
            dup low >= over high <= and if exit then
            drop
        then
        cr ." Enter an integer from " low . ." to " high . cr
    again
;
