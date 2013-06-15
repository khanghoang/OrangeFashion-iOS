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
    
    // Nav left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"left-nav-button"] forState:UIControlStateNormal];
    [leftButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventAllTouchEvents];
    
    leftButton.frame = CGRectMake(0, 0, 50, 40);
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    [self.viewDeckController centerhiddenInteractivity];
    
    
    // Nav right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventAllTouchEvents];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)rightButtonClicked
{
    [self.viewDeckController.centerController.navigationController popViewControllerAnimated:YES];
}

@end
