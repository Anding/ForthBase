NEED structured-lists
NEED FiniteFractions
NEED simple-tester

\ TARGETS

: TARGET: ( RA Dec <name> --)
\ define a celestial target from sky coordinates
\ <name> returns a reference to the target
    create swap , , 
;

: target-name ( ref -- caddr u)
\ return the name of the word that defined the target
;

: target-coordinates ( ref -- RA Dec)
\ return the RA and DEC in finite fraction single cell format
;

\ define some example winter sky targets
05 34 32 RA +22  00  52 Dec TARGET: M1
05 35 16 RA -05 -23 -23 Dec TARGET: M42
05 35 31 RA -05 -16 -03 Dec TARGET: M43
03 47 29 RA +24  06  19 Dec TARGET: M45

\ usage example in simple-tester format
T{ M42 target-coordinates }T 05 35 16 RA -05 -23 -23 Dec ==
T{ M42 target-name hashS }T s" M42" hashS ==
    
create winter-targets
    M1 , M42 , M43 , M45 , 0 ,

\ FOCUS STARS

: FOCUS-STAR: ( RA Dec Mag <name> --)
\ define a focus star from sky coordinates and magnitude
\ <name> returns a reference to the target
\ uses the ITEM data-structure and store RA , Dec , Mag ,
;

\ define some GAIA focus stars
00 46 33 RA  +15  28  31 Dec  4199 FOCUS-STAR: G2781184739422799232
00 49 56 RA  -57 -23 -10 Dec  6005 FOCUS-STAR: G4907609544296090496
01 02 50 RA  +62  36  33 Dec  7000 FOCUS-STAR: G522919728657214976
01 03 37 RA  +58  54  33 Dec  6009 FOCUS-STAR: G425813507390508160
01 11 40 RA  +30  05  22 Dec  4198 FOCUS-STAR: G309966797615673856
    
LIST: focus-stars
G2781184739422799232 , G4907609544296090496 , G522919728657214976 , 
G425813507390508160 , G309966797615673856 ,
0 ,

: angular-distance-compare ( RA Dec target1 target2 -- RA Dec TRUE | RA Dec FALSE)
\ TRUE if the angular distance from (RA, Dec) to target1 is smaller or the same as
\ the angular distance from (RA, Dec) to target2, FALSE otherwise
\ so the smallest angular separation is 'top', and the largest 'bottom'
;

\ usage example in simple-tester format
T{ G2781184739422799232 target-corodinates }T 00 46 33 RA  +15 28 31 Dec ==

\ sort the list of focus stars by angular distance from M42
M42 target-coordinates ' angular-distance-compare focus-stars SORT-LIST 2drop

: check-observability ( target -- flag)
\ for a given sky-frame, compute whether the target has
\ alt >= 45
\ 90 <= az <= 300
;

\ identify the first observable focus star (in order of angular separation frpm M42)
' check-observability focus-stars QUERY-LIST
drop

\ SKY REGIONS
\ POLYGON-REGION construction requires must be atomic (nothing interleaved on the heap) 

: POLYGON-REGION: ( <name> -- )
\ begin the definition of a named sky region
\ format in memory -n RA1 Dec1 RA2 Dec_n ... RAx Dec_n 
    create
    here 0 , here !
    DOES> ( region-ref)
;

: ADD-REGION-POINT ( RA DEC  --)
\ compile a coordinate to the current sky region
    here @ >R
    swap , ,
    R@ @ 1- R@ !
    R> here !
;

: CIRCLE-REGION: ( RA DEC DEGMMSS <name> --)
\ shorthand notation for creating a cicle region
\ format in memory DEGMMSS RA DEC
    create
    , swap , , 
;

\ application notes
\ a region list is just a list of regions
\ a region list can be sorted by area, by smallest to largest
\ a region list can be queried to find the first region in the list where a given point (RA Dec) is located

\ a list of region lists can be created as a new list
