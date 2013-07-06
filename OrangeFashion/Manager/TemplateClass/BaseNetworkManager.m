//
//  NetworkManager.m
//  TemplateProject
//
//  Created by Torin on 14/2/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import "BaseNetworkManager.h"

@interface BaseNetworkManager()
@property (nonatomic, strong) AFHTTPClient *httpClient;     //singleton
@end


@implementation BaseNetworkManager

SINGLETON_MACRO

- (id)init
{
  self = [super init];
  if (self == nil)
    return self;
  
  NSURL *baseURL = [NSURL URLWithString:API_SERVER_HOST];
  self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
  
  [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
  
  return self;
}


#pragma mark - Private helpers

/*
 * Convenient function to handle server error directly from JSON
 * Return YES if there is an error; calling function should return immediately
 */
- (BOOL)handleServerError:(NSDictionary*)json response:(NSHTTPURLResponse*)response failure:(void (^)(NSError *error))failure
{
  BOOL successCode = response.statusCode > 200 && response.statusCode <= 299;
  if (successCode)
    return NO;
  
  if ([json isKindOfClass:[NSDictionary class]] == YES)
  {
    id errors = [json objectForKey:@"errors"];
    if (errors != nil) {
      if (failure)
        failure([[NSError alloc] initWithDomain:@"" code:response.statusCode userInfo:json]);
      return YES;
    }
    
    return NO;
  }
  
  //Most generic API returns an array of models, or simple API returns array of strings/numbers
  if ([json isKindOfClass:[NSArray class]] == YES)
    return NO;
  
  //Else
  if (failure) {
    failure([[NSError alloc] initWithDomain:@"" code:response.statusCode userInfo:json]);
    return YES;
  }
  
  return NO;
}

- (NSMutableDictionary*)getAuthParams
{
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  return nil;
  
//  //client_id
//  NSString *client_id = [[BaseStorageManager sharedInstance] getSettingStringValueWithKey:SETTINGS_CLIENT_ID
//                                                                             defaultValue:SETTINGS_CLIENT_ID_DEFAULT];
//  if ([client_id length] > 0)
//    [dict setObject:client_id forKey:@"client_id"];
//  
//  //client_secret
//  NSString *client_secret = [[BaseStorageManager sharedInstance] getSettingStringValueWithKey:SETTINGS_CLIENT_SECRET
//                                                                                 defaultValue:SETTINGS_CLIENT_SECRET_DEFAULT];
//  if ([client_secret length] > 0)
//    [dict setObject:client_secret forKey:@"client_secret"];
//  
//  
//  //access_token
//  NSString *access_token = [[EGCUserManager sharedInstance] getAccessToken];
//  if ([access_token length] > 0)
//    [dict setObject:access_token forKey:@"access_token"];
//  
//  return dict;
}

- (NSString*)getServerAPIPathWithPrefix:(NSString*)path
{
  if ([path hasPrefix:@"http"] || [path hasPrefix:@"/"])        //we need this because /oauth/token is not within /api/v1 namespace
    return path;
    
  NSString *fullPath = [API_PREFIX stringByAppendingPathComponent:path];
  
  return fullPath;
}

- (NSString*)getServerClassNameForClassObject:(Class)classObject
{
  //Lowercase, remove EGC prefix
  NSString *className = [NSStringFromClass(classObject) lowercaseString];
  className = [className substringFromIndex:CLASS_PREFIX_LENGTH];
  
  return className;
}

- (NSString*)getPluralizedClassNameForClassObject:(Class)classObject
{
  //Lowercase, remove EGC prefix
  NSString *className = [NSStringFromClass(classObject) lowercaseString];
  className = [className substringFromIndex:CLASS_PREFIX_LENGTH];
  
  //Pluralize
  if ([className isEqualToString:@"country"])     return @"countries";
  if ([className isEqualToString:@"city"])        return @"cities";
  if ([className isEqualToString:@"dish"])        return @"dishes";
  
  return [NSString stringWithFormat:@"%@s", className];
}

- (NSString*)getServerListAPIStringForClass:(Class)classObject
{
  return [self getServerListAPIStringForClass:classObject withParentId:nil withParentClass:nil];
}

- (NSString*)getServerListAPIStringForClass:(Class)classObject withParentId:(NSNumber*)parentId withParentClass:(Class)parentClassObject
{  
  return [self getServerModelAPIStringForClass:classObject withParentId:parentId withParentClass:parentClassObject withId:nil];
}

- (NSString*)getServerModelAPIStringForClass:(Class)classObject withId:(NSNumber*)keyId
{
  return [self getServerModelAPIStringForClass:classObject withParentId:nil withParentClass:nil withId:keyId];
}

- (NSString*)getServerModelAPIStringForClass:(Class)classObject withParentId:(NSNumber*)parentId withParentClass:(Class)parentClassObject withId:(NSNumber*)keyId
{
  NSString *className = [[self getServerClassNameForClassObject:classObject] lowercaseString];
  NSString *pluralizedClassName = [className pluralizeString];
  
  if ([pluralizedClassName isEqualToString:@"settings"])
    pluralizedClassName = @"key_value_settings";
  
  NSString *apiString;  
  if (parentClassObject) {
    NSString *parentClassName = [[self getServerClassNameForClassObject:parentClassObject] lowercaseString];
    NSString *parentPluralizedClassName = [parentClassName pluralizeString];
    if (parentId)
      apiString = [NSString stringWithFormat:@"%@/%@/%d/%@", API_PREFIX, parentPluralizedClassName, parentId.intValue, pluralizedClassName];
    else
      apiString = [NSString stringWithFormat:@"%@/%@/%@", API_PREFIX, parentPluralizedClassName, pluralizedClassName];
  } else {
    apiString = [NSString stringWithFormat:@"%@/%@", API_PREFIX, pluralizedClassName];
  }
  
  if (keyId)
      apiString = [NSString stringWithFormat:@"%@/%@", apiString, keyId];
  
  return apiString;
}

- (void)sendRequest:(NSURLRequest *)request
            success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
            failure:(void (^)(NSError *error))failure
{
  AFJSONRequestOperation *operation =
  [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
    
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    
    BOOL hasError = [self handleServerError:json response:response failure:failure];
    if (hasError)
      return;
    
    if (success)
      success(response, json);
    
  } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id responseObject) {
    
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    
    //Check if is valid error
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      BOOL hasError = [self handleServerError:responseObject response:response failure:failure];
      if (hasError)
        return;
    }
    
    DLog(@"%@", [response allHeaderFields]);
    DLog(@"%@", responseObject);
    if (failure)
      failure(error);

  }];
  
  [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
  [self.httpClient enqueueHTTPRequestOperation:operation];
}

