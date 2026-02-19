\ test for ForthBase.f

need forthBase
need simple-tester

Tstart

s" First" $value my$value
T{ my$value hashS }T s" First" hashS ==
T{ s" Second" $-> my$value my$value hashS }T s" Second" hashS ==

: inside s" Third" $-> my$value ;
T{ inside my$value hashS }T s" Third" hashS ==

s" First" $value my$value01
T{ my$value01 hashS }T s" First" hashS ==
T{ s" Second" $+> my$value01 my$value01 hashS }T s" FirstSecond" hashS ==  
  
: inside01 s" Third" $+> my$value01 ;
T{ inside01 my$value01 hashS }T s" FirstSecondThird" hashS ==  

T{ <$ s" This is" $ BL _ s" a string" $ '!' _ $> hashS }T s" This is a string!" hashS ==

: inside02 <$ s" This is" $ BL _ s" a string" $ '!' _ $> ;
T{ inside02 hashS }T s" This is a string!" hashS ==

Tend 
