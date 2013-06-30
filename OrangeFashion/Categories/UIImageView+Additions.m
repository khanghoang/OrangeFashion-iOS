//
//  UIImageView+Additions.m
//  TemplateProject
//
//  Created by Torin on 19/4/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "UIImageView+Additions.h"

@implementation UIImageView (Additions)

- (void)fadeToImage:(UIImage*)newImage duration:(CGFloat)duration
{
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
  imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  imageView.contentMode = self.contentMode;
  imageView.image = newImage;
  imageView.alpha = 0;
  [self addSubview:imageView];
  
  [UIView animateWithDuration:duration animations:^{
    imageView.alpha = 1;
    
  } completion:^(BOOL finished) {
    self.image = newImage;
    imageView.image = nil;
    [imageView removeFromSuperview];
  }];
}

@end
