//
//  NSObject+OpenUDID_Keychain.h
//  Aurora
//
//  Created by Torin Nguyen on 9/5/12.
//  Copyright (c) 2012 torin.nguyen@MyCompany.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpenUDID.h"

@interface OpenUDID (Keychain)

// OpenUDID value, with additional keychain storage
+ (NSString*) valueWithKeychain;

+ (NSString*)getKeychainValue;

@end
