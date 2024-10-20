\ test for ForthBase.f

include "%idir%\ForthBase.f"
include "%idir%\..\simple-tester\simple-tester.f"

CR

Tstart

CR
." formatting and output" CR

T{ 0 (.OnOff) hashS }T s" OFF" hashS ==
T{ 1 (.OnOff) hashS }T s" ON" hashS ==
T{ -1 (.OnOff) hashS }T s" ON" hashS ==

hex
T{ f 0 (ud.) hashS }T s" 000000000000000F" hashS ==
T{ 76543210 fedcba98 (ud.) hashS }T s" FEDCBA9876543210" hashS ==
decimal

CR
." data structures and memory" CR

BEGIN-ENUM
	+ENUM Red
	+ENUM Green
	+ENUM Blue
END-ENUM

T{ Red	}T 0 ==
T{ Green }T 1 ==
T{ Blue	}T 2 ==

BEGIN-ENUMS primary-colour
 +" The colour red"	
 +" The colour green"
 +" The colour blue"
END-ENUMS

T{ RED primary-colour hashS }T s" The colour red" hashS ==
T{ GREEN primary-colour hashS }T s" The colour green" hashS ==
T{ BLUE primary-colour hashS }T s" The colour blue" hashS ==

10 s" const1" ($constant)

T{ const1 }T 10 ==

256 BUFFER: buf1
10 buf1 !

T{ buf1 @ }T 10 ==

buf1 DEBUFFER

CR ." strings" CR

s" Hadrian" $value emperor

T{ emperor hashS }T s" Hadrian" hashS ==

s" Julius Caesar" $-> emperor

T{ emperor hashS }T s" Julius Caesar" hashS ==

CR ." secret stack" CR

2 >s 1 >s 
T{ s@ }T 1 ==
T{ s> }T 1 ==
T{ s> }T 2 ==
3 4 2>s 5 6 2>s
T{ 2s> }T 3 4 ==
T{ 2s> }T 5 6 ==
Tend
CR