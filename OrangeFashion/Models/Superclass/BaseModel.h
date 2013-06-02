//
//  ADModel.h
//  AutoDealer
//
//  Created by Torin on 10/9/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>

- (NSString *)description;
- (NSString*)getProperName;
- (NSString*)getLowerCaseName;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)updateWithDictionary:(NSDictionary*)dict;
- (id)updateWithModel:(BaseModel*)newModel;
- (id)createCopy;

- (NSMutableDictionary*)toDictionary;
- (NSMutableDictionary*)toDictionaryUseNullValue:(BOOL)useNull;

@end
