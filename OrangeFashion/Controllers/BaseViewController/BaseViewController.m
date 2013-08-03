//
//  BaseViewController.m
//  OrangeFashion
//
//  Created by Khang on 15/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "BaseViewController.h"
#import "IIViewDeckController.h"

@interface BaseViewController() <IIViewDeckControllerDelegate>

- (void)rightButtonClicked;

@end

@implementation BaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self trackCritercismBreadCrumb:__LINE__];
    [self addNavigationItems];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.trackedViewName = self.title;
}

- (void)addNavigationItems
{
    // Nav left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (self == [[self.navigationController viewControllers] objectAtIndex:0]) {
        [leftButton setImage:[UIImage imageNamed:@"left-nav-button"] forState:UIControlStateNormal];
        [leftButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [leftButton setImage:[UIImage imageNamed:@"nav-back-btn-bg"] forState:UIControlStateNormal];
        [leftButton addTarget:self action:@selector(onBtnBack) forControlEvents:UIControlEventTouchUpInside];
    }

    leftButton.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    // Nav right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"bookmark_list"] forState:UIControlStateNormal];
    [rightButton addTarget:self.viewDeckController action:@selector(toggleRightView) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)onBtnBack
{    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)trackCritercismBreadCrumb:(NSUInteger)lineNumber
{
    NSString *breadcrumb = [NSString stringWithFormat:@"%@:%d", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], lineNumber];
    [Crittercism leaveBreadcrumb:breadcrumb];
}

- (void)trackAnalytics:(NSString*)eventName
{
//    [Flurry logEvent:];
}

@end
