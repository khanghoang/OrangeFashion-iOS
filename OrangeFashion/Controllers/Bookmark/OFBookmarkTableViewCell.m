//
//  OFBookmarkTableViewCell.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFBookmarkTableViewCell.h"

@interface OFBookmarkTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView    * imgProductWrapImage;
@property (weak, nonatomic) IBOutlet UIImageView    * imgProductImage;
@property (weak, nonatomic) IBOutlet UILabel        * lblProductName;
@property (weak, nonatomic) IBOutlet UILabel        * lblProductPrice;

@property (strong, nonatomic) OFProduct             * product;
@property (assign, nonatomic) NSInteger               number;
@property (weak, nonatomic) IBOutlet UILabel        * lblNumber;

@end

@implementation OFBookmarkTableViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OFBookmarkTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)configWithProduct:(OFProduct *)product andNumber:(NSInteger)number
{
    self.product = product;
    self.imgProductWrapImage.layer.borderWidth = 1;
    self.imgProductWrapImage.layer.borderColor = [UIColor colorWithHexString:@"beb7a9"].CGColor;
    
    NSString *imgUrl = [NSString stringWithFormat:@"http://orangefashion.vn/store/%@/%@_small.jpg", product.product_id, product.product_id];
    [self.imgProductImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
    
    self.lblProductName.text = product.name;
    [self.lblProductName sizeToFitKeepWidth];
    
    self.lblProductPrice.text = product.price;
    CGRect priceFrame = self.lblProductPrice.frame;
    priceFrame.origin.y = CGRectGetMaxY(self.lblProductName.frame);
    self.lblProductPrice.frame = priceFrame;
    
    self.lblNumber.text = [NSString stringWithFormat:@"x %d", number];
    
    // Add delete action
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDeleteBookmark:)];
    [self addGestureRecognizer:longPress];
}

+ (CGFloat)getHeight
{
    return 80;
}

#pragma mark - Actions

- (void)longPressToDeleteBookmark:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onLongPress:)]) {
        [self.delegate onLongPress:@{   @"guesture": sender,
                                        @"productId": self.product.product_id}];
    }    
}


@end
