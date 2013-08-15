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
@property (strong, nonatomic) UIImage                       * image;

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
    }
    return self;
}

- (void)configCellWithProduct:(OFProduct *)product
{
    self.product = product;
    
    NSString *imgUrl = [NSString stringWithFormat:@"http://orangefashion.vn/store/%@/%@_small.jpg", product.product_id, product.product_id];
    __weak OFCollectionViewCell *weakCell = self;
    
    weakCell.imgProductImage.alpha = 0;
    
    self.imgProductImage.image = nil;
  
    [self.imgProductImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
      weakCell.image = image;
      [weakCell.imgProductImage setImage:image];
      [UIView animateWithDuration:0.3 animations:^{
        weakCell.imgProductImage.alpha = 1;
      }];
    }];
  
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

- (void)drawImage
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = (id) self.image.CGImage;
    
    CGRect imageFrame = CGRectMake(0, 0, self.image.size.width, self.image.size.height) ;
    
    CGFloat ratio = self.image.size.height / self.image.size.width;
    imageFrame.size.height = self.layer.bounds.size.height;
    imageFrame.size.width = imageFrame.size.height / ratio;
    imageFrame.origin.x = - (imageFrame.size.width - self.layer.frame.size.width) / 2;
    
    imageLayer.frame = imageFrame;
    [self.layer addSublayer:imageLayer];
}

@end
