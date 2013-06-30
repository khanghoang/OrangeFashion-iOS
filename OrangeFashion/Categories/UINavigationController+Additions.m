//
//  UINavigationController+Additions.m
//  TemplateProject
//
//  Created by Torin on 20/4/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "UINavigationController+Additions.h"

@implementation UINavigationController (Additions)

- (UIViewController*)previousViewController
{
  NSUInteger count = [self.viewControllers count];
  if (count <= 1)
    return nil;
  
  return [self.viewControllers objectAtIndex:count-2];
}

- (void)fadeOutCustomNavbarImage:(UIImage *)image completion:(void (^)(BOOL finished))completion
{
  UIImageView *backgroundImgView = [[UIImageView alloc] initWithImage:image];
  backgroundImgView.frame = self.navigationBar.bounds;
  [self.navigationBar addSubview:backgroundImgView];
  
  [UIView animateWithDuration:0.5 animations:^{
    backgroundImgView.alpha = 0;
    
  } completion:^(BOOL finished) {
    
    [backgroundImgView removeFromSuperview];
    if (completion)
      completion(finished);
  }];
}

- (void)fadeInCustomNavbarImage:(UIImage *)image completion:(void (^)(BOOL finished))completion
{
  UIImageView *backgroundImgView = [[UIImageView alloc] initWithImage:image];
  backgroundImgView.frame = self.navigationBar.bounds;
  backgroundImgView.alpha = 0;
  [self.navigationBar addSubview:backgroundImgView];
  
  [UIView animateWithDuration:0.5 animations:^{
    backgroundImgView.alpha = 1;
    
  } completion:^(BOOL finished) {
    
    [backgroundImgView removeFromSuperview];
    if (completion)
      completion(finished);
  }];
}


@end
