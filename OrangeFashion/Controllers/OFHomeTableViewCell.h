//
//  OFHomeTableViewCell.h
//  OrangeFashion
//
//  Created by Khang on 14/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFSidebarMenuTableCell.h"

#define HOME_MENU_BACKGROUND            @"background_url"
#define HOME_MENU_TITLE                 @"name"

@protocol OFHomeTableViewCellDelegate <NSObject>

- (void)onTapHomeTableViewCell:(NSDictionary *)data;

@end

@interface OFHomeTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString                          * title;
@property (assign, nonatomic) NSNumber                          * categoryID;
@property (assign, nonatomic) id<OFHomeTableViewCellDelegate>     delegate;
- (void)configWithData:(id)data;

@end
