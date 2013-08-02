//
//  OFBookmarkSectionHeader.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFBookmarkSectionHeader.h"

@interface OFBookmarkSectionHeader()

@property (weak, nonatomic) IBOutlet UILabel *lblNumberOfProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblInCart;


@end

@implementation OFBookmarkSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OFBookmarkSectionHeader" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)changeNumberOfBookmarkProduct:(NSInteger)numberProducts
{
    self.lblNumberOfProducts.text = [NSString stringWithFormat:@"%d sản phẩm", numberProducts];
    [self.lblNumberOfProducts sizeToFitKeepHeight];

    CGRect frame = self.lblInCart.frame;
    frame.origin.x = CGRectGetMaxX(self.lblNumberOfProducts.frame) + 5;
    self.lblInCart.frame = frame;
}

+ (CGFloat)getHeight
{
    return 35;
}

@end
