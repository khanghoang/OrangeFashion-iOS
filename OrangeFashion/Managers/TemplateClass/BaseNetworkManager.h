//
//  NetworkManager.h
//  TemplateProject
//
//  Created by Torin on 14/2/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <Foundation/Foundation.h>


#define GET_METHOD              @"GET"
#define POST_METHOD             @"POST"
#define PUT_METHOD              @"PUT"
#define DELETE_METHOD           @"DELETE"

@interface BaseNetworkManager : BaseManager

/*
 * Construct a dictionary with common parameters, including authentication token
 */
- (NSMutableDictionary*)getAuthParams;

/*
 * Construct full server Url for a given relative path
 */
- (NSString*)getServerAPIPathWithPrefix:(NSString*)path;

- (BOOL)handleServerError:(NSDictionary*)json
                 response:(NSHTTPURLResponse*)response
                  failure:(void (^)(NSError *error))failure;

/*
 * Simplify handling of AFJSONRequestOperation & generic server error
 */
- (void)sendRequestForPath:(NSString*)path
                parameters:(NSDictionary*)parameters
                    method:(NSString*)method
                   success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                   failure:(void (^)(NSError *error))failure;

- (void)sendMultipartFormRequestForPath:(NSString*)path
                             parameters:(NSDictionary*)parameters
                                 method:(NSString*)method
              constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block
                                success:(void (^)(NSHTTPURLResponse *response, id responseObject))success
                                failure:(void (^)(NSError *error))failure;


//Generic list

- (void)getServerListForModelClass:(Class)classObject
                           success:(void (^)(NSMutableArray *objectsArray))success
                           failure:(void (^)(NSError *error))failure;

- (void)getServerListForModelClass:(Class)classObject
                        withParams:(NSDictionary *)params
                           success:(void (^)(NSMutableArray *objectsArray))success
                           failure:(void (^)(NSError *error))failure;

- (void)getServerListForModelClass:(Class)classObject
                        withParams:(NSDictionary *)params
                         methodAPI:(NSString *)methodAPI
                           success:(void (^)(NSMutableArray *objectsArray))success
                           failure:(void (^)(NSError *error))failure;

- (void)getServerListForModelClass:(Class)classObject
                        withParams:(NSDictionary *)params
                         methodAPI:(NSString *)methodAPI
                          parentId:(NSNumber*)parentId
                   withParentClass:(Class)parentClassObject
                           success:(void (^)(NSMutableArray *objectsArray))success
                           failure:(void (^)(NSError *error))failure;


//Generic data model object

- (void)getServerModelForModelClass:(Class)classObject
                                 keyId:(NSNumber*)keyId
                            success:(void (^)(id dataModelObject))success
                            failure:(void (^)(NSError *error))failure;

- (void)getServerModelForModelClass:(Class)classObject
                              keyId:(NSNumber*)keyId
                         withParams:(NSDictionary *)params
                            success:(void (^)(id dataModelObject))success
                            failure:(void (^)(NSError *error))failure;

- (void)getServerModelForModelClass:(Class)classObject
                                 keyId:(NSNumber*)keyId
                         withParams:(NSDictionary *)params
                           parentId:(NSNumber*)parentId
                    withParentClass:(Class)parentClassObject
                            success:(void (^)(id dataModelObject))success
                            failure:(void (^)(NSError *error))failure;

- (void)getServerModelForModelClass:(Class)classObject
                              keyId:(NSNumber*)keyId
                         withParams:(NSDictionary *)params
                          methodAPI:(NSString *)methodAPI
                           parentId:(NSNumber*)parentId
                    withParentClass:(Class)parentClassObject
                            success:(void (^)(id dataModelObject))success
                            failure:(void (^)(NSError *error))failure;

- (void)addOrUpdateServerModelForModel:(id)modelObject
                               success:(void (^)(id dataModelObject))success
                               failure:(void (^)(NSError *error))failure;

- (void)deleteServerModelForModel:(id)modelObject
                          success:(void (^)(BOOL success))success
                          failure:(void (^)(NSError *error))failure;


//Download large file

- (void)downloadRemoteFile:(NSString *)url
               toLocalPath:(NSString *)localPath
                  progress:(void (^)(CGFloat percent, long long bytesDownloaded, long long totalBytesExpected, AFDownloadRequestOperation *operation))progress
                   success:(void (^)(NSString *localPath))success
                   failure:(void (^)(NSError *error))failure;

@end
