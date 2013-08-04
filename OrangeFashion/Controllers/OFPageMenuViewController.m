//
//  OFPageMenuViewController.m
//  OrangeFashion
//
//  Created by Khang on 3/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFPageMenuViewController.h"
#import "DAPagesContainer.h"
#import "OFMenuViewController.h"
#import "OFWaterFallProductsViewController.h"
#import "OFProductDetailsViewController.h"
#import "OFCollectionViewCell.h"

@interface OFPageMenuViewController () <OFCollectionViewCellDelegate>

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation OFPageMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Orange Fashion";
    // Do any additional setup after loading the view from its nib.
    
    [self.navigationController setNavigationBarHidden:NO];
    
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = self.view.bounds;
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
    // Disable page wrapper scroll view
    self.pagesContainer.scrollView.gestureRecognizers = nil;
    self.pagesContainer.observingScrollView.gestureRecognizers = nil;
    
    OFMenuViewController *menu = [[OFMenuViewController alloc] init];
    
    menu.title = @"Danh mục";
    
    OFWaterFallProductsViewController *menu2 = [[OFWaterFallProductsViewController alloc] init];
    menu2.parentVC = self;
    menu2.title = @"Hàng mới về";
    
    OFMenuViewController *menu3 = [[OFMenuViewController alloc] init];
    menu3.title = @"Dummy 2";
    
    self.pagesContainer.viewControllers = @[menu, menu2, menu3];
}

#pragma mark - OFCollectionViewCellDelegate

- (void)onTapCollectionViewCell:(NSNumber *)productID
{
    OFProductDetailsViewController *desVC = [[OFProductDetailsViewController alloc] init];
    desVC.productID = productID;
    OFNavigationViewController *centralNavVC = (OFNavigationViewController *) self.viewDeckController.centerController;
    [centralNavVC pushViewController:desVC animated:YES];
}

@end
