//
//  UIWebView+Additions.m
//  TemplateProject
//
//  Created by Torin on 17/2/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "UIWebView+Additions.h"

@implementation UIWebView (Additions)

//Remove webview shadow when bounce
- (void)removeTopBottomShadow
{
  for (UIView* subView in self.subviews)
    if ([subView isKindOfClass:[UIScrollView class]])
      for (UIView* shadowView in [subView subviews])
        if ([shadowView isKindOfClass:[UIImageView class]])
          [shadowView setHidden:YES];
}

@end
