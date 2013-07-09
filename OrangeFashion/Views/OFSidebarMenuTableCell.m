//
//  OFSidebarMenuTableCell.m
//  OrangeFashion
//
//  Created by Khang on 6/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFSidebarMenuTableCell.h"

@interface OFSidebarMenuTableCell()

@property (weak, nonatomic) IBOutlet UILabel        * menuTitle;
@property (weak, nonatomic) IBOutlet UIImageView    * menuIcon;

@end

@implementation OFSidebarMenuTableCell

- (void)configWithData:(id)data
{
    [self customCell];
    self.menuTitle.text = [data objectForKey:MENU_TITLE];
}

- (void)customCell
{
    self.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SidebarMenuTableCellBg"] resizableImageWithStandardInsetsTop:0 right:0 bottom:0 left:0]];
    
    // Dark line
    UIView *btmLine = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 320, 1)];
    btmLine.backgroundColor = [UIColor colorWithHexValue:0x000000];
    [self addSubview:btmLine];
    
    // Light line
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 44, 320, 1)];
    topLine.backgroundColor = [UIColor colorWithHexValue:0x4d4b49];
    [self addSubview:topLine];
}

#pragma mark - Helpers

+ (CGFloat)getHeight
{
    return 45;
}

@end
