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

@end

@implementation BaseViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"left-nav-button"] forState:UIControlStateNormal];
    [leftButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventAllTouchEvents];
    
    leftButton.frame = CGRectMake(0, 0, 50, 40);
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

@end
