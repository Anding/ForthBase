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


\ convenience functions standard usage

: ~FITS$ ( x-y-z -- caddr u)
\ obtain an  string in the format XX YY ZZ from single integer finite fraction format, suitable for the FITS file header
   BL BL 0 ~custom$
 ;

: <.Dec> ( DEGMMSS -- caddr u)
\ format a declination value
    ':' ':' -1 ~custom$ 
;

: .Dec ( DEGMMSS --)
\ print a declination value to the console
    <.Dec> type
;

: <.RA> ( HHMMSS -- caddr u)
    ':' ':' 0 ~custom$ 
;

: .RA ( HHMMSS --)
\ print a time value (often RA) to the console
    <.RA> type
 ;
 
 synonym .ALT .RA
 synonym .AZ .RA
