//
//  UIScrollView+Additions.h
//  workflowww
//
//  Created by Torin on 18/5/13.
//  Copyright (c) 2013 workflowww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (Additions)

- (void)autoAdjustScrollViewContentSize;

- (void)scrollSubviewToCenter:(UIView*)subview animated:(BOOL)animated;

@end
