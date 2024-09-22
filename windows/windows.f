\ Forth utility words from the windows system
\ requires FiniteFractions.f

LIBRARY: ForthBase.dll

Extern: int "c" ForthBaseVersion( );
Extern: int "c" ForthbaseUUID( char * caddr);
Extern: int "c" ForthBaseTimestamp( char * caddr, int flgs);
Extern: void "c" ForthBaseNow( int * yyyymmdd, int * hhmmss, int flags);
Extern: void "c" ForthBaseTimezone( int * bias, int * DST);


: make-UUID ( caddr -- caddr u)
\ prepare a UUID in string format 1aa02f27-cfd3-4b13-9903-d9b524214bd8
\ cddr must have 37 bytes allocated
	ForthbaseUUID zcount
;

: timestamp ( caddr flags -- caddr u)
\ prepare a timestamp of system time
\ cddr expects 256 bytes allocated
	ForthBaseTimestamp zcount
;


