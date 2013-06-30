// AFUrbanAirshipClient.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AFUrbanAirshipClient.h"

static NSString * const kAFUrbanAirshipAPIBaseURLString = @"https://go.urbanairship.com/api/";

static NSString * AFNormalizedDeviceTokenStringWithDeviceToken(id deviceToken) {
    return [[[[deviceToken description] uppercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@implementation AFUrbanAirshipClient

- (id)initWithApplicationKey:(NSString *)key
           applicationSecret:(NSString *)secret
{
    self = [self initWithBaseURL:[NSURL URLWithString:kAFUrbanAirshipAPIBaseURLString]];
    if (!self) {
        return nil;
    }
    
    self.parameterEncoding = AFJSONParameterEncoding;
    
    [self setAuthorizationHeaderWithUsername:key password:secret];
    
    return self;
}

- (void)registerDeviceToken:(NSString *)deviceToken
                  withAlias:(NSString *)alias
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableSet *mutableTags = [NSMutableSet set];
    [mutableTags addObject:[NSString stringWithFormat:@"v%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
    [mutableTags addObject:[[UIDevice currentDevice] model]];
    [mutableTags addObject:[NSString stringWithFormat:@"%@ %@", [[UIDevice currentDevice] systemName], [[UIDevice currentDevice] systemVersion]]];
    [mutableTags addObject:[[NSLocale currentLocale] localeIdentifier]];
    
    [self registerDeviceToken:deviceToken withAlias:alias badge:0 tags:mutableTags timezone:[NSTimeZone localTimeZone] quietTimeStart:nil quietTimeEnd:nil success:success failure:failure];
}

- (void)registerDeviceToken:(NSString *)deviceToken
                  withAlias:(NSString *)alias
                      badge:(NSUInteger)badge
                       tags:(NSSet *)tags
                   timezone:(NSTimeZone *)timeZone
             quietTimeStart:(NSDateComponents *)quietTimeStartComponents
               quietTimeEnd:(NSDateComponents *)quietTimeEndComponents
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure
{
    NSMutableDictionary *mutablePayload = [NSMutableDictionary dictionary];
    if (alias) {
        [mutablePayload setValue:alias forKey:@"alias"];
    }
    
    if (badge) {
        [mutablePayload setValue:[[NSNumber numberWithUnsignedInteger:badge] stringValue] forKey:@"badge"];
    }
    
    if (tags && [tags count] > 0) {
        [mutablePayload setValue:[tags allObjects] forKey:@"tags"];
    }
    
    if (quietTimeStartComponents && quietTimeEndComponents) {
        NSMutableDictionary *mutableQuietTimePayload = [NSMutableDictionary dictionary];
        [mutableQuietTimePayload setValue:[NSString stringWithFormat:@"%02d:%02d", [quietTimeStartComponents hour], [quietTimeStartComponents minute]] forKey:@"start"];
        [mutableQuietTimePayload setValue:[NSString stringWithFormat:@"%02d:%02d", [quietTimeEndComponents hour], [quietTimeEndComponents minute]] forKey:@"end"];
        
        [mutablePayload setValue:mutableQuietTimePayload forKey:@"quiettime"];
    }
    
    if (timeZone) {
        [mutablePayload setValue:[timeZone name] forKey:@"tz"];
    }
    
    [self registerDeviceToken:deviceToken withPayload:mutablePayload success:success failure:failure];
}

- (void)registerDeviceToken:(NSString *)deviceToken
                withPayload:(NSDictionary *)payload
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure
{    
    [self putPath:[NSString stringWithFormat:@"device_tokens/%@", AFNormalizedDeviceTokenStringWithDeviceToken(deviceToken)] parameters:payload success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)unregisterDeviceToken:(NSString *)deviceToken
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure
{
    [self deletePath:[NSString stringWithFormat:@"device_tokens/%@", AFNormalizedDeviceTokenStringWithDeviceToken(deviceToken)] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success();
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
