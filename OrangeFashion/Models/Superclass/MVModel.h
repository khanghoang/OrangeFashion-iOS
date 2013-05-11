//
//  MVModel.h
//  MyVillage
//
//  Created by Torin on 10/9/12.
//  Copyright (c) 2012 2359media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVModel : NSObject <NSCoding>

- (NSString *)description;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)updateWithDictionary:(NSDictionary*)dict;
- (id)updateWithModel:(MVModel*)newModel;
- (id)createCopy;

- (NSDictionary*)toDictionary;
- (NSDictionary*)toDictionaryUseNullValue:(BOOL)useNull;

@end
