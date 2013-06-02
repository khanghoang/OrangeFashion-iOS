//
//  ADModel.m
//  AutoDealer
//
//  Created by Torin on 10/9/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

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
    
    //Hook
    BOOL hasHook = [self hookForKey:dictKey value:dictValue];
    if (hasHook)
      continue;
    
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
      
      //Handle NSDate type
      if (dictValue != nil
          && [dictValue isEqual:[NSNull null]] == NO
          && [ivarType isEqual:@"@\"NSDate\""]
          && [dictValue isKindOfClass:[NSString class]] == YES)
      {
        //ISO8601 datetime format
        if ([dictValue contains:@"-"] || [dictValue contains:@"T"] || [dictValue contains:@":"])
        {
          //Once
          static ISO8601DateFormatter *formatter = nil;
          if (formatter == nil)
            formatter = [[ISO8601DateFormatter alloc] init];
          
          //Could be nil
          NSDate *dateTimeValue = [formatter dateFromString:dictValue];
          dictValue = dateTimeValue;
        }
        //Unix timestamp format
        else
        {
          NSDate *dateTimeValue = [NSDate dateWithTimeIntervalSince1970:[dictValue longLongValue]];
          dictValue = dateTimeValue;
        }
      }
      
      [self setValue:dictValue forKey:ivarName];
    }
  }
  
  free(ivars);
  return self;
}

- (BOOL)hookForKey:(NSString*)key value:(id)value
{
  //Subclass to override this if needed
  return NO;
}

- (id)updateWithModel:(BaseModel*)newModel
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
 * Example: ADTestDrive -> TestDrive
 */
- (NSString*)getProperName
{
  //Remove AD prefix
  NSString *className = NSStringFromClass([self class]);
  return [className substringFromIndex:2];
}

/*
 * Example: ADTestDrive -> test_drive
 */
- (NSString*)getLowerCaseName
{
  //Lowercase, remove AD prefix
  NSString *className = [NSStringFromClass([self class]) lowercaseString];
  className = [className substringFromIndex:2];
  
  if ([className isEqualToString:@"modeltype"])
    className = @"model_type";
  else if ([className isEqualToString:@"testdrive"])
    className = @"test_drive";
  
  return className;
}

/*
 * Pack all properties into a dictionary, without Null values
 */
- (NSMutableDictionary*)toDictionary
{
  return [self toDictionaryUseNullValue:NO];
}

/*
 * Pack all properties into a dictionary, with or without Null values
 */
- (NSMutableDictionary*)toDictionaryUseNullValue:(BOOL)useNull
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
        }else{
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

- (id)copyWithZone:(NSZone*)zone
{
  //Simply convert to dictionary
  NSDictionary * originalDictionary = [self toDictionary];
  NSMutableDictionary * mutableDictionary = [self toDictionary];
  
  //For each top-level property in the dictionary
  NSEnumerator *enumerator = [originalDictionary keyEnumerator];
  id dictKey;
  while ((dictKey = [enumerator nextObject]))
  {
    id dictValue = [originalDictionary objectForKey:dictKey];
    
    //Replace each element in NSArray with a copy of it (recursive down)
    if ([dictValue isKindOfClass:[NSArray class]] || [dictValue isKindOfClass:[NSMutableArray class]])
    {
      NSArray *array = (NSArray *)dictValue;
      NSMutableArray *tempMutableArray = [NSMutableArray arrayWithCapacity:[array count]];
      for (id object in array)
        [tempMutableArray addObject:[object copy]];
      
      [mutableDictionary setObject:tempMutableArray forKey:dictKey];
    }
    
    //Replace each element in NSDictionary with a copy of it (recursive down)
    else if ([dictValue isKindOfClass:[NSDictionary class]] || [dictValue isKindOfClass:[NSMutableDictionary class]])
    {
      NSDictionary *dict = (NSDictionary *)dictValue;
      NSMutableDictionary *tempMutableDictionary = [NSMutableDictionary dictionary];
      [dict enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent
                                    usingBlock:^(id subKey, id subObject, BOOL *stop)
       {
         [tempMutableDictionary setObject:[subObject copy] forKey:subKey];
       }];
      
      [mutableDictionary setObject:tempMutableDictionary forKey:dictKey];
    }
  }
  
  id copySelfObject = [[[self class] alloc] initWithDictionary:mutableDictionary];
  originalDictionary = nil;
  mutableDictionary = nil;
  
  return copySelfObject;
}

@end
