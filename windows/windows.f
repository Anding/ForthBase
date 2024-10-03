\ Forth utility words from the windows system
\ requires FiniteFractions.f

LIBRARY: ForthBase.dll

Extern: int "c" ForthBaseVersion( );
Extern: int "c" ForthbaseUUID( char * caddr);
Extern: int "c" ForthBaseTimestamp( char * caddr, int flgs);
Extern: void "c" ForthBaseNow( int * yyyymmdd, int * hhmmss, int flags);
Extern: void "c" ForthBaseTimezone( int * bias, int * DST);

37 CONSTANT UUIDlength \ includes zero terminator
64 CONSTANT TSlength

: make-UUID ( caddr -- caddr u)
\ prepare a UUID in string format 1aa02f27-cfd3-4b13-9903-d9b524214bd8
\ cddr must have 37 bytes allocated
	ForthbaseUUID zcount
;

: timestamp ( caddr flags -- caddr u)
\ prepare a timestamp of system time
\ cddr expects 256 bytes allocated
\ flags: 1 - local time (else UT)
	ForthBaseTimestamp zcount
;

: now ( flags -- yymmdd hhmmss) { flags | yymmdd hhmmss }	\ VFX locals
\ return the current date and time in finite fraction format
\ flags: 1 - local time (else UT)
\ flags: 2 - subtract 12 hours and return the date and midnight (else actual)
	addr yymmdd addr hhmmss flags ForthBaseNow
	yymmdd hhmmss
;

: timezone ( -- bias DST) { | bias DST }
\ return the bias in minutes  
\ UT = LOCALTIME + bias ; bias includes DST if in operation
\ return a flag to indicate if DST is operation
	addr bias addr DST ForthBaseTimezone
	bias DST
;
