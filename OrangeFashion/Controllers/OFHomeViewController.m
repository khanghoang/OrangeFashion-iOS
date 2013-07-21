//
//  OFHomeViewController.m
//  OrangeFashion
//
//  Created by Khang on 9/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFHomeViewController.h"

@interface OFHomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblShowAllProducts;

@end

@implementation OFHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showProductsList)];
    [self.view addGestureRecognizer:tap];
}

- (void)showProductsList
{
    [self performSegueWithIdentifier:@"From Home To Products List" sender:self];
}

@end
