#import "_OFProduct.h"

@interface OFProduct : _OFProduct {}
// Custom logic goes here.

+ (OFProduct *)productWithDictionary: (NSDictionary *)dictionary;

+ (void)getProductsOnSuccess:(OFJSONRequestSuccessBlock)successBlock
                     failure:(OFJSONRequestFailureBlock)failureBlock;
+ (void)getProductsWithCategoryID:(NSInteger)category_id
                        onSuccess:(OFJSONRequestSuccessBlock)successBlock
                          failure:(OFJSONRequestFailureBlock)failureBlock;

@end
