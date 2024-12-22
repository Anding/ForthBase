\ automated test for FiniteFractions.f

include "%idir%\..\libraries\libraries.f"
include "%idir%\FiniteFractions.f"
NEED simple-tester

CR
Tstart
T{ 7654 ~~~ }T 2 7 34 ==
T{ -7654 ~~~ }T -2 -7 -34 ==
T{ 2 7 34 ~ }T 7654 ==
T{ -2 -7 -34 ~ }T -7654 ==
T{ 7654 ~$ hashS }T s" 02:07:34" hashS ==
-1 -> ffForcePlus
T{ 7654 ~$ hashS }T s" +02:07:34" hashS ==
T{ -7654 ~$ hashS }T s" -02:07:34" hashS ==
T{ s" 20:58:59" >number~~~ }T 20 58 59 ==
T{ s" 20:58:59.99" >number~~~ }T 20 58 59 ==
T{ s" -181:58:59" >number~~~ }T -181 -58 -59 ==
T{ s" 23*10" >number~~~ }T 23 10 0 ==
T{ s" +22ß09:12#" >number~~~ }T 22 9 12 ==
T{ s" -29ß41:18#" >number~~~ }T -29 -41 -18 ==
Tend