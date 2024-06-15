\ test for buffers.f

include "%idir%\buffers.f"
include "%idir%\..\simple-tester\simple-tester.f"

1024 allocate-buffer 
constant buf1

CR
Tstart

T{ buf1 buffer_used }T 0 ==
T{ buf1 buffer_space }T 1024 ==
\ lower bounds check enforced?
T{ buf1 backspace-buffer }T -1 ==

T{ s" 01234567" buf1 write-buffer }T 0 ==
T{ buf1 buffer_used }T 8 ==
T{ buf1 buffer_space }T 1016 ==

T{ s" ABCD01234567EFGH" buf1 write-buffer }T 0 ==
T{ buf1 buffer_used }T 24 ==
T{ buf1 buffer_space }T 1000 ==

T{ 'X' buf1 echo-buffer }T 0 == 
T{ buf1 buffer_used }T 25 ==
T{ buf1 buffer_space }T 999 ==

T{ 'Z' buf1 echo-buffer }T 0 ==
T{ buf1 backspace-buffer }T 0 ==
T{ buf1 buffer_used }T 25 ==
T{ buf1 buffer_space }T 999 ==

\ upper bounds check enforced?
T{ s" ABC" drop 1000 buf1 write-buffer }T -1 ==
T{ buf1 buffer_used }T 25 ==
T{ buf1 buffer_space }T 999 ==

T{ buf1 buffer-to-string nip }T 25 ==

\ serialize buf1 to a file
	s" %idir%\buffers_test1.txt" r/w create-file drop
	constant test_fileid
	buf1 test_fileid buffer-to-file 

\ map the file to buf2
	test_fileid file-to-buffer
	constant buf2

T{ buf1 buffer-to-string hashS }T buf2 buffer-to-string hashS ==

Tend

\ review buffers
	buf1 buffer-to-string dump
	buf2 buffer-to-string dump                  

\ release resources
	buf1 free-buffer
	buf2 free-buffer
	test_fileid close-file drop

