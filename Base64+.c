//
// Copyright 2013 Aaron Sittig. All rights reserved
// All code is governed by the BSD-style license at
// http://github.com/aaron--/additions
//

#include "Base64+.h"

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
static const short _base64DecodingTable[256] = {
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -1, -1, -2, -1, -1, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -1, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 62, -2, -2, -2, 63,
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -2, -2, -2, -2, -2, -2,
    -2,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2,
    -2, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2
};

char* base64_encode(const unsigned char* data,
                    unsigned long length,
                    unsigned long* lengthOut)
{
    char* objPointer;
    char* strResult;

    // Require length > 0
    if(length == 0) return NULL;
    
    // Setup the String-based Result placeholder and pointer within that placeholder
    *lengthOut = ((length + 2) / 3) * 4;
    strResult = (char *)calloc(((length + 2) / 3) * 4, sizeof(char));
    objPointer = strResult;
    
    // Iterate through everything
    while (length > 2) { // keep going until we have less than 24 bits
        *objPointer++ = _base64EncodingTable[data[0] >> 2];
        *objPointer++ = _base64EncodingTable[((data[0] & 0x03) << 4) + (data[1] >> 4)];
        *objPointer++ = _base64EncodingTable[((data[1] & 0x0f) << 2) + (data[2] >> 6)];
        *objPointer++ = _base64EncodingTable[data[2] & 0x3f];
        
        // we just handled 3 octets (24 bits) of data
        data += 3;
        length -= 3; 
    }
    
    // now deal with the tail end of things
    if (length != 0) {
        *objPointer++ = _base64EncodingTable[data[0] >> 2];
        if (length > 1) {
            *objPointer++ = _base64EncodingTable[((data[0] & 0x03) << 4) + (data[1] >> 4)];
            *objPointer++ = _base64EncodingTable[(data[1] & 0x0f) << 2];
            *objPointer++ = '=';
        } else {
            *objPointer++ = _base64EncodingTable[(data[0] & 0x03) << 4];
            *objPointer++ = '=';
            *objPointer++ = '=';
        }
    }
    
    // Return
    return strResult;
}

char* base64_decode(const char* string,
                    unsigned long length,
                    unsigned long* lengthOut)
{
    char* result;
    int i = 0, j = 0, k;
    int intCurrent;
    
    result = calloc(length, sizeof(char));

    // Run through the whole string, converting as we go
    while ( ((intCurrent = *string++) != '\0') && (length-- > 0) ) {
        if (intCurrent == '=') {
            if (*string != '=' && ((i % 4) == 1)) {// || (intLength > 0)) {
                // the padding character is invalid at this point -- so this entire string is invalid
                free(result);
                return NULL;
            }
            continue;
        }
        
        intCurrent = _base64DecodingTable[intCurrent];
        if (intCurrent == -1) {
            // we're at a whitespace -- simply skip over
            continue;
        } else if (intCurrent == -2) {
            // we're at an invalid character
            free(result);
            return NULL;
        }
        
        switch (i % 4) {
            case 0:
                result[j] = intCurrent << 2;
                break;
                
            case 1:
                result[j++] |= intCurrent >> 4;
                result[j] = (intCurrent & 0x0f) << 4;
                break;
                
            case 2:
                result[j++] |= intCurrent >>2;
                result[j] = (intCurrent & 0x03) << 6;
                break;
                
            case 3:
                result[j++] |= intCurrent;
                break;
        }
        i++;
    }
    
    // mop things up if we ended on a boundary
    k = j;
    if (intCurrent == '=') {
        switch (i % 4) {
            case 1:
                // Invalid state
                free(result);
                return NULL;
                
            case 2:
                k++;
                // flow through
            case 3:
                result[k] = 0;
        }
    }
    
    // Return
    *lengthOut = j;
    return result;
}

