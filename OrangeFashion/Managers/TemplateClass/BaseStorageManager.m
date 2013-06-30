//
//  BaseStorageManager.m
//
//  Created by Torin on 14/2/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "BaseStorageManager.h"
#import <objc/runtime.h>

@interface BaseStorageManager()

@property (nonatomic, strong) NSMutableDictionary *allEGCSettings;
@property (nonatomic, strong) NSMutableDictionary *allEGCUsers;

@end

@implementation BaseStorageManager

SINGLETON_MACRO

- (id)init
{
    self = [super init];
    if (self == nil)
        return self;
    
    [self restoreOfflineQuick];
    
    return self;
}

/*
 * Full restore of all offline cache, this will take a bit of time to complete
 */
- (void)restore
{
    //Not on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
        [self restoreOfflineCache];
        [self initializeAllDictionary];
    });
}



#pragma mark - Generic

- (void)initializeAllDictionary
{
    //List of ivars
    unsigned int outCount;
    id class = objc_getClass([NSStringFromClass([self class]) UTF8String]);
    Ivar *ivars = class_copyIvarList(class, &outCount);
    
    //If it match our ivar name, then set it
    for (unsigned int i = 0; i < outCount; i++)
    {
        //Correct name prefix
        Ivar ivar = ivars[i];
        NSString *ivarName = [NSString stringWithCString:ivar_getName(ivar) encoding:NSUTF8StringEncoding];
        NSString *ivarNameTrim = [ivarName substringFromIndex:1];
        if ([ivarNameTrim hasPrefix:@"all"] == NO)
            continue;
        
        //Correct type
        NSString *ivarType = [NSString stringWithCString:ivar_getTypeEncoding(ivar) encoding:NSUTF8StringEncoding];
        //Handle NSDate type
        if ([ivarType isEqual:@"@\"NSMutableDictionary\""] == NO)
            continue;
        
        //Already has data
        id value = [self valueForKey:ivarNameTrim];
        if ([value isKindOfClass:[NSMutableDictionary class]] == YES)
            continue;
        
        //Initialize with empty dictionary
        value = [NSMutableDictionary dictionary];
        [self setValue:value forKey:ivarNameTrim];
    }
    
    free(ivars);
}

- (NSMutableDictionary *)getDictionaryForAllClassObject:(Class)classObject
{
    //The storage dictionary (eg. self.allADSettings)
    NSString *pluralizedName = [NSStringFromClass(classObject) pluralizeString];
    NSString *pluralizedPropertyName = [NSString stringWithFormat:@"all%@", pluralizedName];
    
    //Checkc @property exists
    SEL selector = NSSelectorFromString(pluralizedPropertyName);
    if ([self respondsToSelector:selector] == NO) {
        DLog(@"@property %@ doesn't exist in %@", pluralizedPropertyName, NSStringFromClass([self class]));
        return nil;
    }
    
    //Get the @property value
    id data = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    data = [self performSelector:selector];
#pragma clang diagnostic pop
    if (data == nil || [data isKindOfClass:[NSMutableDictionary class]] == NO)
        return nil;
    
    return data;
}

- (BOOL)setDictionaryForAllClassObject:(Class)classObject data:(id)data
{
    if (data == nil)
        return NO;
    //if ([data isKindOfClass:[NSMutableDictionary class]] == NO)
    //  return NO;
    
    //The storage dictionary (eg. self.allADSettings)
    NSString *pluralizedName = [NSStringFromClass(classObject) pluralizeString];
    NSString *pluralizedPropertyName = [NSString stringWithFormat:@"all%@", pluralizedName];
    SEL selector = NSSelectorFromString(pluralizedPropertyName);
    if ([self respondsToSelector:selector] == NO) {
        DLog(@"@property %@ doesn't exist in %@", pluralizedPropertyName, NSStringFromClass([self class]));
        return NO;
    }
    
    //@property setting
    [self setValue:data forKey:pluralizedPropertyName];
    return YES;
}


