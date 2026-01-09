\ test for windows.f

include "%idir%\..\libraries\libraries.f"
include "%idir%\windows.f"
NEED finitefractions

 CR
 CR 
 create timestamp_string 256 allot
 
." UTC " timestamp_string 0 make-timestamp type CR
." LOC " timestamp_string 1 make-timestamp type CR

 CR
." fl=0  "  0 now ~. SPACE ~. CR
." fl=1  "  1 now ~. SPACE ~. CR
." fl=2  "  2 now ~. SPACE ~. CR
  
 CR
." DST, bias  " timezone . .
 CR
