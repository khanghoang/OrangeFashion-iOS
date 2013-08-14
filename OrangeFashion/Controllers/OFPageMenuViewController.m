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
    menu3.title = @"Hướng dẫn đặt hàng";
    
    frame.size.height -= 170;
    
    UIWebView *web = [[UIWebView alloc] initWithFrame:frame];

    [menu3.view addSubview:web];
    NSURL *url = [NSURL URLWithString:@"http://orangefashion.vn/thong-tin-thanh-toan.html"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // get document directory
    NSString *documentPath = [self applicationDocumentsDirectory];
    NSString* path=[documentPath stringByAppendingPathComponent:@"thong-tin-san-pham.html"];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Save html to disk %@", path);
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // Deal with failure
        [web loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
        
    }];
    
    web.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
    
    [operation start];
    
    self.pagesContainer.viewControllers = @[menu, menu2, menu3];
}

- (NSString *)applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
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
