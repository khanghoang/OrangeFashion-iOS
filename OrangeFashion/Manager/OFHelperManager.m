//
//  OFHelperManager.m
//  OrangeFashion
//
//  Created by Khang on 9/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFHelperManager.h"

@implementation OFHelperManager

SINGLETON_MACRO

- (void)getMenuListOnComplete:(void(^)(NSArray *menu))complete orFailure:(void(^)(NSError *error))failure
{
    NSString *path = API_SERVER_HOST;
    NSDictionary *params = @{ @"rquest" : @"getMenu" };
    [[OFHTTPClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //Handle success
        if (complete) {
            complete(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Handle failure
        if (failure) {
            failure(error);
        }
    }];
}

@end
