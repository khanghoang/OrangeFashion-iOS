//
//  OFCollectionViewCell.h
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OFCollectionViewCellDelegate <NSObject>

- (void)onTapCollectionViewCell:(NSNumber *)productID;

@end

@interface OFCollectionViewCell : PSUICollectionViewCell

@property (strong, nonatomic) id<OFCollectionViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel                * lblProductName;
@property (weak, nonatomic) IBOutlet UIImageView            * imgProductImage;

- (void)configCellWithProduct:(OFProduct *)product;

@end
