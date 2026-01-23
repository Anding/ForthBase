\ check the string stored in libname against the available library names and include the relevant files if matched

2dup s" TestWord1" icompare 0= [IF]
	create TestWord1
	include "%libdir%\ForthBase\libraries\Test1.f"
[THEN]

2dup s" TestWord2" icompare 0= [IF]
	create TestWord2
	include "%libdir%\ForthBase\libraries\Test2.f"
[THEN]

2dup s" ForthBase" icompare 0= [IF]
	create ForthBase
	\ once libname is created as a word, NEED will have a flag know not to include it again
	\  an alternative would be to create the word in the library source file but some libraries may be externally authored
	include "%libdir%\ForthBase\ForthBase.f"
[THEN]

2dup s" AstroCalc" icompare 0= [IF]
	create AstroCalc
	include "%libdir%\AstroCalc\ForthAstroCalc\ForthAstroCalc.f
[THEN]

2dup s" Buffers" icompare 0= [IF]
	create Buffers
	include "%libdir%\ForthBase\buffers\buffers.f"
	include "%libdir%\ForthBase\buffers\bufferTools.f"	
[THEN]

2dup s" CommandStrings" icompare 0= [IF]
	create CommandStrings
	include "%libdir%\ForthBase\CommandStrings\CommandStrings.f"
[THEN]

2dup s" FiniteFractions" icompare 0= [IF]
	create FiniteFractions
	include "%libdir%\ForthBase\FiniteFractions\FiniteFractions.f"
	include "%libdir%\ForthBase\FiniteFractions\FiniteFractionsTypes.f"	
	include "%libdir%\ForthBase\FiniteFractions\FiniteFractionsFloatingPoint.f"	
[THEN]

2dup s" network" icompare 0= [IF]
	create network
	include "%libdir%\ForthBase\network\VFX32network.f"
[THEN]

2dup s" Serial" icompare 0= [IF]
	create Serial
	include "%libdir%\ForthBase\serial\VFX32serial.f"
[THEN]

2dup s" Shared" icompare 0= [IF]
	create Shared
	include "%libdir%\ForthBase\shared\shared.f"	
[THEN]

2dup s" Windows" icompare 0= [IF]
	create Windows
	include "%libdir%\ForthBase\windows\windows.f"	
[THEN]

2dup s" Forth-map" icompare 0= [IF]
	create forth-map
	include "%libdir%\forth-map\map.fs"
	include "%libdir%\forth-map\map-tools.fs"
[THEN]

2dup s" ForthASI" icompare 0= [IF]
	create ForthASI
	include "%libdir%\ForthASI\ForthASI\ASI_SDK.f"
	include "%libdir%\ForthASI\ForthASI\ASI_SDK_extend.f"
	include "%libdir%\ForthASI\ForthASI\ForthAstroCamera.f"
	include "%libdir%\ForthASI\ForthASI\ForthAstroCameraMaps.f"
[THEN]

2dup s" ForthAstroCalc" icompare 0= [IF]
	create ForthAstroCalc
	include "%libdir%\AstroCalc\ForthAstroCalc\ForthAstroCalc.f"
[THEN]

2dup s" ForthEAF" icompare 0= [IF]
	create ForthEAF
	include "%libdir%\ForthEAF\EAF_SDK.f"
	include "%libdir%\ForthEAF\EAF_SDK_extend.f"
	include "%libdir%\ForthEAF\ForthFocuser.f"
	include "%libdir%\ForthEAF\ForthFocuserMaps.f"
[THEN]

2dup s" ForthEFW" icompare 0= [IF]
	create ForthEFW
	include "%libdir%\ForthEFW\EFW_SDK.f"
	include "%libdir%\ForthEFW\EFW_SDK_extend.f"
	include "%libdir%\ForthEFW\ForthFilterWheel.f"
	include "%libdir%\ForthEFW\ForthFilterWheelMaps.f"
[THEN]

2dup s" ForthKMTronic" icompare 0= [IF]
	create ForthKMTronic
	include "%libdir%\ForthKMTronic\KMTronic.f"
[THEN]

2dup s" ForthXISF" icompare 0= [IF]
	create ForthXISF
	include "%libdir%\ForthXISF\XISF.f"
	include "%libdir%\ForthXISF\XISF_filename.f"
	include "%libdir%\ForthXISF\properties_obs.f"
	include "%libdir%\ForthXISF\properties_rig.f"		
	include "%libdir%\ForthXISF\XISF_maps.f"
[THEN]

2dup s" ForthXML" icompare 0= [IF]
	create ForthXML
	include "%libdir%\ForthXML\xml.f"
	include "%libdir%\ForthXML\xml_maptools.f"
[THEN]

2dup s" ForthPegasusAstro" icompare 0= [IF]
	create ForthPegasusAstro
	include "%libdir%\ForthPegasusAstro\PegasusAstro.f"
[THEN]

2dup s" ImageAnalysis" icompare 0= [IF]
	create ImageAnalysis
	include "%libdir%\ImageAnalysis\ImageAnalysis.f"
[THEN]

2dup s" simple-tester" icompare 0= [IF]
	create simple-tester
	include "%libdir%\simple-tester\simple-tester.f"
[THEN]

2dup s" Forth10Micron" icompare 0= [IF]
	create Forth10Micron
	include "%libdir%\Forth10Micron\10Micron_SDK.f"
	include "%libdir%\Forth10Micron\10Micron_SDK_extend.f"
	include "%libdir%\Forth10Micron\10Micron_SDK_commands.f"
	include "%libdir%\Forth10Micron\ForthTelescopeMount.f"
	include "%libdir%\Forth10Micron\ForthTelescopeMountMaps.f"
[THEN]

2dup s" ForthVT100" icompare 0= [IF]
	create ForthVT100
	include "%libdir%\ForthVT100\ForthVT100.f"
	include "%libdir%\ForthVT100\ForthVT100_tables.f"
	include "%libdir%\ForthVT100\ForthVT100_UI.f"
[THEN]

2dup s" ForthASTAP" icompare 0= [IF]
	create ForthASTAP
	include "%libdir%\ForthASTAP\ForthASTAP.f"
[THEN]

2dup s" regex" icompare 0= [IF]
    create regex
    include "%libdir%\ForthBase\regex\regex.f"
[THEN]

2drop
		
\ as presently coded there is no error message or warning if a requested library cannot be found




