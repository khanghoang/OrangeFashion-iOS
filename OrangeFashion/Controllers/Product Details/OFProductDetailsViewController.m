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

@interface OFProductDetailsViewController ()  <OFImageViewControllerDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSArray                   * images;
@property (strong, nonatomic) UIPageViewController      * pageVC;
@property (assign, nonatomic) int                         currentVC;



@property (weak, nonatomic) IBOutlet UIView             * pageControllWrap;
@property (weak, nonatomic) IBOutlet SMPageControl      * pageControl;
@property (weak, nonatomic) IBOutlet UILabel            * lblProductName;
@property (weak, nonatomic) IBOutlet UILabel            * lblProductDisplayID;
@property (weak, nonatomic) IBOutlet UILabel            * lblProductMaterial;
@property (weak, nonatomic) IBOutlet UILabel            * lblProductPrice;


@end

@implementation OFProductDetailsViewController

#pragma mark - Controller lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [SVProgressHUD showWithStatus:@"Đang tải hình ảnh cho sản phẩm"];
    
    OFProduct *product = [OFProduct productWithDictionary:@{ @"MaSanPham" : self.productID}];
    
    // set product info
    self.lblProductName.text = product.name;
    self.lblProductDisplayID.text = [NSString stringWithFormat:@"%@ %@", self.lblProductDisplayID.text, product.product_code];
    self.lblProductMaterial.text = [NSString stringWithFormat:@"%@ %@, %@", self.lblProductMaterial.text, product.colors, product.material];
    self.lblProductPrice.text = [NSString stringWithFormat:@"%@ %@", self.lblProductPrice.text, product.price];
    
    // add pageVC
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    
    [[self.pageVC view] setFrame:[[self view] bounds]];
    
    [OFProductImages getImagesForProduct:product successBlock:^(NSInteger statusCode, id obj) {
        
        [SVProgressHUD dismiss];
        [self addPageViewControllerWithImagesArray:obj];
        [self storeImagesWithID:obj completeBlock:nil];
        
    } failureBlock:^(NSInteger statusCode, id obj2) {
        //handle errors
        [SVProgressHUD showErrorWithStatus:@"Lỗi không tải được hình ảnh, vui lòng thử lại"];
        [self addPageViewControllerWithImagesArray:[self getImages]];
    }];
    
    // add tap gesture in case there's no image.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapProductImages:)];
    [self.view addGestureRecognizer:tap];
    [self.view setUserInteractionEnabled:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    
    NSMutableArray *arrDisplayImage = [arrImages mutableCopy];
    [arrDisplayImage removeObjectAtIndex:0];
    [arrDisplayImage removeObjectAtIndex:0];
    
    self.images = arrDisplayImage;
    
    OFImageViewController *imageVC = [[OFImageViewController alloc] initWithNibName:@"OFImageViewController" bundle:nil];
    imageVC.delegate = self;
    imageVC.imageURL = [[self.images objectAtIndex:0] picasa_store_source];
    
    [self.pageVC setViewControllers:@[imageVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    imageVC.index = 0;
    
    [self addChildViewController:self.pageVC];
    self.pageVC.view.frame = self.view.frame;
    
    [self.view addSubview:self.pageVC.view];
    [self.pageVC didMoveToParentViewController:self];
    
    // swipe guesture
    UISwipeGestureRecognizer *swipeBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeToBack:)];
    [swipeBack setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.pageVC.view addGestureRecognizer:swipeBack];
    swipeBack.delegate = self;
    
    // config Page VC size
    CGRect pageViewRect = self.view.frame;
    pageViewRect = CGRectInset(pageViewRect, 0, 0);
    self.pageVC.view.frame = pageViewRect;
    
    [self addPageControlView];
}

#pragma mark - Helpers

- (void)addPageControlView
{    
    self.pageControl.numberOfPages = self.images.count;
    self.pageControl.currentPage = 0;
    [self.view bringSubviewToFront:self.pageControllWrap];
}

#pragma mark - PageViewController delegate

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    OFImageViewController *imgVC = (OFImageViewController *)viewController;
    int index = imgVC.index;
    
    if (index == self.images.count - 1)
        return nil;

    index ++;    
    return [self viewControllerWithIndex:index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    OFImageViewController *imgVC = (OFImageViewController *)viewController;
    int index = imgVC.index;
    
    if (index == 0)
        return nil;
    
    index--;
    
    return [self viewControllerWithIndex:index];
}

- (OFImageViewController *)viewControllerWithIndex:(int)index
{
    OFImageViewController *imageVC = [[OFImageViewController alloc] init];
    imageVC.delegate = self;
    imageVC.imageURL = [[self.images objectAtIndex:index] picasa_store_source];
    imageVC.index = index;
    
    return imageVC;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        OFImageViewController *imgVC = (OFImageViewController *)[pageViewController.viewControllers lastObject];
        int index = imgVC.index;
        self.pageControl.currentPage = index;
        self.currentVC = index;
    }
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

#pragma mark - Action

- (void)onTapProductImages:(id)sender
{
    BOOL isNavBarHidden = self.navigationController.navigationBarHidden;
    [self.navigationController setNavigationBarHidden:!isNavBarHidden animated:NO];
}

- (void)swipeToBack:(id)sender
{
    if (self.currentVC == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - UIGestureRecognizer delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
