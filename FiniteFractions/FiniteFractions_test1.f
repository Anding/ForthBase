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
T{ -7654 ~$ hashS }T s" -02:07:34" hashS ==
T{ 4032 '*' ':' -1 ~custom$ hashS }T s" +01*07:12" hashS ==
T{ -4032 '*' ':' 0 ~custom$ hashS }T s" -01*07:12" hashS ==
T{ -1 ~$ hashS }T s" -00:00:01" hashS ==
T{ -1800 ':' ':' -1 ~custom$ hashS }T s" -00:30:00" hashS ==
T{ -3599 ':' ':' 0 ~custom$ hashS }T s" -00:59:59" hashS ==
T{ 0 -30 0 ~~~$ hashS }T s" -00:30:00" hashS ==
T{ 1800 ':' ':' -1 ~custom$ hashS }T s" +00:30:00" hashS ==
T{ 0 ':' ':' -1 ~custom$ hashS }T s" +00:00:00" hashS ==
T{ s" 20:58:59" >number~~~ }T 20 58 59 ==
T{ s" 20:58:59.99" >number~~~ }T 20 58 59 ==
T{ s" -181:58:59" >number~~~ }T -181 -58 -59 ==
T{ s" 23*10" >number~~~ }T 23 10 0 ==
T{ s" +22ß09:12#" >number~~~ }T 22 9 12 ==
T{ s" -29ß41:18#" >number~~~ }T -29 -41 -18 ==
Tend