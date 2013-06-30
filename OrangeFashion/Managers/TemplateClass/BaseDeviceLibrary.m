//
//  BaseDeviceLibrary.m
//
//  Created by Torin Nguyen on 2/3/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "BaseDeviceLibrary.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#include <sys/types.h>
#include <sys/sysctl.h>

@interface BaseDeviceLibrary()
@property (nonatomic, assign) NSInteger pushNotificationTokenAPIRetryCounter;
@end

@implementation BaseDeviceLibrary

SINGLETON_MACRO

+ (NSString *)getCarrierName {
  CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
  CTCarrier *carrier = [netinfo subscriberCellularProvider];
  
  //No telephony hardware
  if (carrier == nil)
    return nil;
  
  //NSString *carrierName = carrier.carrierName;    //this is in the official documentation but doesn't work!!

  //Workaround, parse the string manually
  /*
   CTCarrier (0x34beb0) {
      Carrier name: [SingTel]
      Mobile Country Code: []
      Mobile Network Code:[]
      ISO Country Code:[]
      Allows VOIP? [YES]
   }
  */
  NSString *carrierChunk = [NSString stringWithFormat:@"%@", carrier];

  NSArray *chunks = [carrierChunk componentsSeparatedByString: @"]"];
  for (NSString *chunk in chunks)
  {
    if (![[chunk lowercaseString] contains:@"carrier"])
      continue;
    
    //Carrier name: [SingTel
    NSArray *subchunks = [chunk componentsSeparatedByString: @"["];
    for (NSString *subchunk in subchunks) {
      if ([[subchunk lowercaseString] contains:@"carrier"])
        continue;
      return subchunk;
    }
    break;
  }
  
  return nil;
}

+ (NSString *)rawPlatformString {
  size_t size;
  sysctlbyname("hw.machine", NULL, &size, NULL, 0);
  char *machine = malloc(size);
  sysctlbyname("hw.machine", machine, &size, NULL, 0);
  NSString *platform = [NSString stringWithUTF8String:machine];
  free(machine);
  
  return platform;
}

+ (NSString *) getPlatformString {
  
  NSString *platform = [BaseDeviceLibrary rawPlatformString];

  if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
  if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
  if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
  if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
  if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
  if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
  if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5,1";
  if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5,2";
  if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5,3";
  if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5,4";
  if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
  if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
  if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
  if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
  if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
  if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
  if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
  if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
  if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
  if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";    //32nm processor
  if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
  if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3";
  if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3";
  if ([platform isEqualToString:@"i386"])         return @"Simulator";
  if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
  return platform;
}

@end
