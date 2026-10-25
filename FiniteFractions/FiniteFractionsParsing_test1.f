\ Bounded finite-fraction parsing, including the strict three-field form.
NEED FiniteFractions
NEED simple-tester

\ The declared input ends before "#99"; those bytes must not become a third field.
create parsing.short '2' c, '3' c, '*' c, '1' c, '0' c, '#' c, '9' c, '9' c,

Tstart
\ Omitted trailing fields are zero, never digits beyond the supplied length.
T{ parsing.short 5 >number~~~ }T 23 10 0 ==
T{ parsing.short 2 >number~~~ }T 23 0 0 ==
T{ s" 0" >number~~~ }T 0 0 0 ==
T{ s" -23" >number~~~ }T -23 0 0 ==
T{ s" -00:42:11.9" >number~ }T -2531 ==
T{ s" 2026-10-25" >number~ }T 2026 10 25 ~ ==
T{ s" 2461082.0" >number~ }T 2461082 0 0 ~ ==
T{ s" -23" >number~~~? }T -23 0 0 -1 ==
T{ 0 0 >number~ }T 0 ==
T{ 0 0 >number~~~? }T 0 0 0 0 ==
T{ parsing.short -1 >number~~~? }T 0 0 0 0 ==
T{ s" -" >number~~~? }T 0 0 0 0 ==
T{ s" bad" >number~~~? }T 0 0 0 0 ==
T{ s" 00::00" >number~~~? }T 0 0 0 0 ==
T{ s" 4294967296:00:00" >number~~~? }T 0 0 0 0 ==

\ Strict callers require three fields and reject malformed final numeric text.
T{ s" 04:29:05.9" ':' >number3~ }T 4 29 5 ~ ==
T{ s" +04 29 05.0" ':' >number3~ }T 4 29 5 ~ ==
T{ s" -00:42:11.9" ':' >number3~ }T -2531 ==
T{ s" 2026-10-25" '-' >number3~ }T 2026 10 25 ~ ==
T{ s" 00:00:00" ':' >number3~? }T 0 -1 ==
T{ s" 04:29:05.9" ':' >number3~? }T 4 29 5 ~ -1 ==
T{ s" 04:bad:05" ':' >number3~ }T 0 ==
T{ 0 0 ':' >number3~? }T 0 0 ==
T{ s" -" ':' >number3~? }T 0 0 ==
T{ s" 04:29" ':' >number3~? }T 0 0 ==
T{ s" 04:29:" ':' >number3~? }T 0 0 ==
T{ s" 04::05" ':' >number3~? }T 0 0 ==
T{ s" 04-29-05" ':' >number3~? }T 0 0 ==
T{ s" 04:29:bad" ':' >number3~? }T 0 0 ==
T{ s" 04:29:05.bad" ':' >number3~? }T 0 0 ==
T{ s" 4294967296:00:00" ':' >number3~? }T 0 0 ==
T{ fdepth }T 0 ==
Tend
