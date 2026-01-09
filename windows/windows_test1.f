\ test for windows.f

include "%idir%\windows.f"

 CR 
 create uuid_string 64 allot
 
: uuid-test ( n --)
	0 do
		uuid_string make-UUID CR type
		uuid_string zcount CR type
		uuid_string UUIDlength CR type
	loop CR
;

 10 uuid-test

