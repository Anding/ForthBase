# ForthBase library loading

`NEED` loads a named library once, including its declared dependencies. The
public form is:

```forth
NEED ForthAstroFormats
NEED ordered-maps
```

Names are resolved in the private `library-registry` wordlist. Each registry
entry stores a load action and a loaded flag, so lookup requires one dictionary
search rather than scanning the complete manifest.

## Behaviour

For `NEED Name`:

1. If `Name` is already visible in the current Forth search context, loading is
   skipped for compatibility with externally loaded libraries.
2. Otherwise, `Name` is looked up in `library-registry`.
3. Its loader is executed only on the first request in the session.
4. An unregistered name reports `Unknown library` and returns.

Dependencies are ordinary loader calls and therefore receive the same
one-time behaviour. A loader is marked before its action executes, preventing
recursive dependency cycles. Sources are controlled installation files; there
is no preflight layer, exception interception or automatic retry. Native
include/compiler errors remain interpreter errors; use a fresh session after
correcting an incomplete source load.

`NEED` parses the next source word and is intended for source loading. Code
which already has a library name as a string may use:

```forth
s" ForthAstroFormats" need-library
```

## Library root

Manifest paths begin with `%libdir%`. The installation-specific value comes
from:

```text
ForthBase\libraries\local.f
```

Libraries may reside in separate repositories beneath that root; they do not
need a uniform internal directory structure.

## Registering a library

Add one loader action and one registry entry to `manifest.f`:

```forth
: load.MyLibrary ( -- )
    s" %libdir%\MyLibrary\MyLibrary.f" included
;
' load.MyLibrary library-loader MyLibrary
```

The public name is the word after `library-loader`. The private action uses the
same name with a `load.` prefix by convention.

### Declaring dependencies

Declare dependencies with `NEED` in the repository's entry file, before its
internal includes. The manifest only selects that entry:

```forth
: load.MyImageTools ( -- )
    s" %libdir%\MyImageTools\Library.f" included
;
' load.MyImageTools library-loader MyImageTools
```

In `MyImageTools\Library.f`:

```forth
NEED ForthAstroFormats
include "%idir%\ImageTools.f"
```

Registration order does not need to follow dependency order. The entire
manifest is compiled before any application library is requested.

### Multiple source files

Keep internal include order explicit in the repository's entry file:

```forth
\ MyDevice\Library.f
include "%idir%\sdk.f"
include "%idir%\device.f"
include "%idir%\metadata.f"
```

The manifest does not list those internal files. Existing single-file packages
can use their source directly as the entry; no wrapper is needed.

Astronomy repositories each have one public `NEED`: `ForthAstroFormats`,
`ForthAstroCalc`, `ImageAnalysis`, `ForthASTAP`, `ForthSeiza` and
`AstroImagingInForth`. Each composes its own sources in dependency order;
internal modules and former aliases have no separate registry entries.
ForthBase is the exception and retains its smaller utility loaders.
ImageAnalysis loads statistics, display, stars and focus-curve bindings together.
AstroImagingInForth includes its own image paths and mount alignment, and loads
Seiza directly without ASTAP support or conditional solver selection.

## Diagnostics

Check whether a public name is registered:

```forth
s" ForthAstroFormats" library-registry search-wordlist
```

The result follows `search-wordlist` conventions: an execution token and flag
for a match, or zero for a miss.

The focused regression is:

```text
ForthBase\libraries\libraries_test1.f
```

It covers registry lookup, recursive dependency loading, one-time execution,
and reporting and normal return for an unknown name.
