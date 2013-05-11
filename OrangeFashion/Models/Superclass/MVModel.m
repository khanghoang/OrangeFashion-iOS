//
//  MVModel.m
//  MyVillage
//
//  Created by Torin on 10/9/12.
//  Copyright (c) 2012 2359media. All rights reserved.
//

#import "MVModel.h"
#import <objc/runtime.h>

@implementation MVModel

- (id)initWithDictionary:(NSDictionary*)dict
{
  self = [super init];
  if (self == nil)
    return self;
  
  return [self updateWithDictionary:dict];
}

- (id)updateWithDictionary:(NSDictionary*)dict
{
  //List of ivars
  unsigned int outCount;
  id class = objc_getClass([NSStringFromClass([self class]) UTF8String]);
  Ivar *ivars = class_copyIvarList(class, &outCount);
  
  //For each top-level property in the dictionary
  NSEnumerator *enumerator = [dict keyEnumerator];
  id dictKey;
  while ((dictKey = [enumerator nextObject]))
  {
    id dictValue = [dict objectForKey:dictKey];
    
    //Special case for "id" property
    if ([dictKey isEqualToString:@"id"])
      dictKey = @"ID";
    
    //If it match our ivar name, then set it
    for (unsigned int i = 0; i < outCount; i++)
    {
      Ivar ivar = ivars[i];
      NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
      NSString *ivarNameTrim = [ivarName substringFromIndex:1];
      NSString *ivarType = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
      
      if ([dictKey isEqualToString:ivarNameTrim] == NO)
        continue;

      //Empty value
      if ([dictValue isKindOfClass:[NSNull class]] ||
          ([dictValue isKindOfClass:[NSString class]] && [dictValue isEqualToString:@"null"])) {
        continue;
      }
      
      //Convert unix timestamp number to NSDate
      if (dictValue != nil
          && [dictValue isEqual:[NSNull null]] == NO
          && [ivarType isEqual:@"@\"NSDate\""])
      {
        NSDate *dateTimeValue = [NSDate dateWithTimeIntervalSince1970:[dictValue longLongValue]];
        dictValue = dateTimeValue;
      }
      
      [self setValue:dictValue forKey:ivarName];
    }
  }
  
  free(ivars);
  return self;
}

- (id)updateWithModel:(MVModel*)newModel
{
  unsigned int outCount;
  id class = objc_getClass([NSStringFromClass([self class]) UTF8String]);
  Ivar *ivars = class_copyIvarList(class, &outCount);
  
  for (unsigned int i = 0; i < outCount; i++) {
    Ivar ivar = ivars[i];
    NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
    NSString *ivarNameTrim = [ivarName substringFromIndex:1];    
    NSString *ivarType = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
    
    //Check nil
    if ([ivarType hasPrefix:@"@"])
    {
      id ivarValue = object_getIvar(newModel, ivar);
      if (ivarValue == nil)
        continue;
      
      [self setValue:ivarValue forKey:ivarNameTrim];
    }
  }
  
  free(ivars);
  return self;
}

- (id)createCopy
{
  return [[[self class] alloc] initWithDictionary:[self toDictionary]];
}


/*
 * Print out all ivars for debugging
 */
- (NSString *)description
{
  NSDictionary *dictionary = [self toDictionaryUseNullValue:YES];  
  return [NSString stringWithFormat:@"<%@ %p> %@", NSStringFromClass([self class]), self, dictionary];
}

/*
 * Pack all properties into a dictionary, without Null values
 */
- (NSDictionary*)toDictionary
{
  return [self toDictionaryUseNullValue:NO];
}

/*
 * Pack all properties into a dictionary, with or without Null values
 */
- (NSDictionary*)toDictionaryUseNullValue:(BOOL)useNull
{
  NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
  
  unsigned int outCount;
  id class = objc_getClass([NSStringFromClass([self class]) UTF8String]);
  Ivar *ivars = class_copyIvarList(class, &outCount);
  
  for (unsigned int i = 0; i < outCount; i++) {
    Ivar ivar = ivars[i];
    NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
    NSString *ivarNameTrim = [ivarName substringFromIndex:1];
    if ([ivarNameTrim isEqualToString:@"ID"])
      ivarNameTrim = @"id";

    NSString *encoding = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
    
    //Check nil
    if ([encoding hasPrefix:@"@"])
    {
      id ivarValue = object_getIvar(self, ivar);
      
      if (ivarValue == nil) {
        if (useNull == NO)
          continue;
        ivarValue = [NSNull null];
      }
      //Check NSDate
      if ([encoding isEqualToString:@"@\"NSDate\""]){
        // check nil
        if (![ivarValue isEqual:[NSNull null]]){
          ivarValue = [NSNumber numberWithUnsignedLongLong:[ivarValue timeIntervalSince1970]];
        }else if (useNull){
          ivarValue = [NSNull null];
        }else {
          // TODO: some value.
          DLog(@"something wrong may happened!!!!!!!!!!!");
        }
      }
      
      [dictionary setObject:ivarValue forKey:ivarNameTrim];
    }
  }
  
  free(ivars);
  return dictionary;
}
   
/*
 * Support offline caching with NSKeyArchiver
 */
- (void)encodeWithCoder:(NSCoder *)coder
{
  unsigned int outCount;
  id class = objc_getClass([NSStringFromClass([self class]) UTF8String]);
  Ivar *ivars = class_copyIvarList(class, &outCount);
  
  for (unsigned int i = 0; i < outCount; i++) {
    Ivar ivar = ivars[i];
    NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
    NSString *encoding = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
    
    //Check nil
    if ([encoding hasPrefix:@"@"])
    {
      id ivarValue = object_getIvar(self, ivar);
      if (ivarValue == nil)
        continue;
      
      [coder encodeObject:ivarValue forKey:ivarName];
    }
  }
  
  free(ivars);
}

/*
 * Support offline caching with NSKeyArchiver
 */
- (id)initWithCoder:(NSCoder *)coder
{
  self = [super init];
  if (self == nil)
    return self;
  
  unsigned int outCount;
  id class = objc_getClass([NSStringFromClass([self class]) UTF8String]);
  Ivar *ivars = class_copyIvarList(class, &outCount);
  
  for (unsigned int i = 0; i < outCount; i++) {
    Ivar ivar = ivars[i];
    NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
    NSString *encoding = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
    
    //Check nil
    if ([encoding hasPrefix:@"@"])
      [self setValue:[coder decodeObjectForKey:ivarName] forKey:ivarName];
  }
  
  free(ivars);
  
  return self;
}

@end
