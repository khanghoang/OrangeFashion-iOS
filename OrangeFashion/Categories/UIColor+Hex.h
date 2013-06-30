//
//  UIColor+Hex.h
//  ColorHexValueExample
//
//  Created by Hu Junfeng on 29/12/12.
//  Copyright (c) 2012 Hu Junfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 * Creates and returns a color object using the specified opacity and the hex value of RGB components
 *
 * @param hexValue The hex value of RGB components of the color object
 * @param alpha The opacity value of the color object
 */
+ (UIColor*)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha;

/**
 * Creates and returns a color object using 100% opacity and the hex value of RGB components. This method calls colorWithHexValue:alpha using the specified hex value and alpha value of 1.
 *
 * @param hexValue The hex value of RGB components of the color object
 */
+ (UIColor*)colorWithHexValue:(NSUInteger)hexValue;

/**
 * Creates and returns a color object using the specified opacity and the string that represents the hex value of RGB components
 *
 * The string can be any of the three formats: FFFFFF, #FFFFFF, FFF. If the string is not a valid format of hex value, nil object is returned.
 *
 * @param hexValue The string that represents the hex value of RGB components of the color object
 * @param alpha The opacity value of the color object
 */
+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

/**
 * Creates and returns a color object using 100% opacity and the string that represents the hex value of RGB components. This method calls colorWithHexString:alpha using the specified hex value and alpha value of 1.
 *
 * @param hexValue The string that represents the hex value of RGB components of the color object
 */
+ (UIColor*)colorWithHexString:(NSString *)hexString;

+ (NSString *)hexStringFromColor:(UIColor *)color;

@end
