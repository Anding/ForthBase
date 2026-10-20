# ForthBase

Reusable Forth language definitions and the library loader used by the related
Forth repositories.

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
