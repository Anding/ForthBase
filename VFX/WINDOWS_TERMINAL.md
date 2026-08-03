# VFX Forth for Windows Terminal

`Bin\VFXterm.exe` is a dedicated VFX Forth console for Windows Terminal. It
keeps the normal interactive REPL while adding VT-based line editing and
in-process command history.

## Features

- Left, Right, Home, End, Backspace, and Delete editing
- Up and Down command-history navigation
- Editing and re-execution of recalled commands
- 256 command lines of nonpersistent history
- Automatic inclusion of `startup.f`
- Optional inclusion of one source file from the command line
- Recoverable include errors
- Redirected standard input and output

This is a dedicated turnkey executable. It does not alter `Bin\VFXcon.exe`,
the GUI executables, or other applications built with `SaveConsole`.

## Requirements

- Windows
- Windows Terminal or another terminal with compatible ANSI/VT input and
  output support
- The repository's existing `Bin\VFXcon.exe` to rebuild the turnkey

The checked-in source targets the repository's 32-bit Windows VFX Forth
environment.

## Build

From the repository root, start the existing console:

```powershell
.\Bin\VFXcon.exe
```

At its Forth prompt, run:

```forth
include WindowsTerminal.fth
bye
```

The build creates:

```text
Bin\VFXterm.exe
```

`WindowsTerminal.fth` is both the application source and builder. Its final
`SaveConsole` writes the executable; no historical stage-1/stage-2 rebuild is
required.

For a noninteractive PowerShell build:

```powershell
@('include WindowsTerminal.fth', 'bye') | .\Bin\VFXcon.exe
```

## Start the REPL

Run from the directory that should supply `startup.f` and relative include
paths:

```powershell
.\Bin\VFXterm.exe
```

On every launch, VFXterm performs these steps:

1. Initializes standard handles and the GENIO terminal device.
2. Enables VT input and output when attached to a console.
3. Includes `startup.f` from the process working directory.
4. Includes the first command-line argument, if supplied.
5. Enters the normal interactive Forth prompt.

If `startup.f` does not exist, VFXterm prints the include error and still
enters the prompt. An empty file is sufficient when no startup definitions
are needed:

```powershell
New-Item startup.f -ItemType File
```

## Use a startup file

Place reusable definitions in `startup.f` in the launch directory:

```forth
decimal
: squared  dup * ;
." Local startup loaded" cr
```

Then launch VFXterm from that directory:

```powershell
& 'E:\coding\VFXForth\Bin\VFXterm.exe'
```

`startup.f` is read on every launch. It is not embedded into the executable.
This permits each working directory to define its own environment.

## Include a file at launch

Pass one source filename as the first positional argument:

```powershell
.\Bin\VFXterm.exe .\Examples\my-session.fth
```

Quote paths containing spaces:

```powershell
.\Bin\VFXterm.exe '.\Observing Plans\m42.fth'
```

The order is always:

1. `startup.f`
2. the first positional file
3. the interactive prompt

Only the first positional argument is used. Later arguments are ignored.
The argument is always treated as a filename; it is never evaluated as Forth
text. Relative paths resolve from the process working directory.

If either file is missing or throws while loading, VFXterm reports the error,
cleans up the interpreter state, continues with the remaining startup step,
and enters the prompt.

## Edit commands

| Key | Action |
| --- | --- |
| Left | Move one character left |
| Right | Move one character right |
| Home | Move to the start of the line |
| End | Move to the end of the line |
| Backspace | Delete the character before the cursor |
| Delete | Delete the character under the cursor |
| Up | Recall an older command |
| Down | Recall a newer command |
| Enter | Execute the current line |

Windows Terminal sends Backspace as the VT `DEL` byte (`0x7F`). VFXterm
treats both `0x08` and `0x7F` as Backspace. The physical Delete key remains
distinct and arrives as the VT sequence `ESC [ 3 ~`.

