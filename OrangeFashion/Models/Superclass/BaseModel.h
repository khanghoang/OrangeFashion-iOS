//
//  Model.h
//  TemplateProject
//
//  Created by Torin on 10/9/12.
//  Copyright (c) 2012 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CLASS_PREFIX_LENGTH             2

@interface BaseModel : NSObject <NSCoding>

- (NSString*)description;
- (NSString*)getProperName;
- (NSString*)getLowerCaseName;

- (id)initWithDictionary:(NSDictionary*)dict;
- (id)updateWithDictionary:(NSDictionary*)dict;
- (id)updateWithModel:(BaseModel*)newModel;
- (id)createCopy;

- (NSMutableDictionary*)toDictionary;
- (NSMutableDictionary*)toDictionaryUseNullValue:(BOOL)useNull;

// Data model linking
- (void)dataModelLinking;
- (void)assignKey:(NSString*)key toDataModelClass:(Class)classObject;

@end

@protocol EGCSharingProtocol

- (NSString *)sharingTitle;
- (NSString *)sharingMessage;
- (NSString *)sharingFullMessage;
- (NSURL *)sharingImageURL;
- (NSURL *)sharingURL;

@end
