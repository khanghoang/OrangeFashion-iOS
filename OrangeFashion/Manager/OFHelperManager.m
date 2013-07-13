//
//  OFHelperManager.m
//  OrangeFashion
//
//  Created by Khang on 9/7/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#define MENU_LIST_USERDEFAULT       @"menu_list"

#import "OFHelperManager.h"

@implementation OFHelperManager

SINGLETON_MACRO

- (void)getMenuListOnComplete:(void(^)(NSArray *menu))complete orFailure:(void(^)(NSError *error))failure
{
    NSString *path = API_SERVER_HOST;
    NSDictionary *params = @{ @"rquest" : @"getMenu" };
    [[OFHTTPClient sharedClient] getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self storeMenuList:responseObject];
        NSArray *menuList = [self getMenuList];
        
        //Handle success
        if (complete) {
            complete(menuList);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Handle failure
        
        NSArray *menuList = [self getMenuList];
        if (complete) {
            complete(menuList);
            return;
        }
        
        if (failure) {
            failure(error);            
        }
        
    }];
}

- (void)storeMenuList:(id)menuList
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:menuList forKey:MENU_LIST_USERDEFAULT];
    [userDefault synchronize];
}

- (NSArray *)getMenuList
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:MENU_LIST_USERDEFAULT];    
}

@end