- (void)sendRequestForPath:(NSString*)path
                parameters:(NSDictionary*)parameters
                    method:(NSString*)method
                   success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                   failure:(void (^)(NSError *error))failure
{
  NSMutableDictionary *params = [self getAuthParams];
  if ([parameters count] > 0)
    [params addEntriesFromDictionary:parameters];
  
  if ([method length] <= 0)
    method = GET_METHOD;
  
  NSString *fullPath = [self getServerAPIPathWithPrefix:path];
  NSMutableURLRequest *request = [self.httpClient requestWithMethod:method path:fullPath parameters:params];
  [self sendRequest:request success:success failure:failure];
}

- (void)sendMultipartFormRequestForPath:(NSString*)path
                             parameters:(NSDictionary*)parameters
                                 method:(NSString*)method
              constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                                success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                                failure:(void (^)(NSError *error))failure
{
  if ([method length] <= 0)
    method = POST_METHOD;
  
  NSString *fullPath = [self getServerAPIPathWithPrefix:path];
  NSMutableURLRequest *request = [self.httpClient multipartFormRequestWithMethod:method
                                                                            path:fullPath
                                                                      parameters:parameters
                                                       constructingBodyWithBlock:block];
  [self sendRequest:request success:success failure:failure];
}



#pragma mark - Generic

- (void)getServerListForModelClass:(Class)classObject
                           success:(void (^)(NSMutableArray *objectsArray))success
                           failure:(void (^)(NSError *error))failure
{
  [self getServerListForModelClass:classObject withParams:nil methodAPI:nil parentId:nil withParentClass:nil success:success failure:failure];
}

- (void)getServerListForModelClass:(Class)classObject
                        withParams:(NSDictionary *)params
                           success:(void (^)(NSMutableArray *objectsArray))success
                           failure:(void (^)(NSError *error))failure
{
  [self getServerListForModelClass:classObject withParams:params methodAPI:nil parentId:nil withParentClass:nil success:success failure:failure];
}

- (void)getServerListForModelClass:(Class)classObject
                        withParams:(NSDictionary *)params
                         methodAPI:(NSString *)methodAPI
                           success:(void (^)(NSMutableArray *objectsArray))success
                           failure:(void (^)(NSError *error))failure
{
  [self getServerListForModelClass:classObject withParams:params methodAPI:methodAPI parentId:nil withParentClass:nil success:success failure:failure];
}


