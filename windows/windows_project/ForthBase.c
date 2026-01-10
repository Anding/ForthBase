// Must set properties / Precompiled Headers / Precompiled Header / Not using...
// Forth utility functions from the windows system

#include "ForthBase.h"

// Return a version number
int ForthBaseVersion()
{
    int main_version = 0;
    int minor_version = 1;
    int release = 1;
    int version_number = minor_version + 60 * (main_version + 60 * release);

    return version_number;

}

void _now(struct tm *tm_info, int flags)
{
    time_t t;

    // Get the current time
    t = time(NULL);

    // offset from "today" to "today's night" if requested
    if ((flags & 2) == 2) {
        t -= (time_t)60 * 60 * 12;
    }

    // format the current time in UT or local format in a tm_info structure
    // https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/localtime-s-localtime32-s-localtime64-s?view=msvc-170
    if ((flags & 1) == 0) {
        (void)gmtime_s(tm_info, &t);
    }
    else {
        (void)localtime_s(tm_info, &t);
    }
}

// The time and date
FORTHBASE_API void ForthBaseNow(int* yyyymmdd, int* hhmmss, int flags)
{
    int year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0;
    struct tm tm_info = { 0 };

    _now(&tm_info, flags);

    // Extract year, month, day, hour, minute, second, and nanoseconds
    year = tm_info.tm_year + 1900;
    month = tm_info.tm_mon + 1;
    day = tm_info.tm_mday;
    if ((flags & 2) == 0) {             // time is N/A for "today's night"
        hour = tm_info.tm_hour;
        minute = tm_info.tm_min;
        second = tm_info.tm_sec;
    }
    *yyyymmdd = day + 60 * ( month + 60 * year);
    *hhmmss = second + 60 * ( minute + 60 * hour);
    
}

// now as a zero-terminated string timestamp in ISO standard 8601 format https://en.wikipedia.org/wiki/ISO_8601
FORTHBASE_API char *ForthBaseTimestamp(char *caddr, int flags)
{
    int year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0;
    int bias = 0, bias_hours = 0, bias_minutes = 0;
    struct tm tm_info = { 0 };
    TIME_ZONE_INFORMATION tzInfo;

    _now(&tm_info, flags);

    year = tm_info.tm_year + 1900;
    month = tm_info.tm_mon + 1;
    day = tm_info.tm_mday;
    if ((flags & 2) == 0) {
        hour = tm_info.tm_hour;
        minute = tm_info.tm_min;
        second = tm_info.tm_sec;
    }

    if ((flags & 1) == 0) {
        (void)sprintf_s(caddr, TIMESTAMP_length, "%04d-%02d-%02dT%02d:%02d:%02dZ", year, month, day, hour, minute, second);
    }
    else {
        WORD result = (WORD)GetTimeZoneInformation(&tzInfo);
        bias = tzInfo.Bias - (result == TIME_ZONE_ID_DAYLIGHT ? 60 : 0);    // tzInfo.Bias is the base timezone offset ignoring DST
        bias_hours = - bias / 60;
        bias_minutes = abs(bias + bias_hours * 60);
        (void)sprintf_s(caddr, TIMESTAMP_length, "%04d-%02d-%02dT%02d:%02d:%02d%+03d:%02d", year, month, day, hour, minute, second, bias_hours, bias_minutes );
    }

    return(caddr);
 
}

// return the total bias between UT and local time in minutes (including DST if applicable) and a flag to indicate if DST is in operation
FORTHBASE_API void ForthBaseTimezone(int *bias, int *DST)
{
        TIME_ZONE_INFORMATION tzInfo;
        DWORD result = GetTimeZoneInformation(&tzInfo);
        // https://learn.microsoft.com/en-us/windows/win32/api/timezoneapi/ns-timezoneapi-time_zone_information

        *bias = tzInfo.Bias - (result == TIME_ZONE_ID_DAYLIGHT ? 60 : 0);
        // UTC = local time + bias

        *DST = (result == TIME_ZONE_ID_DAYLIGHT ? -1 : 0);

}

// A UUID
FORTHBASE_API char *ForthbaseUUID(char *caddr)
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
