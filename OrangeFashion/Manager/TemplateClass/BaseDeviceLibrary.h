//
//  BaseDeviceLibrary.h
//
//  Created by Torin Nguyen on 2/3/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

@interface BaseDeviceLibrary : NSObject

+ (NSString *)getCarrierName;

+ (NSString *)rawPlatformString;
+ (NSString *)getPlatformString;

@end
