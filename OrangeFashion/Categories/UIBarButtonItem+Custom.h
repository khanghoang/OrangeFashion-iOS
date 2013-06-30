//
//  UIBarButtonItem+Custom.h
//
//
//  Created by Hu Junfeng on 16/5/13.
//  Copyright (c) 2013 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Custom)

+ (UIBarButtonItem *)appBackButtonWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)appRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)appMenuButtonWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)appListButtonWithTarget:(id)target action:(SEL)action;
+ (UIBarButtonItem *)appShareButtonWithTarget:(id)target action:(SEL)action;
@end
