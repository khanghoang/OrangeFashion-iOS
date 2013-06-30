//
//  UIImage+Additions.m
//  Aelo
//
//  Created by Xu Xiaojiang on 30/8/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "UIImage+Additions.h"
#import <objc/runtime.h>

@implementation UIImage (Additions)

+ (void)load {
  if  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
       ([UIScreen mainScreen].bounds.size.height > 480.0f)) {
    method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                   class_getClassMethod(self, @selector(imageNamedH568:)));
  }
}

+ (UIImage *)imageNamedH568:(NSString *)imageName {
  
  NSMutableString *imageNameMutable = [imageName mutableCopy];
  
  //Delete png extension
  NSRange extension = [imageName rangeOfString:@".png" options:NSBackwardsSearch | NSAnchoredSearch];
  if (extension.location != NSNotFound) {
    [imageNameMutable deleteCharactersInRange:extension];
  }
  
  //Look for @2x to introduce -568h string
  NSRange retinaAtSymbol = [imageName rangeOfString:@"@2x"];
  if (retinaAtSymbol.location != NSNotFound) {
    [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
  } else {
    [imageNameMutable appendString:@"-568h@2x"];
  }
  
  //Check if the image exists and load the new 568 if so or the original name if not
  NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
  if (imagePath) {
    //Remove the @2x to load with the correct scale 2.0
    [imageNameMutable replaceOccurrencesOfString:@"@2x" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [imageNameMutable length])];
    return [UIImage imageNamedH568:imageNameMutable];
  } else {
    return [UIImage imageNamedH568:imageName];
  }
}



- (UIImage *)scaleToSize:(CGSize)size
{
  // Create a bitmap graphics context
  // This will also set it as the current context
  UIGraphicsBeginImageContext(size);
  
  // Draw the scaled image in the current context
  [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
  
  // Create a new image from current context
  UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
  
  // Pop the current context from the stack
  UIGraphicsEndImageContext();
  
  // Return our new scaled image
  return scaledImage;
}

- (UIImage *)crop:(CGRect)rect
{  
  rect = CGRectMake(rect.origin.x*self.scale,
                    rect.origin.y*self.scale,
                    rect.size.width*self.scale,
                    rect.size.height*self.scale);
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef
                                        scale:self.scale
                                  orientation:self.imageOrientation];
  CGImageRelease(imageRef);
  return result;
}

- (UIImage *)squareCrop
{
  CGFloat size = MIN(self.size.width, self.size.height);
  CGRect rect = CGRectMake(self.size.width/2 - size/2,
                           self.size.height/2 - size/2,
                           size, size);
  
  rect = CGRectMake(rect.origin.x*self.scale,
                    rect.origin.y*self.scale,
                    rect.size.width*self.scale,
                    rect.size.height*self.scale);
  
  CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
  UIImage *result = [UIImage imageWithCGImage:imageRef
                                        scale:self.scale
                                  orientation:self.imageOrientation];
  CGImageRelease(imageRef);
  return result;
}

- (UIImage *)resizableImageWithStandardInsets
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5.0"))
    {
        UIEdgeInsets edgeInset = UIEdgeInsetsMake(self.size.height/2, self.size.width/2, self.size.height/2-1, self.size.width/2-1);
        return [self resizableImageWithCapInsets:edgeInset];
    }
    
    //Support for 4.3
    return [self stretchableImageWithLeftCapWidth:self.size.width/2-1 topCapHeight:self.size.height/2-1];
}
@end
