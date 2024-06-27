\ test for ForthBase.f

include "%idir%\ForthBase.f"
include "%idir%\..\simple-tester\simple-tester.f"

CR
Tstart

BEGIN-ENUM
	+ENUM Red
	+ENUM Green
	+ENUM Blue
END-ENUM

T{ Red	}T 0 ==
T{ Green }T 1 ==
T{ Blue	}T 2 ==

10 s" const1" ($constant)

T{ const1 }T 10 ==

256 BUFFER buf1
10 buf1 !

T{ buf1 @ }T 10 ==

buf1 DEBUFFER

s" Julius Caesar" STRING emperor

T{ emperor hashS }T s" Julius Caesar" hashS ==

Tend
CR