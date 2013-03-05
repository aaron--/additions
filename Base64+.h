
#include <stdlib.h>

#ifndef Titan_Base64__h
#define Titan_Base64__h

char* base64_encode(const unsigned char* data,
                    unsigned long length,
                    unsigned long* lengthOut);
char* base64_decode(const char* string,
                    unsigned long length,
                    unsigned long* lengthOut);

#endif
