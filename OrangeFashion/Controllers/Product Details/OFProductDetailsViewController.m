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

@interface OFProductDetailsViewController ()

@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) UIPageViewController *pageVC;
@property (assign, nonatomic) int currentVC;

@end

@implementation OFProductDetailsViewController

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
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [SVProgressHUD showWithStatus:@"Đang tải hình ảnh cho sản phẩm"];
    
    OFProduct *product = [OFProduct productWithDictionary:@{ @"MaSanPham" : self.productID}];
    
    __block NSMutableArray *arrVC = [[NSMutableArray alloc] init];
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    
    [OFProductImages getImagesForProduct:product successBlock:^(NSInteger statusCode, id obj) {
        
        [SVProgressHUD dismiss];
        
        self.images = obj;
        
        // store it to core-data
        NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];
        [context MR_saveToPersistentStoreWithCompletion:nil];
        
        self.currentVC = 0;

        OFImageViewController *imageVC = [[OFImageViewController alloc] init];
        imageVC.imageURL = [[obj objectAtIndex:0] picasa_store_source];
        DLog(@"imgURL = %@", [[obj objectAtIndex:0] picasa_store_source]);
        
        [arrVC addObject:imageVC];
        
        DLog(@"Array ImagesVC = %@", [arrVC description]);
        
        [self.pageVC setViewControllers:arrVC direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageVC];
        self.pageVC.view.frame = self.view.frame;
        
        [self.view addSubview:self.pageVC.view];
        [self.pageVC didMoveToParentViewController:self];
        
        CGRect pageViewRect = self.view.frame;
        pageViewRect = CGRectInset(pageViewRect, 0, 0);
        self.pageVC.view.frame = pageViewRect;
        
        self.view.gestureRecognizers = self.pageVC.gestureRecognizers;
        
    } failureBlock:^(NSInteger statusCode, id obj2) {
        //handle errors
        [SVProgressHUD showErrorWithStatus:@"Lỗi không tải được hình ảnh, vui lòng thử lại"];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"product_id = %d", self.productID];
//        self.images = [OFProductImages MR_findAllWithPredicate:predicate];
        self.images = [OFProductImages MR_findAll];        
        
        self.currentVC = 0;
        
        OFImageViewController *imageVC = [[OFImageViewController alloc] init];
        imageVC.imageURL = [[self.images objectAtIndex:0] picasa_store_source];
        DLog(@"imgURL = %@", [[self.images objectAtIndex:0] picasa_store_source]);
        
        [arrVC addObject:imageVC];
        
        DLog(@"Array ImagesVC = %@", [arrVC description]);
        
        [self.pageVC setViewControllers:arrVC direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageVC];
        self.pageVC.view.frame = self.view.frame;
        
        [self.view addSubview:self.pageVC.view];
        [self.pageVC didMoveToParentViewController:self];
        
        CGRect pageViewRect = self.view.frame;
        pageViewRect = CGRectInset(pageViewRect, 0, 0);
        self.pageVC.view.frame = pageViewRect;
        
        self.view.gestureRecognizers = self.pageVC.gestureRecognizers;
        
    }];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.currentVC == self.images.count - 1)
        return nil;
    
    OFImageViewController *imageVC = [[OFImageViewController alloc] init];
    imageVC.imageURL = [[self.images objectAtIndex:self.currentVC + 1] picasa_store_source];
    
    self.currentVC++;
    
    return imageVC;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    if (self.currentVC == 0)
        return nil;
    
    OFImageViewController *imageVC = [[OFImageViewController alloc] init];
    imageVC.imageURL = [[self.images objectAtIndex:self.currentVC - 1] picasa_store_source];
    
    self.currentVC--;
    
    return imageVC;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.images.count;
}
- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
