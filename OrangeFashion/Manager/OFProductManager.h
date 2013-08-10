//
//  OFProductManager.h
//  OrangeFashion
//
//  Created by Khang on 30/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "BaseManager.h"
 
@interface OFProductManager : BaseManager

- (void)getProductsOnSuccess:(OFJSONRequestSuccessBlock)successBlock
                     failure:(OFJSONRequestFailureBlock)failureBlock;
- (void)getProductsWithCategoryID:(NSInteger)category_id
                        onSuccess:(OFJSONRequestSuccessBlock)successBlock
                          failure:(OFJSONRequestFailureBlock)failureBlock;

// Bookmark
- (BOOL)isBookmarkedAlreadyWithProductID:(NSNumber *)productID;
- (void)removeBookmarkProductWithProductID:(NSNumber *)productID;
- (void)bookmarkProductWithProductID:(NSNumber *)productID;
- (NSMutableArray *)getBookmarkProducts;

@end
