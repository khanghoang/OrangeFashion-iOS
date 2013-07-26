#import "_OFProduct.h"

@interface OFProduct : _OFProduct {}

+ (OFProduct *)productWithDictionary: (NSDictionary *)dictionary;

+ (void)getProductsOnSuccess:(OFJSONRequestSuccessBlock)successBlock
                     failure:(OFJSONRequestFailureBlock)failureBlock;
+ (void)getProductsWithCategoryID:(NSInteger)category_id
                        onSuccess:(OFJSONRequestSuccessBlock)successBlock
                          failure:(OFJSONRequestFailureBlock)failureBlock;

// Bookmark
+ (void)removeBookmarkProductWithProductID:(NSNumber *)productID;
+ (void)bookmarkProductWithProductID:(NSNumber *)productID;
+ (NSMutableArray *)getBookmarkProducts;

@end
