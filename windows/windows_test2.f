\ test for windows.f

include "%idir%\..\FiniteFractions\FiniteFractions.f"
include "%idir%\windows.f"

 CR
 CR 
 create timestamp_string 256 allot
 
." UTC " timestamp_string 0 timestamp type CR
." LOC " timestamp_string 1 timestamp type CR

 CR
." fl=0  "  0 now ~. SPACE ~. CR
." fl=1  "  1 now ~. SPACE ~. CR
." fl=2  "  2 now ~. SPACE ~. CR
  
 CR
." DST, bias  " timezone . .
 CR
