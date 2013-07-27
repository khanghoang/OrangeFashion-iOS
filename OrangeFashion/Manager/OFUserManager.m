//
//  OFUserManager.m
//  OrangeFashion
//
//  Created by Khang on 27/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFUserManager.h"

@implementation OFUserManager

SINGLETON_MACRO

- (BOOL)isLoggedUser
{
    if (self.loggedUser)
        return YES;
    
    return NO;
}

- (void)setLoggedUser:(id<FBGraphUser>)loggedUser
{
    _loggedUser = loggedUser;
}

- (void)logOut
{
    self.loggedUser = nil;
}

@end
