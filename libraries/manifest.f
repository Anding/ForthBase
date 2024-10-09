\ check the string stored in libname against the available library names and include the relevant files if matched

libname count s" ForthBase" icompare 0= [IF]
	create ForthBase
	\ once libname is created as a word, NEED will have a flag know not to include it again
	\  an alternative would be to create the word in the library source file but some libraries may be externally authored
	include "%libdir%\ForthBase\ForthBase.f"
[THEN]

libname count s" Buffers" icompare 0= [IF]
	create Buffers
	include "%libdir%\ForthBase\buffers\buffers.f"
[THEN]

libname count s" FiniteFractions" icompare 0= [IF]
	create FiniteFractions
	include "%libdir%\ForthBase\FiniteFractions\FiniteFractions.f"
[THEN]

libname count s" Serial" icompare 0= [IF]
	create Serial
	include "%libdir%\ForthBase\serial\VFX32serial.f"
[THEN]

libname count s" Shared" icompare 0= [IF]
	create Shared
	include "%libdir%\ForthBase\shared\shared.f"	
[THEN]

libname count s" Windows" icompare 0= [IF]
	create Windows
	include "%libdir%\ForthBase\windows\windows.f"	
[THEN]

libname count s" Forth-map" icompare 0= [IF]
	create forth-map
	include "%libdir%\forth-map\map.fs"
	include "%libdir%\forth-map\map-tools.fs"
[THEN]

libname count s" ForthASI" icompare 0= [IF]
	create ForthASI
	include "%libdir%\ForthASI\ForthASI\ASI_SDK.f"
	include "%libdir%\ForthASI\ForthASI\ASI_SDK_extend.f"
	include "%libdir%\ForthASI\ForthASI\ForthAstroCamera.f"
	include "%libdir%\ForthASI\ForthASI\ForthAstroCameraMaps.f"
[THEN]

libname count s" ForthAstroCalc" icompare 0= [IF]
	create ForthAstroCalc
	include "%libdir%\AstroCalc\ForthAstroCalc\ForthAstroCalc.f"
[THEN]

libname count s" ForthEAF" icompare 0= [IF]
	create ForthEAF
	include "%libdir%\ForthEAF\EAF_SDK.f"
	include "%libdir%\ForthEAF\EAF_SDK_extend.f"
	include "%libdir%\ForthEAF\ForthFocuser.f"
	include "%libdir%\ForthEAF\ForthFocuserMaps.f"
[THEN]

libname count s" ForthEFW" icompare 0= [IF]
	create ForthEAF
	include "%libdir%\ForthEFW\EFW_SDK.f"
	include "%libdir%\ForthEFW\EFW_SDK_extend.f"
	include "%libdir%\ForthEFW\ForthFilterWheel.f"
	include "%libdir%\ForthEFW\ForthFilterWheelMaps.f"
[THEN]

libname count s" ForthKMTronic" icompare 0= [IF]
	create ForthKMTronic
	include "%libdir%\KMTronic.f"
	include "%libdir%\KMTronic_Bidmead.f"
[THEN]

libname count s" ForthXISF" icompare 0= [IF]
	create ForthXISF
	include "%libdir%\ForthXISF\XISF.f"
	include "%libdir%\ForthXISF\XISF_filename.f"
	include "%libdir%\ForthXISF\XISF_maps.f"
	include "%libdir%\ForthXISF\properties_obs.f"
	include "%libdir%\ForthXISF\properties_rig.f"
[THEN]

libname count s" ForthXML" icompare 0= [IF]
	create ForthXML
	include "%libdir%\ForthXML\xml.f"
	include "%libdir%\ForthXML\xml_maptools.f"
[THEN]

libname count s" simple-tester" icompare 0= [IF]
	create simple-tester
	include "%libdir%\simple-tester\simple-tester.f"
[THEN]

\ as presently coded there is no error message or warning if a requested library cannot be found



