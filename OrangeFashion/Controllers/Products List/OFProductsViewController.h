//
//  OFProductsViewController.h
//  OrangeFashion
//
//  Created by Khang on 5/4/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString* const DEFAULT_NAVIGATION_TITLE = @"Danh sách sản phẩm";

@interface OFProductsViewController : BaseViewController

@property (strong, nonatomic) NSString                    * lblTitle;
@property (assign, nonatomic) NSInteger                     category_id;
@property (weak, nonatomic) IBOutlet UITableView          * tableProducts;

@end
