//
//  UINavigationController+Additions.h
//  TemplateProject
//
//  Created by Torin on 20/4/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Additions)

- (UIViewController*)previousViewController;
- (void)fadeOutCustomNavbarImage:(UIImage*)image completion:(void (^)(BOOL finished))completion;
- (void)fadeInCustomNavbarImage:(UIImage*)image completion:(void (^)(BOOL finished))completion;

@end
