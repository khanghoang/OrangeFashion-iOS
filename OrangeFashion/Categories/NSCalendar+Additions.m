//
//  NSCalendar+Additions.m
//  Aurora
//
//  Created by Daud Abas on 29/6/12.
//  Copyright (c) 2012 2359media Pte Ltd. All rights reserved.
//

#import "NSCalendar+Additions.h"

@implementation NSCalendar (Additions)

+(NSCalendar *)sharedCalendar {
    static NSCalendar *_sharedCalendar = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
      _sharedCalendar = [NSCalendar currentCalendar];
      [_sharedCalendar setTimeZone:[NSTimeZone systemTimeZone]];
    });
    
  return _sharedCalendar;
}

@end
