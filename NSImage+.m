//
// Copyright 2013 Aaron Sittig. All rights reserved
// All code is governed by the BSD-style license at
// http://github.com/aaron--/additions
//

#import "NSImage+.h"

#if !TARGET_OS_IPHONE
@implementation CGImageRefToNSImageTransformer

+ (Class)transformedValueClass
{
  return [NSImage class];
}

+ (BOOL)allowsReverseTransformation
{
  return NO;
}

- (id)transformedValue:(id)item
{
  return item ? [[NSImage alloc] initWithCGImage:(CGImageRef)item size:NSZeroSize] : nil;
}

@end
#endif
