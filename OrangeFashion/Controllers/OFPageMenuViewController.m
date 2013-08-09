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
#import "OFHomeTableViewCell.h"
#import "OFSidebarMenuTableCell.h"

@interface OFPageMenuViewController () <OFCollectionViewCellDelegate, OFHomeTableViewCellDelegate>

@property (strong, nonatomic) DAPagesContainer * pagesContainer;

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
    [self.pagesContainer setSelectedIndex:0];
    [self.pagesContainer setSelectedIndex:1];
    [self.pagesContainer setSelectedIndex:2];
    
    OFMenuViewController *menu = [[OFMenuViewController alloc] init];
    menu.parentVC = self;
    menu.title = @"Danh mục";
    
    OFWaterFallProductsViewController *menu2 = [[OFWaterFallProductsViewController alloc] init];
    menu2.parentVC = self;
    menu2.title = @"Hàng mới về";
    
    BaseViewController *menu3 = [[BaseViewController alloc] init];    
    CGRect frame = self.view.frame;
    frame.size.height -= 170;
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:frame];
    [menu3.view addSubview:web];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://orangefashion.vn/thong-tin-thanh-toan.html"]];
//    [web loadRequest:request];

    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"thong-tin-thanh-toan.html"];
    NSURL *url = [NSURL fileURLWithPath:path isDirectory:NO];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    
    menu3.title = @"Hướng dẫn đặt hàng";
    
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

#pragma mark - OFHomeTableViewCell

- (void)onTapHomeTableViewCell:(NSDictionary *)data
{
    OFProductsViewController *productsVC = [[OFProductsViewController alloc] init];
    
    int categoryID = 0;
    if ([data[CATEGORY_ID] isKindOfClass:[NSNumber class]]) {
        categoryID = [data[CATEGORY_ID] integerValue];
    }
    
    productsVC.category_id = categoryID;
    productsVC.lblTitle = data[MENU_TITLE];
    
    OFNavigationViewController *navVC = (OFNavigationViewController *)self.viewDeckController.centerController;
    [navVC pushViewController:productsVC animated:YES];
}

@end
