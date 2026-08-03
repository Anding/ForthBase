\ WindowsTerminal.fth - build the Windows Terminal console executable.
\
\ Load this file in Bin\VFXcon.exe. It installs a dedicated xterm-style
\ GENIO device and saves Bin\VFXterm.exe; it does not change VFXcon.exe.
\ The saved executable expects a terminal that supports VT input and output,
\ such as Windows Terminal. See WINDOWS_TERMINAL.md for build and usage.

only forth definitions
decimal

\ Reuse the existing ANSI line editor and its 256-entry in-process history.
include Lib\Win32\Genio\ConsoleTerm.fth

Extern: BOOL PASCAL GetConsoleMode( HANDLE hCons, DWORD * mode );
Extern: BOOL PASCAL SetConsoleMode( HANDLE hCons, DWORD mode );

also system definitions

$0001 constant ENABLE_PROCESSED_INPUT_WT	\ preserve Ctrl+C processing
$0002 constant ENABLE_LINE_INPUT_WT		\ disable Windows line editing
$0004 constant ENABLE_ECHO_INPUT_WT		\ disable Windows input echo
$0004 constant ENABLE_VIRTUAL_TERMINAL_PROCESSING_WT
$0200 constant ENABLE_VIRTUAL_TERMINAL_INPUT_WT

variable wt-input-mode		\ console mode captured before modification
variable wt-output-mode
variable wt-input-mode?		\ true only when SetConsoleMode succeeded
variable wt-output-mode?

: wt-enable-input-vt	\ --
\ Put an interactive console in raw VT input mode for ConsoleTerm's byte
\ decoder. GetConsoleMode fails for redirected handles, leaving pipes and
\ files untouched.
  { | mode[ cell ] -- }
  stdin @ mode[ GetConsoleMode if
    mode[ @ wt-input-mode !
    mode[ @
      ENABLE_LINE_INPUT_WT ENABLE_ECHO_INPUT_WT or invert and
      ENABLE_PROCESSED_INPUT_WT ENABLE_VIRTUAL_TERMINAL_INPUT_WT or or
    stdin @ swap SetConsoleMode wt-input-mode? !
  endif
;

: wt-enable-output-vt	\ --
\ Add ANSI/VT output processing without removing the console's existing
\ processed-output or wrapping flags. Redirected output is left unchanged.
  { | mode[ cell ] -- }
  stdout @ mode[ GetConsoleMode if
    mode[ @ wt-output-mode !
    stdout @ mode[ @ ENABLE_VIRTUAL_TERMINAL_PROCESSING_WT or
    SetConsoleMode wt-output-mode? !
  endif
;

: wt-init-terminal	\ --
\ This late cold-start hook runs after syspatch has obtained the process's
\ real Win32 standard handles. ConsoleTerm's static 0/1/2 defaults are C
\ descriptors and cannot be passed to Win32 console and file APIs.
  wt-input-mode? off
  wt-output-mode? off
  stdin @ xconsole xs.hIn !
  stdout @ xconsole xs.hOut !
  stderr @ xconsole xs.hErr !
  wt-enable-input-vt
  wt-enable-output-vt
  init-xcon
;

: wt-term-terminal	\ --
\ Release the history buffer and restore exactly the console modes inherited
\ at launch. A mode is restored only if this process changed it successfully.
  xconsole close-gio drop
  wt-output-mode? @ if
    stdout @ wt-output-mode @ SetConsoleMode drop
  endif
  wt-input-mode? @ if
    stdin @ wt-input-mode @ SetConsoleMode drop
  endif
;

' wt-init-terminal AtCold
' wt-term-terminal AtExit

previous definitions

: wt-included	\ c-addr u --
\ Include one source file without preventing entry to the REPL on failure.
\ INCLUDED consumes one copy of the filename. CATCH preserves the other copy
\ so it can be discarded on either path. The recovery sequence mirrors the
\ normal QUIT cleanup needed after a failed include.
  2dup ['] included catch ?dup if
    .throw
    2drop
    clean-opt cleanup-locals
    OperatorType off
    QuitHook
    init-quit
  endif
  2drop
;

: wt-entry	\ hinst hpinst lpstrcmd nshow -- flag
\ Turnkey entry point. The cold chain has already initialized Win32 and
\ xconsole. STARTUP.F is always attempted relative to the process working
\ directory, followed by argv[1] when present. Later arguments are ignored;
\ command-line text is never evaluated as Forth.
  4drop
  .cold
  s" startup.f" wt-included
  CommandLine 2drop
  argc 1 > if
    1 argv[ zcount wt-included
  endif
  quit
  0
;

assign wt-entry to-do EntryPoint

\ Save a console-subsystem image; the .exe suffix is added by SaveConsole.
SaveConsole Bin\VFXcon