- (void)getServerListForModelClass:(Class)classObject
                        withParams:(NSDictionary *)params
                         methodAPI:(NSString *)methodAPI
                          parentId:(NSNumber *)parentId
                   withParentClass:(Class)parentClassObject
                           success:(void (^)(NSMutableArray *objectsArray))success
                           failure:(void (^)(NSError *error))failure
{
  //Parameters
  NSMutableDictionary *parameters = [self getAuthParams];
  if ([params count] > 0)
    [parameters addEntriesFromDictionary:params];
  if ([parameters count] <= 0)
    parameters = nil;

  //Path
  NSString *path = [self getServerListAPIStringForClass:classObject withParentId:parentId withParentClass:parentClassObject];
  if ([methodAPI length] > 0) {
    NSMutableString *newPath = [[NSMutableString alloc] initWithString:path];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"/([^/]+)?$" options:NSRegularExpressionCaseInsensitive error:nil];
    [regex replaceMatchesInString:newPath options:0 range:NSMakeRange(0, [path length]) withTemplate:methodAPI];
    path = [newPath copy];
  }
  
  NSMutableURLRequest *request = [self.httpClient requestWithMethod:GET_METHOD path:path parameters:parameters];
  
  [self sendRequest:request success:^(NSHTTPURLResponse *response, id responseObject) {
      
    //Some listing API contains other metadata besides the raw array
    NSArray *rawArray = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]] == YES)
    {
      NSString *keyToLookFor = [self getPluralizedClassNameForClassObject:classObject];
      id arr = [responseObject objectForKey:keyToLookFor];
      if (arr != nil)
        rawArray = arr;
    }
    else
    {
      rawArray = (NSArray*)responseObject;
    }
    
    //Crazy generic code to convert raw dictionary to proper model
    NSMutableArray *outputArray = [NSMutableArray array];
    for (NSDictionary *dict in rawArray)
    {
      id model = [[BaseStorageManager sharedInstance] addOrUpdateClassModel:classObject
                                                            withDictionary:dict];
      if (model)
        [outputArray addObject:model];
    }
    
    if (success)
      success(outputArray);
    
  } failure:failure];  
}


- (void)getServerModelForModelClass:(Class)classObject
                              keyId:(NSNumber*)keyId
                            success:(void (^)(id dataModelObject))success
                            failure:(void (^)(NSError *error))failure
{
  [self getServerModelForModelClass:classObject keyId:keyId withParams:nil methodAPI:nil parentId:nil withParentClass:nil success:success failure:failure];
}

- (void)getServerModelForModelClass:(Class)classObject
                              keyId:(NSNumber*)keyId
                         withParams:(NSDictionary *)params
                            success:(void (^)(id dataModelObject))success
                            failure:(void (^)(NSError *error))failure
{
  [self getServerModelForModelClass:classObject keyId:keyId withParams:params methodAPI:nil parentId:nil withParentClass:nil success:success failure:failure];
}

- (void)getServerModelForModelClass:(Class)classObject
                              keyId:(NSNumber*)keyId
                         withParams:(NSDictionary *)params
                           parentId:(NSNumber*)parentId
                    withParentClass:(Class)parentClassObject
                            success:(void (^)(id dataModelObject))success
                            failure:(void (^)(NSError *error))failure
{
  [self getServerModelForModelClass:classObject keyId:keyId withParams:params methodAPI:nil parentId:parentId withParentClass:parentClassObject success:success failure:failure];
}

- (void)getServerModelForModelClass:(Class)classObject
                                 keyId:(NSNumber*)keyId
                         withParams:(NSDictionary *)params
                          methodAPI:(NSString *)methodAPI
                          parentId:(NSNumber*)parentId
                    withParentClass:(Class)parentClassObject
                           success:(void (^)(id dataModelObject))success
                           failure:(void (^)(NSError *error))failure
{
  //Parameters
  NSMutableDictionary *parameters = [self getAuthParams];
  if ([params count] > 0)
    [parameters addEntriesFromDictionary:params];
  if ([parameters count] <= 0)
    parameters = nil;
  
  //Path
  NSString *path = nil;
  if ([methodAPI length] > 0)   path = [NSString stringWithFormat:@"%@/%@", [self getServerModelAPIStringForClass:classObject withId:keyId], methodAPI];
  else                          path = [self getServerModelAPIStringForClass:classObject withParentId:parentId withParentClass:parentClassObject withId:keyId];

  NSMutableURLRequest *request = [self.httpClient requestWithMethod:GET_METHOD path:path parameters:parameters];
  
  [self sendRequest:request success:^(NSHTTPURLResponse *response, id responseObject) {
    
    NSDictionary *rawDictionary = (NSDictionary*)responseObject;
    
    //Crazy generic code to convert raw dictionary to proper model
    id model = [[BaseStorageManager sharedInstance] addOrUpdateClassModel:classObject
                                                          withDictionary:rawDictionary];
    
    DLog(@"Data model object %@ updated", path);
    
    if (success)
      success(model);
    
  } failure:failure];
}

