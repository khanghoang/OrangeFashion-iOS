//
//  NSString+Validation.m
//  Aurora
//
//  Created by Torin on 23/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import "NSString+Validation.h"

@implementation NSString (Validation)

- (BOOL)isEmail
{  
  NSString *regularExpressionString = @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
  @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
  @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
  @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
  @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
  @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
  @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
  
  NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpressionString];
  
  return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isNumber
{
  NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
  NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
  return r.location == NSNotFound;
}

- (BOOL)isValidName
{
  if (self.length < 3)
    return NO;
  
  NSString *regularExpressionString = @"^[a-zA-Z0-9-_' ]+$";    //alphanumberic, dash, underscore, space, apos
  
  NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpressionString];
  
  return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isPhoneNumber
{
  if (self.length < 8)
    return NO;
  
  NSString *regularExpressionString = @"^[0-9-+() ]+$";
  
  NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularExpressionString];
  
  return [regExPredicate evaluateWithObject:self];
}

@end
