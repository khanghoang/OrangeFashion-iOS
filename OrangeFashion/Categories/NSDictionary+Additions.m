//
//  NSDictionary+Additions.m
//
//  Created by Jesse Armand on 5/1/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "NSDictionary+Additions.h"

#import "NSObject+Additions.h"

@implementation NSDictionary (Additions)

- (NSArray *)arrayForKey:(id)key {
  id object = [self objectForKey:key];
  return [object ifKindOfClass:[NSArray class]];
}

- (NSDictionary *)dictionaryForKey:(id)key {
  id object = [self objectForKey:key];
  return [object ifKindOfClass:[NSDictionary class]];
}

- (NSNumber *)numberForKey:(id)key {
  id object = [self objectForKey:key];
  return [object ifKindOfClass:[NSNumber class]];
}

- (NSString *)stringForKey:(id)key {
  id object = [self objectForKey:key];
  return [object ifKindOfClass:[NSString class]];
}

- (NSArray *)listForKey:(id)key {
  return [[self dictionaryForKey:key] arrayForKey:@"list"];
}

- (NSDictionary*) deepCopy {
  unsigned int count = [self count];
  NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
  
  NSEnumerator *e = [self keyEnumerator];
    
  id thisKey;
  while ((thisKey = [e nextObject]) != nil) {
    id obj = [self objectForKey:thisKey];
    if (obj == nil)
      continue;

    id key = nil;
    if ([thisKey respondsToSelector:@selector(deepCopy)])
      key = [thisKey deepCopy];
    else
      key = [thisKey copy];

    if ([obj respondsToSelector:@selector(deepCopy)])
      [newDictionary setObject:[obj deepCopy] forKey:key];
    else
      [newDictionary setObject:[obj copy] forKey:key];
  }
    
  NSDictionary *returnDictionary = [newDictionary copy];
  newDictionary = nil;
  return returnDictionary;
}

- (id)objectForInteger:(NSInteger)key
{
  return [self objectForKey:[NSNumber numberWithInteger:key]];
}

@end

@implementation NSMutableDictionary (Additions)

- (void)setValidObject:(id)object forKey:(id <NSCopying>)key
{
  if (object == nil)
    object = [NSNull null];
  [self setObject:object forKey:key];
}

- (void)setObject:(id)object forInteger:(NSInteger)key
{
  [self setObject:object forKey:[NSNumber numberWithInteger:key]];
}

@end

