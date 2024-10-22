\ unit test for CommandStrings.f

include %idir%\..\libraries\libraries.f
include %idir%\CommandStrings.f
NEED simple-tester


create q1 16 allot
create a1 $ff c, $cc c, $dd c, $ee c, $ff c,
create a2 $ff c, $cc c, $dd c, $ef c, $ff c,
create a3 'x' c, ':' c, '2' c, '5' c,

CR
Tstart

T{
	q1 << >>
	
}T q1 0 ==

T{
	q1 << $ff | >> 
	
HashS }T a1 1 HashS ==

T{ 
	$ffeeddcc q1 << $ff | $ | $ | $ | $ | drop >> 
	
HashS }T a1 5 HashS ==

T{
	q1 << _ | _ | _ | _ 1+ | _  | >>

HashS }T a2 5 HashS ==

T{
	q1 << s" x:25" ..| >>
	
HashS }T a3 4 HashS ==

T{
	q1 << 'x' | ':' | 25 (.) ..| >>
	
HashS }T a3 4 HashS ==

Tend
CR