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

: load.TestWord1 ( -- )
    s" %libdir%\ForthBase\libraries\Test1.f" included
;
' load.TestWord1 library-loader TestWord1

: load.TestWord2 ( -- )
    s" %libdir%\ForthBase\libraries\Test2.f" included
;
' load.TestWord2 library-loader TestWord2

: load.ForthBase ( -- )
    s" %libdir%\ForthBase\ForthBase.f" included
;
' load.ForthBase library-loader ForthBase

: load.AstroCalc ( -- )
    s" %libdir%\AstroCalc\ForthAstroCalc\ForthAstroCalc.f" included
;
' load.AstroCalc library-loader AstroCalc

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

: load.Forth-map ( -- )
    s" %libdir%\forth-map\map.fs" included
    s" %libdir%\forth-map\map-tools.fs" included
;
' load.Forth-map library-loader Forth-map

: load.ForthASI ( -- )
    s" %libdir%\ForthASI\ForthASI\ASI_SDK.f" included
    s" %libdir%\ForthASI\ForthASI\ASI_SDK_extend.f" included
    s" %libdir%\ForthASI\ForthASI\ForthAstroCamera.f" included
    s" %libdir%\ForthASI\ForthASI\ForthAstroCameraMaps.f" included
;
' load.ForthASI library-loader ForthASI

: load.ForthAstroCalc ( -- )
    s" %libdir%\AstroCalc\ForthAstroCalc\ForthAstroCalc.f" included
;
' load.ForthAstroCalc library-loader ForthAstroCalc

: load.SkyRegions ( -- )
    s" AstroCalc" need-library
    s" %libdir%\AstroCalc\ForthAstroCalc\SkyRegions.f" included
;
' load.SkyRegions library-loader SkyRegions

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
;
' load.ForthAstroFormats library-loader ForthAstroFormats

: load.ForthAstroPaths ( -- )
    s" ForthAstroFormats" need-library
;
' load.ForthAstroPaths library-loader ForthAstroPaths

: load.ForthRasterIO ( -- )
    s" %libdir%\ForthAstroFormats\RasterIO.f" included
;
' load.ForthRasterIO library-loader ForthRasterIO

: load.ForthAtomicFile ( -- )
    s" %libdir%\ForthAstroFormats\AtomicFile.f" included
;
' load.ForthAtomicFile library-loader ForthAtomicFile

: load.ForthPublication ( -- )
    s" ForthAstroFormats" need-library
    s" ForthAtomicFile" need-library
    s" %libdir%\ForthAstroFormats\Publication.f" included
;
' load.ForthPublication library-loader ForthPublication

: load.ForthXISFCodec ( -- )
    s" ForthAstroFormats" need-library
    s" %libdir%\ForthAstroFormats\XISF.f" included
;
' load.ForthXISFCodec library-loader ForthXISFCodec

: load.ForthImageLoaders ( -- )
    s" ForthXISFCodec" need-library
    s" %libdir%\ForthAstroFormats\XISF_load.f" included
    s" %libdir%\ForthAstroFormats\FITS_load.f" included
;
' load.ForthImageLoaders library-loader ForthImageLoaders

: load.ForthImageExport ( -- )
    s" ForthAstroFormats" need-library
    s" ForthRasterIO" need-library
    s" %libdir%\ForthAstroFormats\PNG.f" included
    s" %libdir%\ForthAstroFormats\RAW.f" included
;
' load.ForthImageExport library-loader ForthImageExport

: load.ForthAstroMetadata ( -- )
    s" ForthAstroFormats" need-library
    s" %libdir%\ForthAstroFormats\properties_obs.f" included
    s" %libdir%\ForthAstroFormats\properties_rig.f" included
    s" %libdir%\ForthAstroFormats\XISF_maps.f" included
;
' load.ForthAstroMetadata library-loader ForthAstroMetadata

: load.ForthFrameTools ( -- )
    s" ForthAstroFormats" need-library
    s" %libdir%\ForthAstroFormats\XISF_spawn.f" included
;
' load.ForthFrameTools library-loader ForthFrameTools

: load.ForthXISF ( -- )
    s" ForthImageLoaders" need-library
    s" ForthImageExport" need-library
    s" ForthAstroMetadata" need-library
    s" ForthFrameTools" need-library
