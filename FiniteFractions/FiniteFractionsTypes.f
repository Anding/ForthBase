\ finite fraction data types that also serve for labeling in code and scripts

( hh mm ss - t) \ minutes and seconds of time
: HHMMSS ~ ;
: RA ~ ;	

( deg mm ss - t) \ minutes and seconds of arc  
: DEGMMSS ~ ;
: DEC  ~ ; 
: ALT  ~ ; 
: AZ	 ~ ; 
: LAT  ~ ;
: LONG ~ ;


\ convenience functions for users

: .Dec ( DEGMMSS --)
    ':' ':' -1 ~custom$ type
 ;

: .RA ( HHMMSS --)
 \ format for the :newalpt command
    ':' ':' 0 ~custom$ type
 ;
 
 synonym .ALT .RA
 synonym .AZ .RA
