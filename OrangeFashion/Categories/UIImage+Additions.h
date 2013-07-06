//
//  UIImage+Additions.h
//  Aelo
//
//  Created by Xu Xiaojiang on 30/8/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

-(UIImage *)scaleToSize:(CGSize)size;
-(UIImage *)crop:(CGRect)rect;
-(UIImage *)squareCrop;
-(UIImage *)resizableImageWithStandardInsets;
-(UIImage *)resizableImageWithStandardInsetsTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
