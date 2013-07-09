//
//  OFProductDetailsViewController.m
//  OrangeFashion
//
//  Created by Khang on 1/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFProductDetailsViewController.h"
#import "OFImageViewController.h"
#import "OFProductImages.h"
#import "OFProduct.h"

typedef void (^MRStoreCompletedBlock)(BOOL success, NSError *error);

@interface OFProductDetailsViewController () 

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) UIPageViewController *pageVC;
@property (assign, nonatomic) int currentVC;
@property (weak, nonatomic) IBOutlet SMPageControl *pageControl;

@end

@implementation OFProductDetailsViewController

#pragma mark - Controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    [SVProgressHUD showWithStatus:@"Đang tải hình ảnh cho sản phẩm"];
    
    OFProduct *product = [OFProduct productWithDictionary:@{ @"MaSanPham" : self.productID}];
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    
    [[self.pageVC view] setFrame:[[self view] bounds]];
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    [pageControl setNumberOfPages:10];
    pageControl.frame = CGRectMake(0, 0, 50, 200);
    [self.view addSubview:pageControl];
    [self.view bringSubviewToFront:pageControl];
    
    [OFProductImages getImagesForProduct:product successBlock:^(NSInteger statusCode, id obj) {
        
        [SVProgressHUD dismiss];
        [self addPageViewControllerWithImagesArray:obj];
        [self storeImagesWithID:obj completeBlock:nil];
        
    } failureBlock:^(NSInteger statusCode, id obj2) {
        //handle errors
        [SVProgressHUD showErrorWithStatus:@"Lỗi không tải được hình ảnh, vui lòng thử lại"];
        [self addPageViewControllerWithImagesArray:[self getImages]];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - Add PageViewController

- (void)addPageViewControllerWithImagesArray:(NSArray *)arrImages
{
    if (arrImages.count == 0){
        [SVProgressHUD showErrorWithStatus:@"Không thể tải hình ảnh, vui lòng thử lại sau."];
        return;
    }
    
    self.images = arrImages;
    
    self.currentVC = 0;
    
    NSMutableArray *arrVC = [[NSMutableArray alloc] init];
    
    OFImageViewController *imageVC = [[OFImageViewController alloc] initWithNibName:@"OFImageViewController" bundle:nil];
    
    imageVC.imageURL = [[self.images objectAtIndex:0] picasa_store_source];
    
    [arrVC addObject:imageVC];
    
    [self.pageVC setViewControllers:arrVC direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageVC];
    self.pageVC.view.frame = self.view.frame;
    
    [self.view addSubview:self.pageVC.view];
    [self.pageVC didMoveToParentViewController:self];
    
    CGRect pageViewRect = self.view.frame;
    pageViewRect = CGRectInset(pageViewRect, 0, 0);
    self.pageVC.view.frame = pageViewRect;
    
    self.view.gestureRecognizers = self.pageVC.gestureRecognizers;
    
    [self addPageControlView];
}

#pragma mark - Helpers

- (void)addPageControlView
{
    // page control
    UIImageView *pageControllWrap = [[UIImageView alloc] initWithFrame:CGRectMake(0, 380, 320, 40)];
    [pageControllWrap setImage:[UIImage imageNamed:@"pagecontrol-bg"]];
    [self.view addSubview:pageControllWrap];
    [self.view bringSubviewToFront:pageControllWrap];
    
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPage = 0;
    self.pageControl.frame = CGRectMake(0, 380, 320, 40);
    [self.view addSubview:self.pageControl];
}

#pragma mark - PageViewController delegate

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.currentVC == self.images.count - 1)
        return nil;
    
    OFImageViewController *imageVC = [[OFImageViewController alloc] init];
    imageVC.imageURL = [[self.images objectAtIndex:self.currentVC + 1] picasa_store_source];
    
    self.currentVC++;
    self.pageControl.currentPage = self.currentVC;
    
    return imageVC;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    if (self.currentVC == 0)
        return nil;
    
    OFImageViewController *imageVC = [[OFImageViewController alloc] init];
    imageVC.imageURL = [[self.images objectAtIndex:self.currentVC - 1] picasa_store_source];
    
    self.currentVC--;
    self.pageControl.currentPage = self.currentVC;
    
    return imageVC;
}

#pragma mark - Store and get data

- (void)storeImagesWithID:(id)arrImages completeBlock:(MRStoreCompletedBlock)completeBlock
{
    OFProduct *product = [[OFProduct MR_findByAttribute:@"product_id" withValue:self.productID] lastObject];
    product.images = [NSSet setWithArray:arrImages];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
    [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        DLog(@"Store finished");
        if (completeBlock)
            completeBlock(success, error);
    }];
}

- (NSArray *)getImages
{
    OFProduct *product = [[OFProduct MR_findByAttribute:@"product_id" withValue:self.productID] lastObject];
    return [product.images allObjects];
}

@end
