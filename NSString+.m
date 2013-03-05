//
// Copyright 2013 Aaron Sittig. All rights reserved
// All code is governed by the BSD-style license at
// http://github.com/aaron--/additions
//

#import "NSString+.h"
#import "NSData+.h"
#import "Base64+.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

+ (NSString*)utf8StringWithData:(NSData*)data
{
  return [NSString stringWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString*)stringWithData:(NSData*)data encoding:(NSStringEncoding)encoding
{
  return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSData*)md5digest
{
  NSData*   dataIn;
  UInt8     digest[CC_MD5_DIGEST_LENGTH];
  
  dataIn = [self dataUsingEncoding:NSUTF8StringEncoding];
  CC_MD5([dataIn bytes], (CC_LONG)[dataIn length], digest);
  return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

- (NSString*)md5hexdigest
{
  return [[self md5digest] hex];
}

- (NSDictionary*)md5AttributeDictionary
{
  NSArray*              pairs;
  NSEnumerator*         enumerate;
  NSString*             enumPair;
  NSRange               equalSign;
  NSString*             key;
  NSString*             value;
  NSMutableDictionary*  outDict;
  
  // Loop Comma Separated Pairs
  pairs = [self componentsSeparatedByString:@","];
  outDict = [NSMutableDictionary dictionary];
  enumerate = [pairs objectEnumerator];
  while(( enumPair = [enumerate nextObject] ))
  {
    // Separate Key & Value
    equalSign = [enumPair rangeOfString:@"="];
    if(equalSign.location == NSNotFound)
      continue;
    
    // Add Parts to Dict
    key = [enumPair substringToIndex:equalSign.location];
    value = [enumPair substringFromIndex:equalSign.location + 1];
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    outDict[key] = value;
  }
  
  return outDict;
}

- (NSDictionary*)urlQueryDictionary
{
  NSString*             decoded;
  NSArray*              pairs;
  NSEnumerator*         enumerate;
  NSString*             enumPair;
  NSRange               equalSign;
  NSString*             key;
  NSString*             value;
  NSMutableDictionary*  outDict;
  
  // Loop Ampersand Separated Pairs
  decoded = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  pairs = [decoded componentsSeparatedByString:@"&"];
  outDict = [NSMutableDictionary dictionary];
  enumerate = [pairs objectEnumerator];
  while(( enumPair = [enumerate nextObject] ))
  {
    // Separate Key & Value
    equalSign = [enumPair rangeOfString:@"="];
    if(equalSign.location == NSNotFound)
      continue;
    
    // Add Parts to Dict
    key = [enumPair substringToIndex:equalSign.location];
    value = [enumPair substringFromIndex:equalSign.location + 1];
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    outDict[key] = value;
  }
  
  return outDict;
}

- (NSData*)base64data
{
  NSData*         dataIn;
  NSData*         dataOut;
  char*           decoded;
  unsigned long   decodedLength;
  
  dataIn = [self dataUsingEncoding:NSUTF8StringEncoding];
  decoded = base64_decode([dataIn bytes], [dataIn length], &decodedLength);
  dataOut = [NSData dataWithBytes:decoded length:decodedLength];
  free(decoded);
  
  return dataOut;
}

- (NSString*)stringByRemovingCharactersInSet:(NSCharacterSet*)set
{
  NSRange             range;
  NSMutableString*    output;
  NSUInteger          length;
  NSRange             badRange;
  NSRange             subRange;
  
  // Set Up State
  output = [NSMutableString string];
  length = [self length];
  range  = NSMakeRange(0, length);
  
  // Loop Over String
  while(range.length)
  {
    // Find Unwanted Chars
    badRange = [self rangeOfCharacterFromSet:set options:0 range:range];
    
    // Leave the Loop if we find none
    if(badRange.location == NSNotFound)
    {
      [output appendString:[self substringWithRange:range]];
      range = NSMakeRange(length, 0);
      continue;
    }
    else
    {
      // Save up to bad chars
      subRange.location = range.location,
      subRange.length   = badRange.location - range.location;
      [output appendString:[self substringWithRange:subRange]];
      
      // Update to Remaining Range
      range.location = badRange.location + badRange.length;
      range.length   = length - range.location;
    }
  }
  
  return output;
}

@end
