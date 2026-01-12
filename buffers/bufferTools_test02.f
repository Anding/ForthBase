\ test for buffersTool.f

include "%idir%\buffers.f"
include "%idir%\bufferTools.f"

NEED simple-tester

1024 allocate-buffer 
constant buf1

CR

s" ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" buf1 write-buffer drop
buf1 buffer-reset-search

Tstart
T{ s" ABC" buf1 buffer-match drop hashS }T s" ABC" hashS ==
T{ s" ABC" buf1 buffer-match }T 0 ==
T{ s" 789" buf1 buffer-match drop hashS }T s" 789" hashS ==
T{ s" XYZ" buf1 buffer-match }T 0 ==
buf1 buffer-reset-search
T{ s" XYZ" buf1 buffer-match drop hashS }T s" XYZ" hashS ==

cr
Tend