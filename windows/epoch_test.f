\ Offline check of the operating-system clock; no hardware or astronomy dependency.
include "%idir%\..\libraries\libraries.f"
NEED windows
NEED simple-tester

Tstart
T{ utc-epoch-seconds 1767225600 >= }T -1 ==
T{ utc-epoch-seconds utc-epoch-seconds swap - 0 2 within }T -1 ==
Tend
