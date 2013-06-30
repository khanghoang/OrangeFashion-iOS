//
//  UIColor+Hex.m
//  ColorHexValueExample
//
//  Created by Hu Junfeng on 29/12/12.
//  Copyright (c) 2012 Hu Junfeng. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor*)colorWithHexValue:(NSUInteger)hexValue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16)) / 255.0
                           green:(((hexValue & 0xFF00) >> 8)) / 255.0
                            blue:((hexValue & 0xFF)) / 255.0
                           alpha:alpha];
}

+ (UIColor*)colorWithHexValue:(NSUInteger)hexValue
{
    return [self colorWithHexValue:hexValue alpha:1];
}

+ (UIColor*)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    
    if ([hexString length] != 3 && [hexString length] != 6) {
        return nil;
    }
    
    if ([hexString length] == 3) {
        NSString *r = [hexString substringWithRange:NSMakeRange(0, 1)];
        NSString *g = [hexString substringWithRange:NSMakeRange(1, 1)];
        NSString *b = [hexString substringWithRange:NSMakeRange(2, 1)];
        hexString = [NSString stringWithFormat:@"%@%@%@%@%@%@", r, r, g, g, b, b];
    }
    
    UIColor *color = nil;
    NSUInteger hexValue;
    if ([[NSScanner scannerWithString:hexString] scanHexInt:&hexValue]) {
        color = [self colorWithHexValue:hexValue alpha:alpha];
    }
    return color;
}

+ (UIColor*)colorWithHexString:(NSString *)hexString
{
    return [self colorWithHexString:hexString alpha:1];
}

+ (NSString *)hexStringFromColor:(UIColor *)color
{    
    if (!color) {
        return nil;
    }
    
    if (color == [UIColor whiteColor]) {
        // Special case, as white doesn't fall into the RGB color space
        return @"ffffff";
    }
    
    CGFloat red;
    CGFloat blue;
    CGFloat green;
    CGFloat alpha;
    
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    NSUInteger redDec = (NSUInteger)(red * 255);
    NSUInteger greenDec = (NSUInteger)(green * 255);
    NSUInteger blueDec = (NSUInteger)(blue * 255);
    
    NSString *hexString = [NSString stringWithFormat:@"%02x%02x%02x", redDec, greenDec, blueDec];
    
    return hexString;
}

@end
