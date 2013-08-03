//
//  OFCollectionViewCell.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFCollectionViewCell.h"

@interface OFCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgProductImage;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;

@end

@implementation OFCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OFCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

- (void)configCellWithProduct:(OFProduct *)product
{
    [OFProductImages getImagesForProduct:product successBlock:^(NSInteger statusCode, id obj) {
        OFProductImages *image = [obj objectAtIndex:0];
        [self.imgProductImage setImageWithURL:[NSURL URLWithString:image.picasa_store_source] placeholderImage:nil];
    } failureBlock:nil];
    self.lblProductName.text = product.name;
}

@end
