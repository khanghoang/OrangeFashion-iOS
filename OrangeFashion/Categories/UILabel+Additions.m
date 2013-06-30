//
//  UILabel+Additions.m
//  FashTag
//
//  Created by Torin on 19/3/13.
//
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (void)sizeToFitKeepHeight
{
  CGFloat nameHeight = CGRectGetHeight(self.frame);
  [self sizeToFit];
  CGRect frame = self.frame;
  frame.size.height = nameHeight;
  self.frame = frame;
}

- (void)sizeToFitKeepWidth
{
  CGFloat nameWidth = CGRectGetWidth(self.frame);
  [self sizeToFit];
  CGRect frame = self.frame;
  frame.size.width = nameWidth;
  self.frame = frame;
}

- (void)applyDrawerTextShadow
{
    self.shadowColor = [UIColor blackColor];
    self.shadowOffset = CGSizeMake(0, 1);
}

@end
