\ Bounded finite-fraction parsing, including the strict three-field form.
NEED FiniteFractions
NEED simple-tester

\ The declared input ends before "#99"; those bytes must not become a third field.
create parsing.short '2' c, '3' c, '*' c, '1' c, '0' c, '#' c, '9' c, '9' c,

: parsing.rejected? { caddr u | status -- flag }
\ Check that an invalid permissive input aborts, releasing CATCH's saved arguments.
    caddr u ['] >number~ catch -> status
    status if 2drop else drop then
    status -2 =
;

: parsing.strict-rejected? { caddr u | status -- flag }
\ Check required coordinate fields and separators without retaining failed inputs.
    caddr u ':' ['] >number3~ catch -> status
    status if drop 2drop else drop then
    status -2 =
;

Tstart
\ Omitted trailing fields are zero, never digits beyond the supplied length.
T{ parsing.short 5 >number~~~ }T 23 10 0 ==
T{ parsing.short 2 >number~~~ }T 23 0 0 ==
T{ s" 0" >number~~~ }T 0 0 0 ==
T{ s" -23" >number~~~ }T -23 0 0 ==
T{ s" -00:42:11.9" >number~ }T -2531 ==
T{ s" 2026-10-25" >number~ }T 2026 10 25 ~ ==
T{ s" 2461082.0" >number~ }T 2461082 0 0 ~ ==
T{ 0 0 parsing.rejected? }T -1 ==
T{ parsing.short -1 parsing.rejected? }T -1 ==
T{ s" -" parsing.rejected? }T -1 ==
T{ s" bad" parsing.rejected? }T -1 ==
T{ s" 00::00" parsing.rejected? }T -1 ==
T{ s" 4294967296:00:00" parsing.rejected? }T -1 ==

\ Strict callers require three fields and reject malformed final numeric text.
T{ s" 04:29:05.9" ':' >number3~ }T 4 29 5 ~ ==
T{ s" +04 29 05.0" ':' >number3~ }T 4 29 5 ~ ==
T{ s" -00:42:11.9" ':' >number3~ }T -2531 ==
T{ s" 2026-10-25" '-' >number3~ }T 2026 10 25 ~ ==
T{ 0 0 parsing.strict-rejected? }T -1 ==
T{ s" -" parsing.strict-rejected? }T -1 ==
T{ s" 04:29" parsing.strict-rejected? }T -1 ==
T{ s" 04:29:" parsing.strict-rejected? }T -1 ==
T{ s" 04::05" parsing.strict-rejected? }T -1 ==
T{ s" 04-29-05" parsing.strict-rejected? }T -1 ==
T{ s" 04:29:bad" parsing.strict-rejected? }T -1 ==
T{ s" 04:29:05.bad" parsing.strict-rejected? }T -1 ==
T{ s" 4294967296:00:00" parsing.strict-rejected? }T -1 ==
T{ fdepth }T 0 ==
Tend
