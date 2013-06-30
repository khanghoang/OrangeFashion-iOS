//
//  NSString+Validation.h
//  Aurora
//
//  Created by Torin on 23/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL)isEmail;
- (BOOL)isNumber;
- (BOOL)isValidName;
- (BOOL)isPhoneNumber;

@end
