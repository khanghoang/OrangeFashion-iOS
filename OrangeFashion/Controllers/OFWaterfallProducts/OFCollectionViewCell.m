//
//  OFCollectionViewCell.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFCollectionViewCell.h"

@interface OFCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView            * imgProductImage;
@property (weak, nonatomic) IBOutlet UILabel                * lblProductName;
@property (strong, nonatomic) OFProduct                     * product;

@end

@implementation OFCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OFCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
        
        UITapGestureRecognizer *tapGuesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapGuesture];
    }
    return self;
}

- (void)configCellWithProduct:(OFProduct *)product
{
    self.product = product;
    NSString *imgUrl = [NSString stringWithFormat:@"http://orangefashion.vn/store/%@/%@_small.jpg", product.product_id, product.product_id];
    [self.imgProductImage setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:nil];    
    self.lblProductName.text = product.name;
}

- (void)onTap:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onTapCollectionViewCell:)]) {
        [self.delegate performSelector:@selector(onTapCollectionViewCell:) withObject:self.product.product_id];
    }
}

@end
