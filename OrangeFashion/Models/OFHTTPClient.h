//
//  OFHTTPClient.h
//  OrangeFashion
//
//  Created by Khang on 5/4/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "AFHTTPClient.h"

typedef void (^OFJSONRequestSuccessBlock) (NSInteger statusCode, id obj);
typedef void (^OFJSONRequestFailureBlock) (NSInteger statusCode, id obj);

typedef void (^OFRequestSuccessBlock) (NSInteger statusCode, id obj);
typedef void (^OFRequestFailureBlock) (NSInteger statusCode, id obj);

typedef void (^OFRequestProgressBLock) (NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile);

@interface OFHTTPClient : AFHTTPClient

+ (instancetype)sharedClient;

@end
