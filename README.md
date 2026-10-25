# ForthBase

Reusable Forth language definitions and the library loader used by the related
Forth repositories.

Ordinary failures report and return without unwinding the caller. Only heap
allocation failure uses `ABORT"`. Free failures report and return; callers must
not reuse freed storage. A full map rejects a new key without changing the map.

`file-to-buffer ( fileid -- buf|0 )` returns zero on a sizing, positioning,
read, or short-read failure and frees any incomplete buffer. The caller still
owns the file handle and must check for zero before using the result.
`buffer-read-file` does not advance the buffer pointer on a failed read.
`new-node`, `new-next-node`, and `new-down-node` return zero when a tree is full;
failed links leave existing nodes unchanged.

For coordinates that must not be accepted after malformed input, use:

```forth
>number~~~? ( caddr u -- x y z valid? )
>number3~?  ( caddr u separator -- n valid? )
```

These bounded parsers return zero components and false on failure; the caller
reports its operation context and skips the failed step. The older numeric-only
forms report malformed input and return zero(s), preserving their stack effects.

`NEED ordered-maps` supplies heap-backed, insertion-ordered string maps.
See [`ordered-maps/ordered-maps.f`](ordered-maps/ordered-maps.f) for usage,
the wordset, and storage invariants. `erase-map` removes keys; `reset-map`
retains keys and order while emptying values. The legacy map library is no
longer registered by the loader.

See [`libraries/README.md`](libraries/README.md) for the `NEED` user guide,
including registration and dependency instructions.

`NEED structured-lists` supplies generic operations on zero-terminated lists
of record references. Records and lists are declared directly with `CREATE`
and `,`; no astronomy libraries are required. See
[`structured-lists/structured-lists.f`](structured-lists/structured-lists.f)
for the callback contracts and `structured-lists_test1.f` and
`structured-lists_test2.f` in that directory for executable examples.
`structured-lists_test.f` is the exploratory astronomy-inspired design tutorial,
not a regression test.
