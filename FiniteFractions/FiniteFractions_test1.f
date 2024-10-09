\ automated test for FiniteFractions.f

include "%idir%\..\libraries\libraries.f"
include "%idir%\FiniteFractions.f"
NEED simple-tester

CR
Tstart
60 -> ffbasis
T{ 7654 ~~~ }T 2 7 34 ==
T{ -7654 ~~~ }T -2 -7 -34 ==
T{ 2 7 34 ~ }T 7654 ==
T{ -2 -7 -34 ~ }T -7654 ==
T{ 7654 ':' ~$ hashS }T s" 02:07:34" hashS ==
Tend