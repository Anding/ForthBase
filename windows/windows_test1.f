\ test for windows.f

include "%idir%\..\FiniteFractions\FiniteFractions.f"
include "%idir%\windows.f"

 CR 
 create uuid_string 64 allot
 
: uuid-test ( n --)
	0 do
		uuid_string make-UUID CR type 
	loop CR
;

 10 uuid-test

