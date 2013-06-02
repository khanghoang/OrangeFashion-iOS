//
//  KHViewController.m
//  DemoPageViewController
//
//  Created by Khang on 2/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "KHViewController.h"
#import "KHImageViewController.h"

@interface KHViewController ()

@property (strong, nonatomic) UIPageViewController *pageVC;
@property (strong, nonatomic) NSMutableArray *arr;

@property (assign, nonatomic) int currentIndex;

@end

@implementation KHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.arr = [[NSMutableArray alloc] init];
    
    self.arr = [@[
                 @"1369309546-quynh-anh-02.jpg",
                 @"1369309546-quynh-anh-3.jpg",
                 @"1369309546-quynh-anh-4.jpg",
                 @"1369309547-quynh-anh-9.jpg"
                ] mutableCopy];
    
    self.currentIndex = 0;
    
    self.pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageVC.delegate = self;
    self.pageVC.dataSource = self;
    
//    __weak KHViewController *weakSelf = self;
    
//    [weakSelf.arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    KHImageViewController *imageVC = [[KHImageViewController alloc] init];
    imageVC.label = [self.arr objectAtIndex:self.currentIndex];
    imageVC.imgURL = [self.arr objectAtIndex:self.currentIndex];
    
    [self.pageVC setViewControllers:[NSArray arrayWithObject:imageVC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    [self.pageVC didMoveToParentViewController:self];
    
    self.view.gestureRecognizers = self.pageVC.gestureRecognizers;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    
    if (self.currentIndex == self.arr.count - 1)
        return nil;
    
    KHImageViewController *imageVC = [[KHImageViewController alloc] init];
    imageVC.label = [self.arr objectAtIndex:self.currentIndex + 1];
    imageVC.imgURL = [self.arr objectAtIndex:self.currentIndex + 1];
    
    self.currentIndex += 1;
    
    NSLog(@"After Index = %d", self.currentIndex);
    NSLog(@"After URL = %@", [self.arr objectAtIndex:self.currentIndex]);
    
    return imageVC;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentIndex == 0)
        return nil;
    
    KHImageViewController *imageVC = [[KHImageViewController alloc] init];
    imageVC.label = [self.arr objectAtIndex:self.currentIndex - 1];
    imageVC.imgURL = [self.arr objectAtIndex:self.currentIndex - 1];
    
    self.currentIndex -= 1;
    
    NSLog(@"Before Index = %d", self.currentIndex);
    NSLog(@"Before URL = %@", [self.arr objectAtIndex:self.currentIndex]);
    
    return imageVC;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return self.arr.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end
