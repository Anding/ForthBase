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
    time_t t;
    struct tm* tm_info;

    // Get the current time
    time(&t);
    tm_info = localtime_s(&t);  // https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/localtime-s-localtime32-s-localtime64-s?view=msvc-170

    // Extract year, month, day, hour, minute, second, and nanoseconds
    int year = tm_info->tm_year + 1900;
    int month = tm_info->tm_mon + 1;
    int day = tm_info->tm_mday;
    int hour = tm_info->tm_hour;
    int minute = tm_info->tm_min;
    int second = tm_info->tm_sec;
    
    *yyyymmdd = day + 60 * ( month + 60 * year);
    *hhmmss = second + 60 * ( minute + 60 * hour);
    
}

// The UTC time and date
FORTHBASE_API void now_UTC(int* yyyymmdd, int* hhmmss)
{
    time_t t;
    struct tm* tm_info;

    // Get the current time
    time(&t);
    tm_info = gmtime(&t);

    // Extract year, month, day, hour, minute, second, and nanoseconds
    int year = tm_info->tm_year + 1900;
    int month = tm_info->tm_mon + 1;
    int day = tm_info->tm_mday;
    int hour = tm_info->tm_hour;
    int minute = tm_info->tm_min;
    int second = tm_info->tm_sec;
    
    *yyyymmdd = day + 60 * ( month + 60 * year);
    *hhmmss = second + 60 * ( minute + 60 * hour);
  
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