- (void)addOrUpdateServerModelForModel:(id)modelObject
                               success:(void (^)(id dataModelObject))success
                               failure:(void (^)(NSError *error))failure
{
  NSMutableDictionary *params = [self getAuthParams];
  [params addEntriesFromDictionary:[modelObject toDictionary]];
  
  NSNumber *keyID = nil;
  if ([modelObject respondsToSelector:@selector(ID)])
    keyID = [modelObject valueForKey:@"ID"];
  
  NSString *path = nil;
  NSString *method = POST_METHOD;
  if ([keyID integerValue] > 0) {
    method = PUT_METHOD;
    path = [self getServerModelAPIStringForClass:[modelObject class] withId:keyID];
  }else {
    method = POST_METHOD;
    path = [self getServerListAPIStringForClass:[modelObject class]];
  }
  
  NSMutableURLRequest *request = [self.httpClient requestWithMethod:method path:path parameters:params];
  
  [self sendRequest:request success:^(NSHTTPURLResponse *response, id responseObject) {
      
    NSDictionary *rawDictionary = (NSDictionary*)responseObject;
    
    //Crazy generic code to convert raw dictionary to proper model
    id model = [[BaseStorageManager sharedInstance] addOrUpdateClassModel:[modelObject class]
                                                           withDictionary:rawDictionary];
    
    if ([keyID integerValue] > 0)    DLog(@"Data model object %@ updated", path);
    else                             DLog(@"Data model object %@ added", model);
    
    if (success)
      success(model == nil ? modelObject : model);
    
  } failure:failure];
}

- (void)deleteServerModelForModel:(id)modelObject
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *error))failure
{
  NSNumber *keyID = nil;
  if ([modelObject respondsToSelector:@selector(ID)])
    keyID = [modelObject valueForKey:@"ID"];

  NSString *path = [self getServerModelAPIStringForClass:[modelObject class] withId:keyID];
  
  NSMutableDictionary * params = [self getAuthParams];

  NSMutableURLRequest *request = [self.httpClient requestWithMethod:DELETE_METHOD path:path parameters:params];
  
  [self sendRequest:request success:^(NSHTTPURLResponse *response, id responseObject) {
    
    DLog(@"Data model object %@ deleted", responseObject);
    
    if (success)
      success(YES);
    
  } failure:failure];
}



#pragma mark - Download large file

- (void)downloadRemoteFile:(NSString *)url
               toLocalPath:(NSString *)targetPath
                  progress:(void (^)(CGFloat percent, long long bytesDownloaded, long long totalBytesExpected, AFDownloadRequestOperation *operation))progress
                   success:(void (^)(NSString *localPath))success
                   failure:(void (^)(NSError *error))failure
{
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];

  if ([targetPath length] <= 0) {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    targetPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[url md5]];
  }
  DLog(@"Target Path: %@", targetPath);
//  DLog(@"Incomplete/Partial Path: %@", [AFDownloadRequestOperation tempPathWithTargetPath:targetPath]);
  
  
  AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:targetPath shouldResume:YES];
  operation.shouldOverwrite = YES;
  
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    DLog(@"Successfully downloaded file to %@", targetPath);
    if (success)
      success(targetPath);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    DLog(@"Error: %@", error);
    if (failure)
      failure(error);
  }];
  
  //Progress indicator
  [operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile)
   {
     CGFloat progressNumber = (CGFloat)totalBytesRead / (CGFloat)totalBytesExpected;
     if (progressNumber > 1)
       progressNumber = 1;
     
     if (progress)
       progress(progressNumber, totalBytesReadForFile, totalBytesExpectedToReadForFile, operation);
   }];
  
  [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
  [self.httpClient enqueueHTTPRequestOperation:operation];
}


@end
