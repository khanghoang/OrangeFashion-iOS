//
//  NSDictionary+Additions.h
//
//  Created by Jesse Armand on 5/1/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Additions)

- (NSArray *)arrayForKey:(id)key;
- (NSDictionary *)dictionaryForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (NSString *)stringForKey:(id)key;
- (NSArray *)listForKey:(id)key;
- (NSDictionary*) deepCopy;
- (id)objectForInteger:(NSInteger)key;

@end

@interface NSMutableDictionary (Additions)

- (void)setValidObject:(id)object forKey:(id <NSCopying>)key;
- (void)setObject:(id)object forInteger:(NSInteger)key;

@end
