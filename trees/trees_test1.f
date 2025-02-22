\ test for trees.f

include "%idir%\..\libraries\libraries.f"
include "%idir%\trees.f"
NEED simple-tester

4096 allocate-tree 
constant tre1

CR
Tstart

T{ tre1 tree_used }T 0 ==
T{ tre1 tree_space }T 4096 ==

T{ tre1 new-node dup constant nod1 }T tre1 TREE_ADDR ==
\ nod1

T{ nod1 tre1 new-next-node constant nod2 }T ==
\ nod1 -- nod2

T{ nod1 go-next }T -1 nod2 ==
T{ nod2 go-back }T -1 nod1 ==
T{ nod1 go-back }T  0 nod1 ==
T{ nod2 go-next }T  0 nod2 ==

T{ nod2 tre1 new-down-node constant nod3 }T ==
\ nod1 -- nod2
\           |
\         nod3

T{ nod2 go-down }T -1 nod3 ==
T{ nod3 go-up   }T -1 nod2 ==
T{ nod3 go-back-up }T -1 nod2 ==
T{ nod1 go-back-up }T 0 nod1 ==

T{ nod3 tre1 new-next-node constant nod4 }T ==
\ nod1 -- nod2
\           |
\         nod3 -- nod4

T{ nod4 tre1 new-next-node constant nod5 }T ==
\ nod1 -- nod2
\           |
\         nod3 -- nod4 -- nod5

T{ nod5 go-back-up }T -1 nod2 ==

Tend
CR