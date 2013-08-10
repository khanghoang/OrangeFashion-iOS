//
//  OFBookmarkTableViewCell.h
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OFBookmarkTableViewCellDelegate <NSObject>

- (void)onLongPress:(id)sender;

@end

@interface OFBookmarkTableViewCell : UITableViewCell

@property (assign, nonatomic) id<OFBookmarkTableViewCellDelegate> delegate;

- (void)configWithProduct:(OFProduct *)product andNumber:(NSInteger)number;
+ (CGFloat)getHeight;

@end