;
' load.ForthXISF library-loader ForthXISF

: load.BMP ( -- )
    s" ForthAstroFormats" need-library
    s" ForthRasterIO" need-library
    s" %libdir%\ForthAstroFormats\BMP.f" included
;
' load.BMP library-loader BMP

: load.FITS_projection ( -- )
    s" ForthAstroFormats" need-library
    s" ForthPublication" need-library
    s" %libdir%\ForthAstroFormats\FITS_projection.f" included
;
' load.FITS_projection library-loader FITS_projection

: load.ForthPreview ( -- )
    s" ImageAnalysis" need-library
    s" BMP" need-library
    s" ForthPublication" need-library
    s" %libdir%\ForthAstroFormats\Preview.f" included
;
' load.ForthPreview library-loader ForthPreview

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
;
' load.ImageAnalysis library-loader ImageAnalysis

: load.simple-tester ( -- )
    s" %libdir%\simple-tester\simple-tester.f" included
;
' load.simple-tester library-loader simple-tester

: load.Forth10Micron ( -- )
    s" %libdir%\Forth10Micron\10Micron_SDK.f" included
    s" %libdir%\Forth10Micron\10Micron_SDK_extend.f" included
    s" %libdir%\Forth10Micron\10Micron_SDK_commands.f" included
    s" %libdir%\Forth10Micron\ForthTelescopeMount.f" included
    s" %libdir%\Forth10Micron\ForthTelescopeMountMaps.f" included
;
' load.Forth10Micron library-loader Forth10Micron

: load.ForthVT100 ( -- )
    s" %libdir%\ForthVT100\ForthVT100.f" included
    s" %libdir%\ForthVT100\ForthVT100_tables.f" included
    s" %libdir%\ForthVT100\ForthVT100_UI.f" included
;
' load.ForthVT100 library-loader ForthVT100

: load.ForthASTAPFocus ( -- )
    s" %libdir%\ForthASTAP\ForthASTAPFocus.f" included
;
' load.ForthASTAPFocus library-loader ForthASTAPFocus

: load.ForthASTAP ( -- )
    s" ForthASTAPFocus" need-library
    s" %libdir%\ForthASTAP\ForthASTAP.f" included
;
' load.ForthASTAP library-loader ForthASTAP

: load.ForthSeiza ( -- )
    s" %libdir%\ForthSeiza\ForthSeiza.f" included
;
' load.ForthSeiza library-loader ForthSeiza

: load.ForthAstroSolver ( -- )
    s" %libdir%\ForthAstroFormats\Solver.f" included
;
' load.ForthAstroSolver library-loader ForthAstroSolver

: load.AstroImagingInForth ( -- )
    s" %libdir%\AstroImagingInForth\capabilities\AstroImagingInForth.f" included
;
' load.AstroImagingInForth library-loader AstroImagingInForth

: load.AstroImagingTargets ( -- )
    s" SkyRegions" need-library
    s" %libdir%\AstroImagingInForth\capabilities\AstroImagingTargets.f" included
;
' load.AstroImagingTargets library-loader AstroImagingTargets

: load.ImagingPipeline ( -- )
    s" %libdir%\AstroImagingInForth\capabilities\ImagingPipeline.f" included
;
' load.ImagingPipeline library-loader ImagingPipeline

: load.AstroImagingFocus ( -- )
    s" %libdir%\AstroImagingInForth\capabilities\AstroImagingFocus.f" included
;
' load.AstroImagingFocus library-loader AstroImagingFocus

: load.AstroImagingModel ( -- )
    s" %libdir%\AstroImagingInForth\capabilities\AstroImagingModel.f" included
;
' load.AstroImagingModel library-loader AstroImagingModel

: load.LightboxFlats ( -- )
    s" %libdir%\AstroImagingInForth\capabilities\LightboxFlats.f" included
;
' load.LightboxFlats library-loader LightboxFlats

: load.FocuserMetrology ( -- )
    s" %libdir%\AstroImagingInForth\capabilities\FocuserMetrology.f" included
;
' load.FocuserMetrology library-loader FocuserMetrology

: load.regex ( -- )
    s" %libdir%\ForthBase\regex\regex.f" included
;
' load.regex library-loader regex
