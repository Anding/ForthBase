\ ( caddr n) 
\ check the string against the available library names and include if matched

libname count s" ForthBase" icompare 0= [IF]
	include "%libdir%\ForthBase\ForthBase.f"
[THEN]

libname count s" FiniteFractions" icompare 0= [IF]
	include "%libdir%\ForthBase\FiniteFractions\FiniteFractions.f"
[THEN]

libname count s" ForthASI" icompare 0= [IF]
	include "%libdir%\ForthASI\ForthASI\ASI_SDK.f"
	include "%libdir%\ForthASI\ForthASI\ASI_SDK_extend.f"
	include "%libdir%\ForthASI\ForthASI\ForthAstroCamera.f"
	include "%libdir%\ForthASI\ForthASI\ForthAstroCameraMaps.f"
[THEN]
