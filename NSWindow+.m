//
// Copyright 2013 Aaron Sittig. All rights reserved
// All code is governed by the BSD-style license at
// http://github.com/aaron--/additions
//

#import "NSWindow+.h"

@implementation NSWindow (Additions)

- (void)orderFrontOrOut:(id)sender
{
  if([self isKeyWindow])
    [self orderOut:sender];
  else
    [self makeKeyAndOrderFront:sender];
}

@end
