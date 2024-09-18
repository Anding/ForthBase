\ Forth utility words from the windows system
\ requires FiniteFractions.f

LIBRARY: ForthBase.dll

Extern: int "c" version( );
Extern: int "c" makeUUID( char * caddr);
Extern: int "c" timestamp ( char * caddr, int flgs);
Extern: void "c" now( int * yyyymmdd, int * hhmmss, int flags);
Extern: void "c" timezone( int * bias, int * DST);


: make-UUID ( caddr -- caddr u)
\ prepare a UUID in string format 1aa02f27-cfd3-4b13-9903-d9b524214bd8
\ cddr must have 37 bytes allocated
	makeUUID zcount
;


