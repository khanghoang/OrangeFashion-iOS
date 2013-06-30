//
//  BaseStorageManager.h
//
//  Created by Torin on 14/2/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseStorageManager : BaseManager

#pragma mark - Generic

- (id)getClassModelObject:(Class)classObject withId:(NSNumber*)key;
- (id)addOrUpdateClassModel:(Class)classObject withDictionary:(NSDictionary*)dict;
- (NSArray*)getAllClassModelObject:(Class)classObject;
- (NSArray*)getAllClassModelObject:(Class)classObject withFilterModelObject:(id)filterModelObject;
- (NSArray*)getAllClassModelNameList:(Class)classObject sorted:(BOOL)sorted;
- (NSArray*)getAllClassModelNameList:(Class)classObject sorted:(BOOL)sorted withFilterModelObject:(id)filterModelObject;
- (NSArray*)getAllObjectsOfClass:(Class)classObject withPropertyName:(NSString *)propertyName value:(id)value;

#pragma mark - Settings

- (EGCSetting*)getSettingWithKey:(NSString*)key;
- (NSString*)getSettingStringValueWithKey:(NSString*)key;
- (NSNumber*)getSettingNumberValueWithKey:(NSString*)key;
- (NSArray*)getSettingStringArrayValueWithKey:(NSString*)key;
- (NSString*)getSettingStringValueWithKey:(NSString*)key defaultValue:(NSString*)defaultValue;
- (NSNumber*)getSettingNumberValueWithKey:(NSString*)key defaultValue:(NSNumber*)defaultValue;
- (NSInteger)getSettingIntegerValueWithKey:(NSString*)key defaultValue:(NSInteger)defaultValue;
- (CGFloat)getSettingFloatValueWithKey:(NSString*)key defaultValue:(CGFloat)defaultValue;
- (BOOL)getSettingBOOLValueWithKey:(NSString*)key defaultValue:(BOOL)defaultValue;

#pragma mark - Offline cache

- (void)restore;
- (BOOL)dumpQuickOfflineCache;
- (BOOL)dumpFullOfflineCache;
- (BOOL)restoreOfflineCache;
- (BOOL)restoreOfflineQuick;
- (BOOL)hasOfflineCache;

#pragma mark - Single Object Store

- (void)setObject:(id)object forKey:(NSString *)key;
- (id)objectForKey:(NSString *)key;

#pragma mark - Store Data To Disk

- (void)storeDataToDisk:(NSDictionary *)object withFileName:(NSString *)fileName;
- (id)getDataFromDiskWithFileName:(NSString *)fileName;

@end
