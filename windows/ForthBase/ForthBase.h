
#pragma once
#define _USE_MATH_DEFINES
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <rpc.h>

#define UUID_length 37
#pragma comment(lib, "Rpcrt4.lib")

#ifdef FORTHBASE_EXPORTS
	#define FORTHBASE_API __declspec(dllexport)
#else
	#define FORTHBASE_API __declspec(dllimport)
#endif

// return a tm_info (formated time) object according to the specified flags
void _now(struct tm tm_info, int flags);

// Return a version number
FORTHBASE_API int version();

// The time and date, UTC or local
FORTHBASE_API void now(int *yyyymmdd, int *hhmmss, int flags);

// Timestamp
FORTHBASE_API char *timestamp(char *caddr, int flags);

// Timezone information
FORTHBASE_API void timezone(int* bias, int* DST);

// A UUID
FORTHBASE_API char *makeUUID(char *caddr);
