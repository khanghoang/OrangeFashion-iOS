//
//  KHImageViewController.m
//  DemoPageViewController
//
//  Created by Khang on 2/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "KHImageViewController.h"

@interface KHImageViewController ()

@end

@implementation KHImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lb.text = self.label;
    [self.imgView setImage:[UIImage imageNamed:self.imgURL]];
    
//    [self.view addSubview:self.imgView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
