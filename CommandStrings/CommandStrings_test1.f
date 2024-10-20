\ unit test for CommandStrings.f

include %idir%\..\libraries\libraries.f
include %idir%\CommandStrings.f
NEED simple-tester


create q1 16 allot
create a1 $ff c, $cc c, $dd c, $ee c, $ff c,

CR
Tstart

T{ q1 << >> 0 }T 0 ==
T{ q1 << $ff | >> q1 1 HashS }T a1 1 HashS ==
T{ $ffeeddcc q1 << $ff | $  $  $ | >> q1 5 HashS }T a1 5 HashS ==


Tend
CR