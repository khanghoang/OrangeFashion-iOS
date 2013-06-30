//
//  UIBarButtonItem+Custom.m
//
//
//  Created by Hu Junfeng on 16/5/13.
//  Copyright (c) 2013 2359 Media Pte Ltd. All rights reserved.
//

#import "UIBarButtonItem+Custom.h"

@implementation UIBarButtonItem (Custom)

+ (UIBarButtonItem *)appBackButtonWithTarget:(id)target action:(SEL)action
{
    return [UIBarButtonItem appBarButtonItemWithTarget:target action:action imageNamed:@"bt_back" isLeftPosition:YES];
}

+ (UIBarButtonItem *)appRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont lightCondensedAppFontOfSize:18];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexValue:0xd31c1d] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor colorWithHexValue:0x470809] forState:UIControlStateHighlighted];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    rightButton.backgroundColor = [UIColor whiteColor];
    
    if (target && action) {
        [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    rightButton.frame = containerView.bounds;
    rightButton.left = 4;
    [containerView addSubview:rightButton];
    
    return [[UIBarButtonItem alloc] initWithCustomView:containerView];
}

+ (UIBarButtonItem *)appBarButtonItemWithTarget:(id)target action:(SEL)action imageNamed:(NSString *)name isLeftPosition:(BOOL)isLeft
{
    UIImage *barButtonItemImage = [UIImage imageNamed:name];
    UIButton *barButtonItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButtonItemButton setImage:barButtonItemImage forState:UIControlStateNormal];
    if (isLeft)
        [barButtonItemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    else
        [barButtonItemButton setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
    barButtonItemButton.backgroundColor = [UIColor clearColor];
    barButtonItemButton.size = CGSizeMake(44, 44);
    if (target && action) {
        [barButtonItemButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[UIBarButtonItem alloc] initWithCustomView:barButtonItemButton];
}

+ (UIBarButtonItem *)appMenuButtonWithTarget:(id)target action:(SEL)action
{
    return [UIBarButtonItem appBarButtonItemWithTarget:target action:action imageNamed:@"menu" isLeftPosition:YES];
}

+ (UIBarButtonItem *)appListButtonWithTarget:(id)target action:(SEL)action
{
    return [UIBarButtonItem appBarButtonItemWithTarget:target action:action imageNamed:@"list" isLeftPosition:NO];
}

+ (UIBarButtonItem *)appShareButtonWithTarget:(id)target action:(SEL)action
{
    return [UIBarButtonItem appBarButtonItemWithTarget:target action:action imageNamed:@"bt_share" isLeftPosition:NO];
}

@end
