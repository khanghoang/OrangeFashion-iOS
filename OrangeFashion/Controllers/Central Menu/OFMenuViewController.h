//
//  OFMenuViewController.h
//  OrangeFashion
//
//  Created by Khang on 11/5/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFSidebarMenuTableCell.h"

@interface OFMenuViewController : BaseViewController

@property (strong, nonatomic) UIViewController      * parentVC;
@property (strong, nonatomic) NSMutableArray        * arrMenu;

@end
