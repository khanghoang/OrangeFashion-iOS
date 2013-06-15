//
//  BaseTableViewController.m
//  OrangeFashion
//
//  Created by Khang on 15/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "BaseTableViewController.h"
#import "IIViewDeckController.h"

@interface BaseTableViewController () <IIViewDeckControllerDelegate>

@end

@implementation BaseTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Nav left button
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"left-nav-button"] forState:UIControlStateNormal];
    [leftButton addTarget:self.viewDeckController action:@selector(toggleLeftView) forControlEvents:UIControlEventTouchUpInside];
    
    leftButton.frame = CGRectMake(0, 0, 50, 40);
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
    // Nav right button
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitle:@"Back" forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0, 0, 44, 60);
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventAllTouchEvents];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(getBackVC)];
    swipeGesture.numberOfTouchesRequired = 1;  
}

- (void)rightButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
