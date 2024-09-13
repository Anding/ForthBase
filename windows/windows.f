\ Forth utility words from the windows system
\ requires FiniteFractions.f

LIBRARY: ForthBase.dll

Extern: int "c" version( );
Extern: int "c" makeUUID( char * caddr);
Extern: void "c" now_local( int * yyyymmdd, int * hhmmss);
Extern: void "c" now_UTC( int * yyyymmdd, int * hhmmss);


: make-UUID ( caddr -- caddr u)
\ prepare a UUID in string format 1aa02f27-cfd3-4b13-9903-d9b524214bd8
\ cddr must have 37 bytes allocated
	makeUUID zcount
;

