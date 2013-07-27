//
//  OFUserManager.h
//  OrangeFashion
//
//  Created by Khang on 27/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "BaseManager.h"

@interface OFUserManager : BaseManager

@property (assign, nonatomic) id<FBGraphUser>           loggedUser;

- (void)setLoggedUser:(id<FBGraphUser>)loggedUser;
- (void)logOut;
- (BOOL)isLoggedUser;

@end
