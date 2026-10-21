\ Private loader dictionary used by NEED. Each action keeps nonuniform paths
\ and dependencies explicit; library-loader supplies one-time execution.
\
\ Maintenance pattern for every public library name:
\   : load.Name ( -- )
\       s" Dependency" need-library
\       s" %libdir%\repository\source.f" included
\   ;
\   ' load.Name library-loader Name
\
\ Dependencies use need-library rather than parsed NEED because these actions
\ execute later, after the manifest has compiled. Registration order is not
\ dependency order: the complete registry exists before any loader is called.

: load.simple-tester ( -- )
    s" %libdir%\simple-tester\simple-tester.f" included
;
' load.simple-tester library-loader simple-tester

: load.ForthBase ( -- )
    s" %libdir%\ForthBase\ForthBase.f" included
    s" %libdir%\ForthBase\Input.f" included
;
' load.ForthBase library-loader ForthBase

: load.structured-lists ( -- )
    s" %libdir%\ForthBase\structured-lists\structured-lists.f" included
;
' load.structured-lists library-loader structured-lists

: load.ordered-maps ( -- )
    s" %libdir%\ForthBase\ordered-maps\ordered-maps.f" included
;
' load.ordered-maps library-loader ordered-maps

: load.Buffers ( -- )
    s" %libdir%\ForthBase\buffers\buffers.f" included
    s" %libdir%\ForthBase\buffers\bufferTools.f" included
;
' load.Buffers library-loader Buffers

: load.CommandStrings ( -- )
    s" %libdir%\ForthBase\CommandStrings\CommandStrings.f" included
;
' load.CommandStrings library-loader CommandStrings

: load.FiniteFractions ( -- )
    s" %libdir%\ForthBase\FiniteFractions\FiniteFractions.f" included
    s" %libdir%\ForthBase\FiniteFractions\FiniteFractionsTypes.f" included
    s" %libdir%\ForthBase\FiniteFractions\FiniteFractionsFloatingPoint.f" included
;
' load.FiniteFractions library-loader FiniteFractions

: load.network ( -- )
    s" %libdir%\ForthBase\network\VFX32network.f" included
;
' load.network library-loader network

: load.Serial ( -- )
    s" %libdir%\ForthBase\serial\VFX32serial.f" included
;
' load.Serial library-loader Serial

: load.Shared ( -- )
    s" %libdir%\ForthBase\shared\shared.f" included
;
' load.Shared library-loader Shared

: load.Windows ( -- )
    s" %libdir%\ForthBase\windows\windows.f" included
;
' load.Windows library-loader Windows

: load.ForthVT100 ( -- )
    s" %libdir%\ForthVT100\ForthVT100.f" included
    s" %libdir%\ForthVT100\ForthVT100_tables.f" included
    s" %libdir%\ForthVT100\ForthVT100_UI.f" included
    s" %libdir%\ForthVT100\ForthLog.f" included
;
' load.ForthVT100 library-loader ForthVT100

: load.regex ( -- )
    s" %libdir%\ForthBase\regex\regex.f" included
;
' load.regex library-loader regex

: load.ForthASI ( -- )
    s" %libdir%\ForthASI\ForthASI\ASI_SDK.f" included
    s" %libdir%\ForthASI\ForthASI\ASI_SDK_extend.f" included
    s" %libdir%\ForthASI\ForthASI\ForthAstroCamera.f" included
    s" %libdir%\ForthASI\ForthASI\ForthAstroCameraMaps.f" included
;
' load.ForthASI library-loader ForthASI

: load.ForthAstroCalc ( -- )
    s" %libdir%\AstroCalc\ForthAstroCalc\ForthAstroCalc.f" included
    s" %libdir%\AstroCalc\ForthAstroCalc\SkyRegions.f" included
    s" %libdir%\AstroCalc\ForthAstroCalc\TargetLists.f" included
;
' load.ForthAstroCalc library-loader ForthAstroCalc

: load.ForthEAF ( -- )
    s" %libdir%\ForthEAF\EAF_SDK.f" included
    s" %libdir%\ForthEAF\EAF_SDK_extend.f" included
    s" %libdir%\ForthEAF\ForthFocuser.f" included
    s" %libdir%\ForthEAF\ForthFocuserMaps.f" included
;
' load.ForthEAF library-loader ForthEAF

: load.ForthEFW ( -- )
    s" %libdir%\ForthEFW\EFW_SDK.f" included
    s" %libdir%\ForthEFW\EFW_SDK_extend.f" included
    s" %libdir%\ForthEFW\ForthFilterWheel.f" included
    s" %libdir%\ForthEFW\ForthFilterWheelMaps.f" included
;
' load.ForthEFW library-loader ForthEFW

: load.ForthKMTronic ( -- )
    s" %libdir%\ForthKMTronic\KMTronic.f" included
;
' load.ForthKMTronic library-loader ForthKMTronic

