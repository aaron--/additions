//
// Copyright 2013 Aaron Sittig. All rights reserved
// All code is governed by the BSD-style license at
// http://github.com/aaron--/additions
//

#import "NSView+.h"

@implementation NSView (Additions)

- (CGFloat)left {
  return [self frame].origin.x;
}

- (void)setLeft:(CGFloat)x {
  CGRect frame = [self frame];
  frame.origin.x = x;
  [self setFrame:frame];
}

- (CGFloat)top {
  return [self frame].origin.y;
}

- (void)setTop:(CGFloat)y {
  CGRect frame = [self frame];
  frame.origin.y = y;
  [self setFrame:frame];
}

- (CGFloat)right {
  return [self frame].origin.x + [self frame].size.width;
}

- (void)setRight:(CGFloat)right {
  CGRect frame = [self frame];
  frame.origin.x = right - frame.size.width;
  [self setFrame:frame];
}

- (CGFloat)bottom {
  return [self frame].origin.y + [self frame].size.height;
}

- (void)setBottom:(CGFloat)bottom {
  CGRect frame = [self frame];
  frame.origin.y = bottom - frame.size.height;
  [self setFrame:frame];
}

- (CGFloat)width {
  return [self frame].size.width;
}

- (void)setWidth:(CGFloat)width {
  CGRect frame = [self frame];
  frame.size.width = width;
  [self setFrame:frame];
}

- (CGFloat)height {
  return [self frame].size.height;
}

- (void)setHeight:(CGFloat)height {
  CGRect frame = [self frame];
  frame.size.height = height;
  [self setFrame:frame];
}

- (CGPoint)origin {
  return [self frame].origin;
}

- (void)setOrigin:(CGPoint)origin {
  CGRect frame = [self frame];
  frame.origin = origin;
  [self setFrame:frame];
}

- (CGSize)size {
  return [self frame].size;
}

- (void)setSize:(CGSize)size {
  CGRect frame = [self frame];
  frame.size = size;
  [self setFrame:frame];
}

@end
