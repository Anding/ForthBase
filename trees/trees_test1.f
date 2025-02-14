\ test for trees.f

include "%idir%\..\libraries\libraries.f"
include "%idir%\trees.f"
NEED simple-tester

1024 allocate-tree 
constant tre1

CR
Tstart

T{ tre1 tree_used }T 0 ==
T{ tre1 tree_space }T 1024 ==

T{ tre1 new-node dup constant nod1 }T tre1 TREE_ADDR ==
T{ nod1 tre1 new-next-node constant nod2 }T ==
T{ nod1 go-next }T nod2 ==
T{ nod2 go-back }T nod1 ==

Tend
CR