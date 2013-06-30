//
//  OFHTTPClient.m
//  OrangeFashion
//
//  Created by Khang on 5/4/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFHTTPClient.h"

@implementation OFHTTPClient

+ (instancetype)sharedClient
{
    static OFHTTPClient *__sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[OFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:API_SERVER_HOST]];
    });
    
    return __sharedInstance;
}

+ (NSSet *)defaultAcceptableContentTypes;
{
    return [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    
    return self;
}

@end
