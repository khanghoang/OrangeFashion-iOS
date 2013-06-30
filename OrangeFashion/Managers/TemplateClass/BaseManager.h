//
//  BaseManager.h
//  TemplateProject
//
//  Created by Torin on 4/12/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SINGLETON_MACRO + (instancetype)sharedInstance { static dispatch_once_t pred; static id __singleton = nil; dispatch_once(&pred, ^{ __singleton = [[self alloc] init]; }); return __singleton; }

@interface BaseManager : NSObject

+ (instancetype)sharedInstance;

+ (NSData*)loadJSONDataFromFileName:(NSString*)filename;
+ (id)loadJSONObjectFromFileName:(NSString*)filename;

/**
 *Send notification method to send a notification info to a other view doing st...
 *@Param: notificationName : name of notification
 */
- (void)sendNotification:(NSString *)notificationName;

/**
 *Send notification method to send a notification info to a other view doing st...
 *@Param notificationName : name of notification
 *@Param body             : data to send in notification
 */
- (void)sendNotification:(NSString *)notificationName body:(id)body;

/**
 *Send notification method to send a notification info to a other view doing st...
 *@Param notificationName : name of notification
 *@Param body             : data to send in notification
 *@Param type             : type of notification
 */
- (void)sendNotification:(NSString *)notificationName body:(id)body type:(id)type;


@end
