//
//  UIAlertView+Additions.h
//
//  Created by Jesper Särnesjö on 2010-05-31.
//  Added method accepting variadic args by Jesse Armand.
//  
//  Copyright 2010 Cartomapic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Additions)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;

+ (void)showRetryAlertWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id<UIAlertViewDelegate>)delegate;

+ (void)showAlertWithTitle:(NSString *)title 
                   message:(NSString *)message 
                       tag:(NSInteger)tag
                  delegate:(id<UIAlertViewDelegate>)delegate 
              buttonTitles:(NSString *)firstTitle, ...;

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message 
                  delegate:(id<UIAlertViewDelegate>)delegate 
              buttonTitles:(NSString *)firstTitle, ...;

- (void)setAccessibilityLabelWithTitle:(NSString *)title message:(NSString *)message;

@end
