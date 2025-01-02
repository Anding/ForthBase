\ Make a console version of VFX Forth
\ include E:\coding\ForthBase\VFX\console-app.f

: start \ hmodule 0 commandline show-- res
	." VFX Forth custom startup" cr
	key drop
	s" e:\coding\ForthBase\libraries\libraries.f" included
	key drop
 [ action-of EntryPoint ] literal execute
 
 ;
 
 ' start is EntryPoint
 
 SaveConsole VFXcon
 
 
 : start \ hmodule 0 commandline show-- res
 	4drop
	WalkColdChain
 0
 ;
 
 ' start is EntryPoint
 SaveConsole hello
 
  : start \ hmodule 0 commandline show-- res
 [ action-of EntryPoint ] literal execute
 0
 ;
 
 ' start is EntryPoint
 
 SaveConsole hello
 