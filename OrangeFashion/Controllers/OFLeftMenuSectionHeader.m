//
//  OFLeftMenuSectionHeader.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFLeftMenuSectionHeader.h"

@interface OFLeftMenuSectionHeader()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation OFLeftMenuSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OFLeftMenuSectionHeader" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)configTitleNameWithString:(NSString *)title
{
    self.lblTitle.text = title;
}

+ (CGFloat)getHeight
{
    return 25;
}

@end
