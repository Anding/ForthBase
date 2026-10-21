\ VFX single-cell integers and range-checked terminal input.

: single-integer? ( caddr u -- n true | false )
    isNumber? ( caddr u -- d 2 | n 1 | 0) \ VFX word
    case
        0 OF false exit ENDOF
        2 OF 2drop false exit ENDOF
        ENDCASE
    ( n) true
;

: input { low high prompt u -- n }
\ Retry malformed or out-of-range input; LOW and HIGH are inclusive.
    begin
        prompt u type
        pad 31 accept pad swap single-integer? if
            dup low >= over high <= and if exit then
            drop
        then
        cr ." Enter an integer from " low . ." to " high . cr
    again
;
