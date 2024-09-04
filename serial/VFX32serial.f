\ VFX serial device usage

 include C:\MPE\VfxForth\lib\Win32\Genio\serialbuff.fth
\ this does not include properly in Win64

: connection_string ( com_port baud -- c-addr u)
\ create a VFX COM port connection string
\ the string is stored in the PAD and will be overwritten when the PAD is used again
	<#  
	s"  parity=N data=8 stop=1" HOLDS
	( baud) 0 #s 2drop
	s"  baud=" HOLDS
	dup 10 < if
		':' HOLD	
		( com_port) 0 # 
		s" COM" HOLDS
	else
		( com_port) 0 # #
		s" \\.\COM" HOLDS
	then	
	#>
;

\  SERDEV: my_SID
\ 	prepare an instance of a VFX Forth generic I/O driver (sid) for a serial device

: open-serial ( com_port baud my_sid --)
\ my_sid is a VFX generic I/O structure, use the word SERDEV:
	>R connection_string ( sid addr ) 7 ( VFX settings) R> ( c-addr u attribs sid) open-gio ( sid ior) 
	ABORT" Failed to open COM port" drop
;

: close-serial ( my_sid)
	close-gio ABORT" Failed to close COM port"
;

\ usesful Windows command line tools 
\ 	mode
\ 	chgport
