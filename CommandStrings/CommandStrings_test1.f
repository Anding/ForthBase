\ unit test for CommandStrings.f

include %idir%\..\libraries\libraries.f
include %idir%\CommandStrings.f
NEED simple-tester


create q1 16 allot
create a1 $ff c, $cc c, $dd c, $ee c, $ff c,
create a2 $ff c, $cc c, $dd c, $ef c, $ff c,

CR
Tstart

q1 << >>
	T{ 0 }T 0 ==

q1 << $ff | >> 
	T{ q1 1 HashS }T a1 1 HashS ==

$ffeeddcc q1 << $ff | $ | $ | $ | $ | >> drop
	T{ q1 5 HashS }T a1 5 HashS ==

q1 << _ | _ | _ | _ 1+ | _  | >>
	T{ q1 5 HashS }T a2 5 HashS ==

Tend
CR