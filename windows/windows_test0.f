\ test for windows.f
include "%idir%\..\libraries\libraries.f"
include "%idir%\windows.f"
NEED finitefractions

\ check DLL and extern status
CR
." ForthBase.dll load address " ForthBase.dll u. CR
.BadExterns CR
." ForthBaseVersion " ForthBaseVersion ~. CR