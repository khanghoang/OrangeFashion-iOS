//
//  OFProductDetailsViewController.h
//  OrangeFashion
//
//  Created by Khang on 1/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFProductDetailsViewController : BaseViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) NSNumber *productID;

@end