: load.ForthAstroFormats ( -- )
    s" %libdir%\ForthAstroFormats\Frame.f" included
    s" %libdir%\ForthAstroFormats\Paths.f" included
    s" %libdir%\ForthAstroFormats\FITS.f" included
    s" %libdir%\ForthAstroFormats\FITS_cards.f" included
    s" %libdir%\ForthAstroFormats\XISF.f" included
    s" %libdir%\ForthAstroFormats\XISF_load.f" included
    s" %libdir%\ForthAstroFormats\FITS_load.f" included
    s" %libdir%\ForthAstroFormats\RasterIO.f" included
    s" %libdir%\ForthAstroFormats\AtomicFile.f" included
    s" %libdir%\ForthAstroFormats\Publication.f" included
    s" %libdir%\ForthAstroFormats\FITS_projection.f" included
    s" %libdir%\ForthAstroFormats\PNG.f" included
    s" %libdir%\ForthAstroFormats\RAW.f" included
    s" %libdir%\ForthAstroFormats\BMP.f" included
    s" %libdir%\ForthAstroFormats\properties_obs.f" included
    s" %libdir%\ForthAstroFormats\properties_rig.f" included
    s" %libdir%\ForthAstroFormats\XISF_maps.f" included
    s" %libdir%\ForthAstroFormats\XISF_spawn.f" included
    s" %libdir%\ForthAstroFormats\Solver.f" included
    s" ImageAnalysis" need-library
;
' load.ForthAstroFormats library-loader ForthAstroFormats

: load.ForthXISF ( -- )
    s" ForthAstroFormats" need-library
;
' load.ForthXISF library-loader ForthXISF

\ Existing callers share the consolidated loader, not a second set of includes.
' load.ForthXISF library-loader ForthAstroPaths
' load.ForthXISF library-loader ForthRasterIO
' load.ForthXISF library-loader ForthAtomicFile
' load.ForthXISF library-loader ForthPublication
' load.ForthXISF library-loader ForthXISFCodec
' load.ForthXISF library-loader ForthImageLoaders
' load.ForthXISF library-loader ForthImageExport
' load.ForthXISF library-loader ForthAstroMetadata
' load.ForthXISF library-loader ForthFrameTools
' load.ForthXISF library-loader BMP
' load.ForthXISF library-loader FITS_projection
' load.ForthXISF library-loader ForthPreview
' load.ForthXISF library-loader ForthAstroSolver

: load.AstroCalc ( -- )
    s" ForthAstroCalc" need-library
;
' load.AstroCalc library-loader AstroCalc
' load.AstroCalc library-loader SkyRegions
' load.AstroCalc library-loader TargetLists

: load.ForthXML ( -- )
    s" %libdir%\ForthXML\xml.f" included
    s" %libdir%\ForthXML\xml_maptools.f" included
;
' load.ForthXML library-loader ForthXML

: load.ForthPegasusAstro ( -- )
    s" %libdir%\ForthPegasusAstro\PegasusAstro.f" included
;
' load.ForthPegasusAstro library-loader ForthPegasusAstro

: load.ImageAnalysis ( -- )
    s" %libdir%\ImageAnalysis\ImageAnalysis.f" included
    s" %libdir%\ImageAnalysis\DisplayFunction.f" included
    s" %libdir%\ForthAstroFormats\Preview.f" included
;
' load.ImageAnalysis library-loader ImageAnalysis

: load.Forth10Micron ( -- )
    s" %libdir%\Forth10Micron\10Micron_SDK.f" included
    s" %libdir%\Forth10Micron\10Micron_SDK_extend.f" included
    s" %libdir%\Forth10Micron\10Micron_SDK_commands.f" included
    s" %libdir%\Forth10Micron\ForthTelescopeMount.f" included
    s" %libdir%\Forth10Micron\ForthTelescopeMountMaps.f" included
;
' load.Forth10Micron library-loader Forth10Micron

: load.ForthASTAPFocus ( -- )
    s" %libdir%\ForthASTAP\ForthASTAPFocus.f" included
;
' load.ForthASTAPFocus library-loader ForthASTAPFocus

: load.ForthASTAP ( -- )
    s" %libdir%\ForthASTAP\ForthASTAP.f" included
;
' load.ForthASTAP library-loader ForthASTAP

: load.ForthSeiza ( -- )
    s" %libdir%\ForthSeiza\ForthSeiza.f" included
;
' load.ForthSeiza library-loader ForthSeiza

: load.AstroImagingInForth ( -- )
    s" %libdir%\AstroImagingInForth\capabilities\AstroImagingInForth.f" included
    s" %libdir%\AstroImagingInForth\capabilities\ImagingLog.f" included
    s" %libdir%\AstroImagingInForth\capabilities\Hardware.f" included
    s" %libdir%\AstroImagingInForth\capabilities\Targets&Regions.f" included
    s" %libdir%\AstroImagingInForth\capabilities\ImagingPipeline.f" included
    s" %libdir%\AstroImagingInForth\capabilities\Autofocus.f" included
    s" %libdir%\AstroImagingInForth\capabilities\MountModel.f" included
    s" %libdir%\AstroImagingInForth\capabilities\FocuserModel.f" included
    s" %libdir%\AstroImagingInForth\capabilities\LightboxFlats.f" included
;
' load.AstroImagingInForth library-loader AstroImagingInForth
