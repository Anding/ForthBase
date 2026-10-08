# ForthBase library loading

`NEED` loads a named library once, including its declared dependencies. The
public form is:

```forth
NEED ForthAstroFormats
NEED forth-map
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
4. An unregistered name aborts with `Unknown library`.

Dependencies are ordinary loader calls and therefore receive the same
one-time behaviour. A loader is marked before its action executes, preventing
recursive dependency cycles. If an include throws, restart VFX after fixing
the cause because that entry remains marked for the current session.

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

Call `need-library` before including files that require the dependency:

```forth
: load.MyImageTools ( -- )
    s" ForthAstroFormats" need-library
    s" ForthRasterIO" need-library
    s" %libdir%\MyImageTools\MyImageTools.f" included
;
' load.MyImageTools library-loader MyImageTools
```

Use `s" Dependency" need-library` inside loader definitions, not parsed
`NEED Dependency`. Loader actions execute later, whereas the manifest is being
compiled when their definitions are read.

Registration order does not need to follow dependency order. The entire
manifest is compiled before any application library is requested.

### Multiple source files

Keep nonuniform include order explicit:

```forth
: load.MyDevice ( -- )
    s" %libdir%\MyDevice\sdk.f" included
    s" %libdir%\MyDevice\device.f" included
    s" %libdir%\MyDevice\metadata.f" included
;
' load.MyDevice library-loader MyDevice
```

This makes initialization order inspectable and avoids hiding repository
structure behind another abstraction.

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
and explicit failure for an unknown name.
