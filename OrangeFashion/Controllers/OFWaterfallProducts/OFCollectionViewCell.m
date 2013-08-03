//
//  OFCollectionViewCell.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFCollectionViewCell.h"

@implementation OFCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"OFCollectionViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return self;
}

@end
