// Must set properties / Precompiled Headers / Precompiled Header / Not using...
// Forth utility functions from the windows system

#include "ForthBase.h"

// Return a version number
int version()
{
    int main_version = 0;
    int minor_version = 1;
    int release = 1;
    int version_number = minor_version + 60 * (main_version + 60 * release);

    return version_number;

}

// The local time and date
FORTHBASE_API void now_local(int* yyyymmdd, int* hhmmss)
{
}

// The UTC time and date
FORTHBASE_API void now_UTC(int* yyyymmdd, int* hhmmss)
{
}

// A UUID
FORTHBASE_API void makeUUID(int* caddr)
{
}
