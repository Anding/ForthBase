\ test for shared.f

include "%idir%\..\libraries\libraries.f"
include "%idir%\shared.f"
NEED simple-tester

CR
Tstart

\ Shared needs neither the legacy map library nor the new ordered maps.
T{ [defined] >addr }T 0 ==
T{ [defined] allocate-map }T 0 ==

	variable var1 
	10 var1 !
	shared variable var1 
	shared variable var2
	20 var2 !
	
T{ var1 @ }T 10 ==
T{ var2 @ }T 20 ==

	10 constant con1 
	20 shared constant con1 
	20 shared constant con2
	
T{ con1 }T 10 ==
T{ con2 }T 20 ==

	10 value val1 
	20 shared value val1 
	20 shared value val2
	
T{ val1 }T 10 ==
T{ val2 }T 20 ==

	10 11 2value vals1 
	20 21 shared 2value vals1 
	20 21 shared 2value vals2
	
T{ vals1 }T 10 11 ==
T{ vals2 }T 20 21 ==

	256 buffer: buf1
	10 buf1 !
	256 shared buffer: buf1
	256 shared buffer: buf2
	20 buf2 !

T{ buf1 @ }T 10 ==
T{ buf2 @ }T 20 ==

\ Exercise the remaining private entries without exposing them as definers.
	shared 2variable pair1
	10 11 pair1 2!
	shared 2variable pair1
T{ pair1 2@ }T 10 11 ==

	10 11 shared 2constant paircon1
	20 21 shared 2constant paircon1
T{ paircon1 }T 10 11 ==

	s" original" shared $value text1
	s" replacement" shared $value text1
T{ text1 s" original" compare }T 0 ==

\ Skipping each definition preserves unrelated items beneath its initializer.
T{ 123 shared variable var1 }T 123 ==
T{ 123 shared 2variable pair1 }T 123 ==
T{ 123 20 shared constant con1 }T 123 ==
T{ 123 20 shared value val1 }T 123 ==
T{ 123 256 shared buffer: buf1 }T 123 ==
T{ 123 20 21 shared 2constant paircon1 }T 123 ==
T{ 123 20 21 shared 2value vals1 }T 123 ==
T{ 123 s" replacement" shared $value text1 }T 123 ==

\ An unsupported repeated definer reports and releases its saved input state.
create shared.existing
T{ 123 shared create shared.existing }T 123 ==

Tend
CR