\ test for windows.f

include "%idir%\..\FiniteFractions\FiniteFractions.f"
include "%idir%\windows.f"

 CR 
 create timestamp_string 256 allot
 
." UTC " timestamp_string 0 timestamp type CR
." LOC " timestamp_string 1 timestamp type CR