Recalled commands can be edited before pressing Enter. Blank lines are not
stored in history. History exists only in the current process and is lost
when VFXterm exits.

The editor also retains the original control-key alternatives:

| Key | Action |
| --- | --- |
| Ctrl+W | Move left |
| Ctrl+R | Move right |
| Ctrl+E | Recall an older command |
| Ctrl+D | Recall a newer command |

Windows Terminal handles selection, copy, and paste according to its own key
bindings. Pasted text is delivered to the same line editor.

## Redirect input and output

VFXterm detects whether each standard handle is a console, file, or pipe.
VT console modes are changed only for actual console handles, so ordinary
PowerShell redirection remains available.

Run commands from a file:

```powershell
Get-Content .\commands.fth | .\Bin\VFXterm.exe
```

Capture output:

```powershell
Get-Content .\commands.fth |
    .\Bin\VFXterm.exe |
    Set-Content .\session.log
```

The input must eventually execute `bye` if the process should terminate
instead of waiting at the REPL:

```forth
1 2 + . cr
bye
```

Cursor-editing escape sequences are intended for interactive terminals, not
ordinary redirected command files.

## Exit and console restoration

Use:

```forth
bye
```

At shutdown, VFXterm releases its in-process history and restores the input
and output console modes captured at startup. The invoking PowerShell or
Windows Terminal tab therefore retains its original mode configuration.

## Troubleshooting

### `Failed to open requested file` for `startup.f`

VFXterm always attempts to include `startup.f`. Create it in the current
working directory, change to the intended directory before launch, or accept
the visible error and continue at the prompt.

Check the launch directory with:

```powershell
Get-Location
```

### A command-line file is not found

Relative arguments are resolved from the working directory, not from the
directory containing `VFXterm.exe`. Use a correct relative path or an
absolute path.

### Arrow keys print visible characters

Run VFXterm in Windows Terminal or another VT-compatible console. The editor
expects Windows virtual-terminal input sequences such as `ESC [ A`.

### Home, End, or history appears to pause

These operations use ANSI cursor-position reporting. A compatible terminal
must answer the cursor-position query. Plain files and simplistic terminal
emulators do not provide that interactive response.

### Include errors appear but the prompt remains available

This is intentional. Startup errors are visible but recoverable so a broken
local configuration cannot prevent access to the REPL.

### Ctrl+C behavior

VFXterm preserves Windows processed-input mode while disabling Windows line
and echo processing. This leaves console interrupt handling available to the
VFX runtime. Exact Ctrl+C behavior during a particular long-running Forth
word depends on that word and the runtime's existing keyboard-abort handling.

## Implementation overview

`WindowsTerminal.fth`:

- includes `Lib\Win32\Genio\ConsoleTerm.fth`;
- installs the process's real Win32 standard handles into `xconsole`;
- captures, enables, and later restores console VT modes;
- registers terminal startup and shutdown hooks;
- implements recoverable source inclusion;
- installs the dedicated turnkey entry point; and
- saves `Bin\VFXterm.exe`.

`Lib\Win32\Genio\ConsoleTerm.fth` supplies the GENIO vectors, ANSI cursor
operations, line editor, and 256-entry history. Its Windows path supports
console, file, and pipe handles.

The design rationale and original acceptance plan are retained in
[`WINDOWS_TERMINAL_WORKSTREAM.md`](WINDOWS_TERMINAL_WORKSTREAM.md).

## Current verification status

Automated tests have exercised:

- startup and optional-file ordering;
- quoted file paths and ignored later arguments;
- missing and throwing include files;
- command-line text being treated only as a filename;
- redirected input and output;
- Left, Right, Home, End, `0x08`/`0x7F` Backspace, and `ESC [ 3 ~` Delete
  behavior;
- Up and Down history traversal;
- editing and executing recalled lines; and
- input near the accepted-line size limit.

Manual checks in a real Windows Terminal tab remain appropriate for terminal
key bindings, copy and paste, and Ctrl+C during application-specific
long-running words.
