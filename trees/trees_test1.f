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
T{ 1 nod1 node! }T ==
T{ nod1 node@ }T 1 ==

T{ nod1 tre1 new-next-node constant nod2 }T ==
\ nod1
\  |
\ nod2

T{ nod1 go-next }T nod2 GO_NEXT TRUE ==
T{ nod2 go-back }T nod1 GO_BACK TRUE ==
T{ nod1 go-back }T nod1 GO_BACK FALSE ==
T{ nod2 go-next }T nod2 GO_NEXT FALSE ==

T{ nod2 tre1 new-down-node constant nod3 }T ==
\ nod1
\  |
\ nod2 -- nod3

T{ nod2 go-down }T nod3 GO_DOWN TRUE ==
T{ nod3 go-up   }T nod2 GO_UP TRUE ==

T{ nod3 tre1 new-next-node constant nod4 }T ==
\ nod1
\  |
\ nod2 -- nod3T
\          |
\         nod4

T{ nod4 tre1 new-next-node constant nod5 }T ==
\ nod1
\  |
\ nod2 -- nod3
\          |
\         nod4
\          |
\         nod5

T{ nod1 tre1 new-down-node constant nod6 }T ==
\ nod1 -- nod6
\  |
\ nod2 -- nod3
\          |
\         nod4
\          |
\         nod5

T{ 2 nod2 node! }T ==
T{ 3 nod3 node! }T ==
T{ 4 nod4 node! }T ==
T{ 5 nod5 node! }T ==
T{ 6 nod6 node! }T ==
Tend

ASSIGN explain-move TO-DO do-after-move

CR

tre1 traverse

CR