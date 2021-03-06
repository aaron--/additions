//
// Copyright 2013 Aaron Sittig. All rights reserved
// All code is governed by the BSD-style license at
// http://github.com/aaron--/additions
//

#import "NSDictionary+.h"

@implementation NSDictionary (Additions)

- (BOOL)observedValueInitial
{
  id  oldValue;
  id  newValue;
  
  // If there's an old value, it's not inital
  oldValue   = [self objectForKey:NSKeyValueChangeOldKey];
  newValue   = [self objectForKey:NSKeyValueChangeNewKey];
  return !oldValue && newValue;
}

- (BOOL)observedValueChanged
{
  id  oldValue;
  id  newValue;
  
  // Require Old and New Value to Decide Value Changed
  oldValue = [self objectForKey:NSKeyValueChangeOldKey];
  newValue = [self objectForKey:NSKeyValueChangeNewKey];
  if(!oldValue || !newValue) return NO;
  
  // Compare
  return ![oldValue isEqual:newValue];
}

@end
