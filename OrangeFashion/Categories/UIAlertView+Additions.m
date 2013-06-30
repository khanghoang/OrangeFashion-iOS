//
//  UIAlertView+Additions.m
//
//  Created by Jesper Särnesjö on 2010-05-31.
//  Added method accepting variadic args by Jesse Armand.
//
//  Copyright 2010 Cartomapic. All rights reserved.
//

#import "UIAlertView+Additions.h"
#import <stdarg.h>

@implementation UIAlertView (Additions)

+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
  
  [alertView setAccessibilityLabelWithTitle:title message:message];
  [alertView show];
}

+ (void)showRetryAlertWithTitle:(NSString *)title message:(NSString *)message tag:(NSInteger)tag delegate:(id<UIAlertViewDelegate>)delegate
{
  NSString *buttonTitle = @"Retry";
  if (!delegate)
    buttonTitle = @"Ok";
  
  [[self class] showAlertWithTitle:title message:message tag:tag delegate:delegate buttonTitles:NSLocalizedString(buttonTitle, nil), nil];
}

+ (void)showAlertWithTitle:(NSString *)title 
                   message:(NSString *)message 
                       tag:(NSInteger)tag
                  delegate:(id<UIAlertViewDelegate>)delegate 
              buttonTitles:(NSString *)firstTitle, ...
{
  NSString *eachTitle = nil;
  va_list titleList;
  if ([firstTitle length] > 0)                      
  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:delegate
                                              cancelButtonTitle:firstTitle
                                              otherButtonTitles:nil];
    [alertView setAccessibilityLabelWithTitle:title message:message];
    alertView.tag = tag;
    
    va_start(titleList, firstTitle);
    while ( (eachTitle = va_arg(titleList, NSString *)) ) 
      [alertView addButtonWithTitle:eachTitle];               
    va_end(titleList);
    
    [alertView show];
  }
}

+ (void)showAlertWithTitle:(NSString *)title 
                   message:(NSString *)message 
                  delegate:(id<UIAlertViewDelegate>)delegate 
              buttonTitles:(NSString *)firstTitle, ...
{
  NSString *eachTitle = nil;
  va_list titleList;
  if ([firstTitle length] > 0)                      
  {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:delegate
                                               cancelButtonTitle:firstTitle
                                               otherButtonTitles:nil];

    [alertView setAccessibilityLabelWithTitle:title message:message];
    
    va_start(titleList, firstTitle);
    while ( (eachTitle = va_arg(titleList, NSString *)) ) 
      [alertView addButtonWithTitle:eachTitle];               
    va_end(titleList);
    
    [alertView show];
  }
}

- (void)setAccessibilityLabelWithTitle:(NSString *)title message:(NSString *)message
{
  self.isAccessibilityElement = YES;
  if ([title length] > 0)
    [self setAccessibilityLabel:title];
  else if ([message length] > 0)
    [self setAccessibilityLabel:message];
  else 
    [self setAccessibilityLabel:@"Alert Pop Up"];
}

@end
