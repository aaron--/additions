//
// Copyright 2013 Aaron Sittig. All rights reserved
// All code is governed by the BSD-style license at
// http://github.com/aaron--/additions
//

#import "NSObject+.h"

@implementation NSObject (Additions)

- (void)addObserver:(NSObject*)observer forKeyPath:(NSString*)keyPath
{
  [self addObserver:observer
         forKeyPath:keyPath
            options:NSKeyValueObservingOptionOld |
                    NSKeyValueObservingOptionNew |
                    NSKeyValueObservingOptionInitial
            context:nil];
}

@end
