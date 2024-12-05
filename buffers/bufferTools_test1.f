\ test for buffersTool.f

include "%idir%\..\libraries\libraries.f"
include "%idir%\buffers.f"
include "%idir%\bufferTools.f"

NEED simple-tester

1024 allocate-buffer 
constant buf1

CR
Tstart

T{ buf1 buffer_used }T 0 ==
T{ buf1 buffer_space }T 1024 ==

T{ s" E:\images\2024-12-04\" buf1 write-buffer }T 0 ==
T{ buf1 buffer_used }T 21 ==
T{ buf1 buffer_space }T 1003 ==

buf1 buffer-punctuate-filepath

T{ s" 19-49-00-RED-0123456789abcdef" buf1 write-buffer }T 0 ==
T{ buf1 buffer_used }T 50 ==

T{ buf1 buffer-filepath-to-string hashS }T s" E:\images\2024-12-04\19-49-00-RED-0123456789abcdef" HashS ==
T{ buf1 buffer-drive-to-string hashS }T s" E:\" HashS ==
T{ buf1 buffer-dir-to-string hashS }T s" images\2024-12-04\" HashS ==
T{ buf1 buffer-filename-to-string hashS }T s" 19-49-00-RED-0123456789abcdef" HashS ==

Tend