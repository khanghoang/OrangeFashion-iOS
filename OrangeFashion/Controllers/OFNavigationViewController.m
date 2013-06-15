//
//  OFNavigationViewController.m
//  OrangeFashion
//
//  Created by Khang on 15/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFNavigationViewController.h"

@interface OFNavigationViewController ()

@end

@implementation OFNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self == nil)
        return self;
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbg"] forBarMetrics:UIBarMetricsDefault];
    
//    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(getBackVC)];
//    
//    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.navigationBar addGestureRecognizer:swipeGesture];
//    
//    UISwipeGestureRecognizer *swipeGesture2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(getForwardVC)];
//    
//    [swipeGesture2 setDirection:UISwipeGestureRecognizerDirectionLeft];
//    [self.navigationBar addGestureRecognizer:swipeGesture2];
    
    return self;
}

- (UIViewController*)initWithNib
{
    NSString *className = NSStringFromClass([self class]);
    self = [self initWithNibName:className bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//- (void)getBackVC
//{
//    DLog(@"RIGHT");
//}
//
//- (void)getforwardVC
//{
//    DLog(@"LEFT");
//}

@end
