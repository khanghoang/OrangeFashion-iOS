//
//  OFHomeTableViewCell.m
//  OrangeFashion
//
//  Created by Khang on 14/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#define HOME_MENU_BACKGROUND            @"background_url"
#define HOME_MENU_TITLE                 @"name"

#import "OFHomeTableViewCell.h"

@interface OFHomeTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView    * imgBackground;
@property (weak, nonatomic) IBOutlet UILabel        * lblCategoryName;


@end

@implementation OFHomeTableViewCell

- (void)configWithData:(id)data
{
    NSString *urlBg = data[HOME_MENU_BACKGROUND];
    NSString *title = data[HOME_MENU_TITLE];
    
    [self.imgBackground setImageWithURL:[NSURL URLWithString:urlBg] placeholderImage:nil];
    self.lblCategoryName.text = title;
}

@end
