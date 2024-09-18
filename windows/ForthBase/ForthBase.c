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

void _now(struct tm tm_info, int flags)
{
    time_t t;

    // Get the current time
    time(&t);

    // offset from "today" to "today's night" if requested
    if ((flags & 2) == 2) {
        t -= (time_t)60 * 60 * 12;
    }

    // format the current time in UT or local format in a tm_info structure
    // https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/localtime-s-localtime32-s-localtime64-s?view=msvc-170
    if ((flags & 1) == 0) {
        (void)gmtime_s(&tm_info, &t);
    }
    else {
        (void)localtime_s(&tm_info, &t);
    }
}

// The time and date
FORTHBASE_API void now(int* yyyymmdd, int* hhmmss, int flags)
{
    struct tm tm_info = { 0 };
    _now(tm_info, flags);

    // Extract year, month, day, hour, minute, second, and nanoseconds
    int year = tm_info.tm_year + 1900;
    int month = tm_info.tm_mon + 1;
    int day = tm_info.tm_mday;
    int hour = tm_info.tm_hour;
    int minute = tm_info.tm_min;
    int second = tm_info.tm_sec;
    
    *yyyymmdd = day + 60 * ( month + 60 * year);
    *hhmmss = second + 60 * ( minute + 60 * hour);
    
}

// now as a zero-terminated string timestamp in ISO standard 8601 format https://en.wikipedia.org/wiki/ISO_8601
FORTHBASE_API char *timestamp(char *caddr, int flags)
{
    struct tm tm_info = { 0 };
    _now(tm_info, flags);

    // Extract year, month, day, hour, minute, second (fractions of seconds are ignored in this version)
    int year = tm_info.tm_year + 1900;
    int month = tm_info.tm_mon + 1;
    int day = tm_info.tm_mday;
    int hour = tm_info.tm_hour;
    int minute = tm_info.tm_min;
    int second = tm_info.tm_sec;

    (void) sprintf_s(caddr, 256, "%04d-%02d-%02dT%02d:%02d:%02d", year, month, day, hour, minute, second);
    return(caddr);
 
}

// return the total bias between UT and local time in minutes (including DST if applicable) and a flag to indicate if DST is in operation
FORTHBASE_API void timezone(int *bias, int *DST)
{
        TIME_ZONE_INFORMATION tzInfo;
        DWORD result = GetTimeZoneInformation(&tzInfo);
        // https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/ns-timezoneapi-time_zone_information

        *bias = tzInfo.Bias;   
        // UTC = local time + bias

        *DST = (result == TIME_ZONE_ID_DAYLIGHT ? -1 : 0);

}

// A UUID
FORTHBASE_API char *makeUUID(char *caddr)
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
