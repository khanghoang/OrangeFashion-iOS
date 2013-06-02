//
//  KHImageViewController.h
//  DemoPageViewController
//
//  Created by Khang on 2/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KHImageViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lb;
@property (strong, nonatomic) NSString *label;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) NSString *imgURL;

@end
