//
// Copyright 2013 Aaron Sittig. All rights reserved
// All code is governed by the BSD-style license at
// http://github.com/aaron--/additions
//

#import "NSData+.h"
#import "NSString+.h"
#import "Base64+.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSData (Additions)

- (NSString*)base64
{
  NSString*       stringOut;
  char*           encoded;
  unsigned long   encodedLength;
  
  encoded = base64_encode([self bytes], [self length], &encodedLength);
  stringOut = [[NSString alloc] initWithBytes:encoded
                                 length:encodedLength
                                      encoding:NSASCIIStringEncoding];
  free(encoded);
  return stringOut;
}

- (NSString*)hex
{
  char*           digits = "0123456789abcdef";
  NSMutableData*  scratchData;
  NSInteger       length;
  const UInt8*    src;
  UInt8*          dst;
  
  // Can't Convert No Data
  length = [self length];
  if([self length] == 0) return @"";
  
  // Set Up Buffers
  scratchData = [NSMutableData dataWithLength:[self length]*2];
  src = [self bytes];
  dst = [scratchData mutableBytes];
  
  // Loop and Convert
  while(length-- > 0)
  {
    // Convert Each 4 bits to Hex ASCII char byte
    *dst++ = digits[(*src >> 4) & 0x0f];
    *dst++ = digits[(*src++ & 0x0f)];
  }
  return [NSString utf8StringWithData:scratchData];
}

- (NSData*)md5digest
{
  UInt8     digest[CC_MD5_DIGEST_LENGTH];
  
  CC_MD5([self bytes], (unsigned int)[self length], digest);
  return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

- (NSString*)md5hexdigest
{
  return [[self md5digest] hex];
}

- (NSData*)sha1Digest
{
  UInt8     digest[CC_SHA1_DIGEST_LENGTH];
  
  CC_SHA1([self bytes], (unsigned int)[self length], digest);
  return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData*)sha1HMacWithKey:(NSString*)key
{
  UInt8     digest[CC_SHA1_DIGEST_LENGTH];
  NSData*   keyData;
  
  keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
  CCHmac(kCCHmacAlgSHA1, [keyData bytes], (unsigned int)[keyData length],
                         [self bytes], (unsigned int)[self length], digest);
  return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

@end
