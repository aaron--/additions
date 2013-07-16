
#import "NSArray+.h"

@implementation NSArray (Additions)

- (NSArray*)arrayByRemovingObject:(id)object
{
  NSMutableArray*   modified;
  
  // Ignore Nil Parameters
  if(!object) return self;
  
  // Avoid an allocation if object isn't member
  if(![self containsObject:object]) return self;
  
  // Modify a mutable copy
  modified = [NSMutableArray arrayWithArray:self];
  [modified removeObject:object];
  return modified;
}


@end
