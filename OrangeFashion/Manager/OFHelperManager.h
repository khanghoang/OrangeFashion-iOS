//
//  OFHelperManager.h
//  OrangeFashion
//
//  Created by Khang on 9/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "BaseManager.h"

@interface OFHelperManager : BaseManager

- (void)getMenuListOnComplete:(void(^)(NSArray *menu))complete orFailure:(void(^)(NSError *error))failure;

@end
