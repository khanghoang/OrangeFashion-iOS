//
//  UIScrollView+Additions.m
//  workflowww
//
//  Created by Torin on 18/5/13.
//  Copyright (c) 2013 workflowww. All rights reserved.
//

#import "UIScrollView+Additions.h"

@implementation UIScrollView (Additions)

/*
 * Auto adjust content size for UIScrollView according to its subviews
 */
- (void)autoAdjustScrollViewContentSize
{
    CGFloat maxY = 0;
    for (UIView *subview in self.subviews)
        if (maxY < CGRectGetMaxY(subview.frame))
            maxY = CGRectGetMaxY(subview.frame);
    maxY += 5;
    
    //This to make it always scroll
    if (maxY <= self.height)
        maxY = self.height + 1;
    
    self.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), maxY);
}

- (void)scrollSubviewToCenter:(UIView*)subview animated:(BOOL)animated
{
    if ([self.subviews indexOfObject:subview] == NSNotFound)
        return;
    
    CGPoint offset = self.contentOffset;
    CGFloat height = CGRectGetHeight(self.bounds) - self.contentInset.top - self.contentInset.bottom;
    height = ABS(height);
    
    offset.y = CGRectGetMidY(subview.frame) - height/2;
    if (offset.y < 0)
        offset.y = 0;
    if (offset.y + height > self.contentSize.height)
        offset.y = self.contentSize.height - height;
    
    [self setContentOffset:offset animated:animated];
}

@end
