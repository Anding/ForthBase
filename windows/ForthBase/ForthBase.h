// Astronomy calculations based on Duffett-Smith and Zwart, "Practical Astronomy"

#pragma once
#define _USE_MATH_DEFINES
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

// Return a version number
FORTHBASE_API int version();

// The local time and date
FORTHBASE_API void now_local(int* yyyymmdd, int* hhmmss);

// The UTC time and date
FORTHBASE_API void now_UTC(int* yyyymmdd, int* hhmmss);

// A UUID
FORTHBASE_API char* makeUUID(char* caddr);
