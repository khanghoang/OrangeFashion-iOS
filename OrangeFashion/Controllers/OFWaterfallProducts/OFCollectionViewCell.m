//
//  OFCollectionViewCell.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFCollectionViewCell.h"

@interface OFCollectionViewCell()

@property (strong, nonatomic) OFProduct                     * product;
@property (weak, nonatomic) IBOutlet UIView                 * viewNameWrapper;

@property (strong, nonatomic) NSOperationQueue              *queue;

@end

@implementation OFCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OFCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHexString:@"#d4d2d3"].CGColor;
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGuesture];
        self.queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)configCellWithProduct:(OFProduct *)product
{
    self.product = product;
    
    NSString *imgUrl = [NSString stringWithFormat:@"http://orangefashion.vn/store/%@/%@_small.jpg", product.product_id, product.product_id];
    __weak OFCollectionViewCell *weakCell = self;
    weakCell.imgProductImage.alpha = 0;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imgUrl] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [weakCell.imgProductImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        [UIView animateWithDuration:0.3 animations:^{
            weakCell.imgProductImage.alpha = 1;
        }];
    } failure:nil];
    
    CGRect lblFrame = self.lblProductName.frame;
    
    self.lblProductName.text = product.name;
    [self.lblProductName sizeToFitKeepWidth];
    
    CGRect lblNewFrame = self.lblProductName.frame;
    CGFloat bonusHeight = lblNewFrame.size.height - lblFrame.size.height;
    
    CGRect wrapFrame = self.viewNameWrapper.frame;
    wrapFrame.origin.y -= bonusHeight;
    wrapFrame.size.height += bonusHeight;
    self.viewNameWrapper.frame = wrapFrame;
    
    CGRect imgProductFrame = self.imgProductImage.frame;
    imgProductFrame.size.height -= bonusHeight;
    self.imgProductImage.frame = imgProductFrame;
}

- (void)onTap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onTapCollectionViewCell:)]) {
        [self.delegate performSelector:@selector(onTapCollectionViewCell:) withObject:self.product.product_id];
    }
}

@end
