\ Forth utility words from the windows system
\ requires FiniteFractions.f

LIBRARY: ForthBase.dll

Extern: int "c" version( );
Extern: void "c" makeUUID( int * caddr);
Extern: void "c" now_local( int * yyyymmdd, int * hhmmss);
Extern: void "c" now_UTC( int * yyyymmdd, int * hhmmss);

