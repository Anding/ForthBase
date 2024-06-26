include "%idir%\..\..\forth-map\map.fs"
include "%idir%\..\..\forth-map\map-tools.fs"
include "%idir%\shared.f"
include "%idir%\..\..\simple-tester\simple-tester.f"

CR
Tstart

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

Tend
CR