- (id)getClassModelObject:(Class)classObject withId:(NSNumber*)key
{
    if (key == nil)
        return nil;
    
    //The storage dictionary (eg. self.allADSettings)
    NSString *pluralizedName = [NSStringFromClass(classObject) pluralizeString];
    NSString *pluralizedPropertyName = [NSString stringWithFormat:@"all%@", pluralizedName];
    SEL selector = NSSelectorFromString(pluralizedPropertyName);
    if ([self respondsToSelector:selector] == NO) {
        DLog(@"@property %@ doesn't exist in %@", pluralizedPropertyName, NSStringFromClass([self class]));
        return nil;
    }
    
    //The dictionary
    NSMutableDictionary *dict = [self valueForKey:pluralizedPropertyName];
    if ([dict isKindOfClass:[NSMutableDictionary class]] == NO)
        return nil;
    
    id object = [dict objectForKey:key];
    return object;
}

- (id)addOrUpdateClassModel:(Class)classObject withDictionary:(NSDictionary*)dict
{
    if (dict == nil)
        return nil;
    
    //Key is not necessary, but highly recommended
    NSNumber *key = [dict numberForKey:@"id"];
    if ([key integerValue] <= 0)
    {
        DLog(@"Dictionary for class %@ doesn't contain id", NSStringFromClass(classObject));
    }
    else
    {
        id existingModel = [self getClassModelObject:classObject withId:key];
        if (existingModel != nil)
        {
            if ([existingModel respondsToSelector:@selector(updateWithDictionary:)])
                [existingModel updateWithDictionary:dict];
            return existingModel;
        }
    }
    
    //Create a new model object in memory
    id newModel = [[classObject alloc] initWithDictionary:dict];
    if (newModel == nil)
        return nil;
    
    //Optional, but highly recommended to have
    //The storage dictionary (eg. self.allEGCSettings)
    NSString *pluralizedName = [NSStringFromClass(classObject) pluralizeString];
    NSString *pluralizedPropertyName = [NSString stringWithFormat:@"all%@", pluralizedName];
    SEL selector = NSSelectorFromString(pluralizedPropertyName);
    if ([self respondsToSelector:selector] == NO)
    {
        DLog(@"@property %@ doesn't exist in %@", pluralizedPropertyName, NSStringFromClass([self class]));
    }
    else if (key != nil)
    {
        //Store all models of the same class in to a big dictionary
        NSMutableDictionary *allDict = [self valueForKey:pluralizedPropertyName];
        if ([allDict isKindOfClass:[NSMutableDictionary class]] == YES)
            [allDict setObject:newModel forKey:key];
    }
    
    return newModel;
}

- (NSArray*)getAllClassModelObject:(Class)classObject
{
    NSMutableDictionary *allDict = [self getDictionaryForAllClassObject:classObject];
    if (allDict == nil)
        return nil;
    
    //Sort by 'name'
    NSArray * array = [allDict allValues];
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:@[firstDescriptor]];
    
    array = nil;
    return sortedArray;
}

- (NSArray*)getAllClassModelObject:(Class)classObject withFilterModelObject:(id)filterModelObject
{
    NSArray * array = [self getAllClassModelObject:classObject];
    if ([array count] <= 0)
        return nil;
    if (filterModelObject == nil)
        return array;
    
    NSMutableArray * outputArray = [NSMutableArray array];
    
    //Lowercase, remove AD prefix
    NSString *filterPropertyName = [NSStringFromClass([filterModelObject class]) lowercaseString];
    filterPropertyName = [filterPropertyName substringFromIndex:CLASS_PREFIX_LENGTH];
    
    for (id model in array)
    {
        //Missing link
        id filterPropertyValue = [model valueForKey:filterPropertyName];
        if (filterPropertyValue == nil)
            continue;
        
        //Not correct filter
        if ([[filterPropertyValue valueForKey:@"ID"] isEqual:[filterModelObject valueForKey:@"ID"]] == NO)
            continue;
        
        [outputArray addObject:model];
    }
    
    array = nil;
    return outputArray;
}

