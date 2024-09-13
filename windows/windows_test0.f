\ test for windows.f

include "%idir%\..\FiniteFractions\FiniteFractions.f"
include "%idir%\windows.f"
	
\ check DLL and extern status
CR
." ForthBase.dll load address " ForthBase.dll u. CR
.BadExterns CR
." ForthBase\windows version " version ~. CR