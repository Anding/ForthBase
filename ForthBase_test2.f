\ test for ForthBase.f

need simple-tester

include "%idir%\ForthBase.f"

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

Tend