- (NSArray*)getAllClassModelNameList:(Class)classObject sorted:(BOOL)sorted
{
    NSMutableArray *valueStringArray = [NSMutableArray array];
    
    NSArray * modelsArray = [[BaseStorageManager sharedInstance] getAllClassModelObject:classObject];
    for (id model in modelsArray)
    {
        if ([model respondsToSelector:@selector(name)]) {
            if ([[model name] length] > 0)
                [valueStringArray addObject:[model name]];
        }
        else if ([model respondsToSelector:@selector(title)]) {
            if ([[model title] length] > 0)
                [valueStringArray addObject:[model title]];
        }
        else
            [valueStringArray addObject:@""];
    }
    
    //Alphabetical order
    if (sorted)
        [valueStringArray sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return valueStringArray;
}

- (NSArray*)getAllClassModelNameList:(Class)classObject sorted:(BOOL)sorted withFilterModelObject:(id)filterModelObject
{
    NSMutableArray *valueStringArray = [NSMutableArray array];
    
    NSArray * modelsArray = [[BaseStorageManager sharedInstance] getAllClassModelObject:classObject withFilterModelObject:filterModelObject];
    for (id model in modelsArray)
    {
        if ([model respondsToSelector:@selector(name)]) {
            if ([[model name] length] > 0)
                [valueStringArray addObject:[model name]];
        }
        else if ([model respondsToSelector:@selector(title)]) {
            if ([[model title] length] > 0)
                [valueStringArray addObject:[model title]];
        }
        else
            [valueStringArray addObject:@""];
    }
    
    //Alphabetical order
    if (sorted)
        [valueStringArray sortUsingSelector:@selector(caseInsensitiveCompare:)];
    
    return valueStringArray;
}

- (NSArray*)getAllObjectsOfClass:(Class)classObject withPropertyName:(NSString *)propertyName value:(id)value
{
    if ([propertyName length] == 0 || [value length] == 0)
        return nil;
    
    NSArray *allObjects = [self getAllClassModelObject:classObject];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", propertyName, value];
    NSArray *results = [allObjects filteredArrayUsingPredicate:predicate];
    
    return results;
}

#pragma mark - Settings

- (EGCSetting*)getSettingWithKey:(NSString*)key
{
  for (EGCSetting *model in self.allEGCSettings.allValues)
    if ([model.key isEqualToString:key])
      return model;
  return nil;
}

- (NSString*)getSettingStringValueWithKey:(NSString*)key
{
  EGCSetting *model = [self getSettingWithKey:key];
  if ([[model value] isKindOfClass:[NSString class]] == NO)
    return nil;
  return [model value];
}

- (NSNumber*)getSettingNumberValueWithKey:(NSString*)key
{
  EGCSetting *model = [self getSettingWithKey:key];
  if ([[model value] isKindOfClass:[NSNumber class]] == NO)
    return nil;
  return [model value];
}

- (NSArray*)getSettingStringArrayValueWithKey:(NSString*)key
{
  EGCSetting *model = [self getSettingWithKey:key];
  if ([[model value] isKindOfClass:[NSString class]] == NO)
    return nil;
  NSArray *array = [[model value] componentsSeparatedByString:@"|"];
  return array;
}

- (NSString*)getSettingStringValueWithKey:(NSString*)key defaultValue:(NSString*)defaultValue
{
  NSString *value = [self getSettingStringValueWithKey:key];
  if (value != nil)
    return value;
  return defaultValue;
}

- (NSNumber*)getSettingNumberValueWithKey:(NSString*)key defaultValue:(NSNumber*)defaultValue
{
  NSNumber *value = [self getSettingNumberValueWithKey:key];
  if (value != nil)
    return value;
  return defaultValue;
}

- (NSInteger)getSettingIntegerValueWithKey:(NSString*)key defaultValue:(NSInteger)defaultValue
{
    NSNumber *value = [self getSettingNumberValueWithKey:key];
    if (value != nil)
        return [value integerValue];
    return defaultValue;
}

- (CGFloat)getSettingFloatValueWithKey:(NSString*)key defaultValue:(CGFloat)defaultValue
{
    NSNumber *value = [self getSettingNumberValueWithKey:key];
    if (value != nil)
        return [value floatValue];
    return defaultValue;
}

- (BOOL)getSettingBOOLValueWithKey:(NSString*)key defaultValue:(BOOL)defaultValue
{
    NSNumber *value = [self getSettingNumberValueWithKey:key];
    if (value != nil)
        return [value boolValue];
    return defaultValue;
}


- (EGCSetting*)getSettingWithId:(NSNumber*)key
{
  return [self.allEGCSettings objectForKey:key];
}
- (EGCSetting*)addOrUpdateSetting:(NSDictionary*)dict
{
    NSNumber *key = [dict numberForKey:@"id"];
    if ([key integerValue] > 0)
    {
        EGCSetting *existingModel = [self getSettingWithId:key];
        if (existingModel != nil) {
            [existingModel updateWithDictionary:dict];
            return existingModel;
        }
    }
    
    EGCSetting *newModel = [[EGCSetting alloc] initWithDictionary:dict];
    [self.allEGCSettings setObject:newModel forKey:key];
    return newModel;
}



#pragma mark - Offline cache

- (NSString *)getOfflineCacheDirectory {
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray* cachePathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cacheDirectory = [NSString stringWithFormat:@"%@/OfflineDataCache/", [cachePathArray lastObject]];
  
  BOOL isDir=YES;
  if (![fileManager fileExistsAtPath:cacheDirectory isDirectory:&isDir])
    if (![fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:nil])     //iOS4.3
      DLog(@"Error: Failed to create offline cache folder");
  
  return cacheDirectory;
}

- (BOOL)hasOfflineCache
{
  NSString *cacheDirectory = [self getOfflineCacheDirectory];
  NSError *error;
  NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cacheDirectory error:&error];
  if (error != nil || [dirContents count] <= 0)
    return NO;
  
  return YES;
}

