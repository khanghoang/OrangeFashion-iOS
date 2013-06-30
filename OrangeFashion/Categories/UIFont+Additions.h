//
//  UIFont+Additions.h
//  TemplateProject
//
//  Created by Torin on 17/4/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Additions)

+ (UIFont *)appFontOfSize:(CGFloat)fontSize;
+ (UIFont *)boldAppFontOfSize:(CGFloat)fontSize;

// Helvetica Neue LT Std 45 Light
+ (UIFont *)lightAppFontOfSize:(CGFloat)fontSize;

// Helvetica Neue LT Std 65 Medium
+ (UIFont *)mediumAppFontOfSize:(CGFloat)fontSize;

// Helvetica Neue LT Std 27 Ultra Light Condensed
+ (UIFont *)ultraLightCondensedAppFontOfSize:(CGFloat)fontSize;

// Helvetica Neue LT Std 47 Light Condensed
+ (UIFont *)lightCondensedAppFontOfSize:(CGFloat)fontSize;

// Helvetica Neue LT Std 57 Condensed
+ (UIFont *)condensedAppFontOfSize:(CGFloat)fontSize;

// Helvetica Neue LT Std 77 Bold Condensed
+ (UIFont *)boldCondensedAppFontOfSize:(CGFloat)fontSize;

// Helvetica Neue LT Std 55 Roman
+ (UIFont *)romanAppFontOfSize:(CGFloat)fontSize;

- (UIFont *)mediumAppFontOfSameFontSize;
- (UIFont *)ultraLightCondensedAppFontOfSameFontSize;
- (UIFont *)lightCondensedAppFontOfSameFontSize;
- (UIFont *)condensedAppFontOfSameFontSize;
- (UIFont *)boldCondensedAppFontOfSameFontSize;
- (UIFont *)romanAppFontOfSameFontSize;

- (UIFont *)systemFontOfSameFontSize;
- (UIFont *)boldSystemFontOfSameFontSize;
- (UIFont *)appFontOfSameFontSize;
- (UIFont *)boldAppFontOfSameFontSize;

@end
