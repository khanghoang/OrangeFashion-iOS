//
//  OFSidebarMenuTableCell.h
//  OrangeFashion
//
//  Created by Khang on 6/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MENU_TITLE                      @"name"
#define CATEGORY_ID                     @"id"

@interface OFSidebarMenuTableCell : UITableViewCell

- (void)configWithData:(id)data;

@end