- (BOOL)dumpQuickOfflineCache
{
    NSString *cacheDirectory = [self getOfflineCacheDirectory];
    BOOL success = YES;
    if ([self saveOfflineAllClassObjects:[EGCSetting class] directory:cacheDirectory] == NO)     success = NO;
    return success;
}

- (BOOL)dumpFullOfflineCache
{
    NSString *cacheDirectory = [self getOfflineCacheDirectory];
    BOOL success = YES;
    if ([self saveOfflineAllClassObjects:[EGCSetting class] directory:cacheDirectory] == NO)        success = NO;
    return success;
}

- (BOOL)restoreOfflineCache
{
    NSString *cacheDirectory = [self getOfflineCacheDirectory];
    BOOL success = YES;
    if ([self restoreOfflineAllClassObjects:[EGCSetting class] directory:cacheDirectory] == NO)     success = NO;
    return success;
}

- (BOOL)restoreOfflineQuick
{
    NSString *cacheDirectory = [self getOfflineCacheDirectory];
    BOOL success = YES;
    if ([self restoreOfflineAllClassObjects:[EGCSetting class] directory:cacheDirectory] == NO)      success = NO;
    return success;
}

- (BOOL)saveOfflineAllClassObjects:(Class)classObject directory:(NSString*)directory
{
    //The storage dictionary (eg. self.allADSettings)
    NSDictionary *data = [self getDictionaryForAllClassObject:classObject];
    
    if (data == nil)
        return NO;
    
    //Storage path
    NSString *pluralizedName = [NSStringFromClass(classObject) pluralizeString];
    NSString *pluralizedPropertyName = [NSString stringWithFormat:@"all%@", pluralizedName];
    NSString *storageFile = [directory stringByAppendingFormat:@"%@.plist", pluralizedPropertyName];
    NSDictionary * rootObject = [NSDictionary dictionaryWithObject:data forKey:@"root"];
    
    //Archieve it
    BOOL success = [NSKeyedArchiver archiveRootObject:rootObject toFile:storageFile];
    if (success)
    {
        NSDictionary* attributeDict = [[NSFileManager defaultManager] attributesOfItemAtPath:storageFile error:nil];
        NSNumber* fileSizeObj = [attributeDict objectForKey:NSFileSize];
        long long fileSizeVal = [fileSizeObj longLongValue] / 1024;
        DLog(@"Cached %@ to file (%lldKB)", pluralizedName, fileSizeVal);
    }
    else
    {
        DLog(@"Failed to cached %@ to file (%@)", pluralizedName, storageFile);
    }
    
    return success;
}

