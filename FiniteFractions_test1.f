\ automated test for FiniteFractions.f

include "%idir%\FiniteFractions.f"
include "%idir%\..\simple-tester\simple-tester.f"

CR
Tstart
60 -> ffbasis
T{ 7654 ~~~ }T 2 7 34 ==
T{ -7654 ~~~ }T -2 -7 -34 ==
T{ 2 7 34 ~ }T 7654 ==
T{ -2 -7 -34 ~ }T -7654 ==
T{ 7654 ':' ~$ s" 02:07:34" ( string compare) }T -1 ==
Tend