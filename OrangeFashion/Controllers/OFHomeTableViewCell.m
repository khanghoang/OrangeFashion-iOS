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

@end

@implementation OFHomeTableViewCell

- (void)configWithData:(id)data
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self addGestureRecognizer:tap];
    NSString *urlBg = data[HOME_MENU_BACKGROUND];
    [self.imgBackground setImageWithURL:[NSURL URLWithString:urlBg] placeholderImage:nil];
}

- (void)onTap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onTapHomeTableViewCell:)]) {
        NSDictionary *data = @{ MENU_TITLE: self.title,
                                CATEGORY_ID : self.categoryID};
        [self.delegate performSelector:@selector(onTapHomeTableViewCell:) withObject:data];
    }
}

@end
