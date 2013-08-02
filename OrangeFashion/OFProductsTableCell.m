//
//  OFProductsTableCell.m
//  OrangeFashion
//
//  Created by Khang on 6/4/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFProductsTableCell.h"

@interface OFProductsTableCell()

@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UILabel *productPrice;
@property (weak, nonatomic) IBOutlet UILabel *productDetails;

@property (weak, nonatomic) IBOutlet UIImageView *productCoverImage;

@end

@implementation OFProductsTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self = (OFProductsTableCell *)[[[NSBundle mainBundle] loadNibNamed:@"OFProductsTableCell" owner:self options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma marks Custom Product Cell
- (void)customProductCellWithProduct:(OFProduct *)aProduct
{
    self.productName.text = aProduct.name;
    self.productPrice.text = aProduct.price;
    
    self.productDetails.text = [NSString stringWithFormat:@"Màu: %@ \nChất liệu: %@", aProduct.colors, aProduct.material];
    [self.productDetails sizeToFitKeepWidth];
    
    NSString *imgUrl = [NSString stringWithFormat:@"http://orangefashion.vn/store/%@/%@_small.jpg", aProduct.product_id, aProduct.product_id];
    
    [self.productCoverImage setImageWithURL:[[NSURL alloc] initWithString:imgUrl]];
    
}

@end