- (BOOL)restoreOfflineAllClassObjects:(Class)classObject directory:(NSString*)directory
{
    //Storage path
    NSString *pluralizedName = [NSStringFromClass(classObject) pluralizeString];
    NSString *pluralizedPropertyName = [NSString stringWithFormat:@"all%@", pluralizedName];
    NSString *storageFile = [directory stringByAppendingFormat:@"%@.plist", pluralizedPropertyName];
    
    //Check exists
    NSError *error;
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];
    if (error != nil || [dirContents count] <= 0)
        return NO;
    
    //Sanity check
    NSDictionary * rootObject = [NSKeyedUnarchiver unarchiveObjectWithFile:storageFile];
    id root = [rootObject valueForKey:@"root"];
    if (root == nil)
        return NO;
    
    //Convert from non-mutable to mutable
    if ([root isKindOfClass:[NSMutableDictionary class]] == NO && [root isKindOfClass:[NSDictionary class]] == YES)
        root = [root mutableCopy];
    
    BOOL success = [self setDictionaryForAllClassObject:classObject data:root];
    if (success == NO)
        return NO;
    
    if (root != nil)
    {
        //Get filesize
        NSDictionary* attributeDict = [[NSFileManager defaultManager] attributesOfItemAtPath:storageFile error:nil];
        NSNumber* fileSizeObj = [attributeDict objectForKey:NSFileSize];
        long long fileSizeBytes = [fileSizeObj longLongValue];
        long long fileSizeKBytes = fileSizeBytes / 1024;
        if (fileSizeBytes < 1024)   DLog(@"Restored %@ from file (%lld Bytes)", pluralizedName, fileSizeBytes);
        else                        DLog(@"Restored %@ from file (%lld KBytes)", pluralizedName, fileSizeKBytes);
    }
    
    return YES;
}



#pragma mark - Single Object Store

- (void)setObject:(id)object forKey:(NSString *)key
{
    if ([key length] == 0)
        return;
    
    if (!object) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    
    NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:object];
    
    [[NSUserDefaults standardUserDefaults] setObject:archivedData forKey:key];
}

- (id)objectForKey:(NSString *)key
{
    if ([key length] == 0)
        return nil;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - Store Data To Disk

- (NSString *)pathForDataFile:(NSString *)fileName
{
    NSArray *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = nil; 	
    if (documentDir) {
        path = [documentDir lastObject];
    } 	
    return [NSString stringWithFormat:@"%@/%@", path, fileName];
}

- (void)storeDataToDisk:(id)object withFileName:(NSString *)fileName
{
    NSString * path = [self pathForDataFile:fileName];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [NSKeyedArchiver archiveRootObject:data toFile:path];
}

- (id)getDataFromDiskWithFileName:(NSString *)fileName
{
    NSString * path = [self pathForDataFile:fileName];
    NSData *data = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
