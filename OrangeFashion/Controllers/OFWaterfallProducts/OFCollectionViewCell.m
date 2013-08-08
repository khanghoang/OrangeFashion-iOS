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
    
    __weak OFCollectionViewCell *weakSelf = self;
    weakSelf.imgProductImage.image = nil;
    
    double delayInSeconds = 0.3;
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", nil);;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, myQueue, ^(void){
        if(weakSelf){
            weakSelf.imgProductImage.alpha = 0;
            [weakSelf.imgProductImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.imgProductImage.alpha = 1;
            }];
        }
    });
    
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
