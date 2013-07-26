//
//  OFBookmarkTableCell.h
//  OrangeFashion
//
//  Created by Khang on 6/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OFBookmarkTableCellDelegate <NSObject>

- (void)onLongPress:(id)sender;

@end

#define PRODUCT_NAME                        @"name"
#define PRODUCT_ID                          @"product_id"

@interface OFBookmarkTableCell : UITableViewCell

@property (assign, nonatomic) id<OFBookmarkTableCellDelegate> delegate;
- (void)configWithData:(id)data;

@end
