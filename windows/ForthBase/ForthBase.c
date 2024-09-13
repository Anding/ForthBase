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
FORTHBASE_API char* makeUUID(char* caddr)
{
    UUID uuid;
    RPC_CSTR uuidStr;

    // Generate a UUID
    (void) UuidCreate(&uuid); 

    // Convert the UUID to a string
    (void) UuidToStringA(&uuid, &uuidStr);
    strcpy_s(caddr, UUID_length, uuidStr);

    // Free the memory allocated for the UUID string
    RpcStringFreeA(&uuidStr);

    return(caddr);

}
