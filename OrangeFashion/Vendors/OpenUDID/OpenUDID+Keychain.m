//
//  NSObject+OpenUDID_Keychain.m
//  Aurora
//
//  Created by Torin Nguyen on 9/5/12.
//  Copyright (c) 2012 torin.nguyen@MyCompany.com. All rights reserved.
//

#import "OpenUDID+Keychain.h"
#import "SFHFKeychainUtils.h"
#import <Security/Security.h>

#define kUUID @"UUID"

@implementation OpenUDID (Keychain)

#define KEYCHAIN_STRING_PRODUCTION          @"KeychainString"


//
// MD5 hashed of value, with additional keychain storage
//
+ (NSString*) valueWithKeychain
{
  NSError *error = nil;
  NSString *valueInKeychain = [OpenUDID getKeychainValue];
  
  //Return value from keychain if it is there
  if (valueInKeychain != nil && [valueInKeychain length] == 40)
    return valueInKeychain;
  
  //Always generate new one with old keychain
  NSString *newValue = [OpenUDID value];
  [SFHFKeychainUtils storeUsername:KEYCHAIN_STRING_PRODUCTION
                       andPassword:newValue
                    forServiceName:KEYCHAIN_STRING_PRODUCTION
                    updateExisting:TRUE 
                             error:&error];
  
  DLog(@"OpenUDID value is not available in keychain. Obtain from OpenUDID directly: %@", newValue);
  return newValue;
}

+ (NSString*)getKeychainValue {

  NSError *error = nil;
  NSString *valueInKeychain = [SFHFKeychainUtils getPasswordForUsername:KEYCHAIN_STRING_PRODUCTION
                                                         andServiceName:KEYCHAIN_STRING_PRODUCTION
                                                                  error:&error];
  if (error != nil)
    return nil;
  
  return valueInKeychain;   //can be nil
}

@end
