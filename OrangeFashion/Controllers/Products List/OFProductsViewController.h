//
//  OFProductsViewController.h
//  OrangeFashion
//
//  Created by Khang on 5/4/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFProductsViewController : BaseViewController

@property (assign, nonatomic) NSInteger                     category_id;
@property (weak, nonatomic) IBOutlet UITableView          * tableProducts;

@end
