\ test for ForthBase.f

need simple-tester

include "%idir%\ForthBase.f"


s" First" $value my$value

Tstart

T{ my$value hashS }T s" First" hashS ==
T{ s" Second" $-> my$value my$value hashS }T s" Second" hashS ==

: inside s" Third" $-> my$value ;

T{ inside my$value hashS }T s" Third" hashS ==

Tend
