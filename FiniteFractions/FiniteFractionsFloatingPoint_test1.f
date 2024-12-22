\ automated test for FiniteFractionsFloatingPoint.f

include "%idir%\..\libraries\libraries.f"
include "%idir%\FiniteFractions.f"
include "%idir%\FiniteFractionsFloatingPoint.f"
NEED simple-tester

CR
Tstart
T{ 10 20 30 ~~~fp 6 (f.) hashS }T  s" 10.341667" hashS ==
T{ -10 -20 -30 ~~~fp 6 (f.) hashS }T  s" -10.341667" hashS ==
T{ s" 10.508333" >float drop fp~~~ }T 10 30 30 ==
T{ s" 10.999722" >float drop fp~~~ }T 10 59 59 ==
T{ s" -10.999722" >float drop fp~~~ }T -10 -59 -59 ==
T{ s" 0.016944" >float drop fp~~~ }T 0 1 1 ==
T{ s" -0.016944" >float drop fp~~~ }T 0 -1 -1 ==
Tend