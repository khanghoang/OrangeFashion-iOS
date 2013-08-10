//
//  OFProductManager.h
//  OrangeFashion
//
//  Created by Khang on 30/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "BaseManager.h"

static NSString * STORE_PRODUCT_ID          = @"bookmark_product_id";
static NSString * STORE_PRODUCT_NUMBER      = @"bookmark_product_number";
 
@interface OFProductManager : BaseManager

- (OFProduct *)productWithProductID:(NSInteger)productID;
- (void)getProductsOnSuccess:(OFJSONRequestSuccessBlock)successBlock
                     failure:(OFJSONRequestFailureBlock)failureBlock;
- (void)getProductsWithCategoryID:(NSInteger)category_id
                        onSuccess:(OFJSONRequestSuccessBlock)successBlock
                          failure:(OFJSONRequestFailureBlock)failureBlock;

// Bookmark
- (BOOL)isBookmarkedAlreadyWithProductID:(NSNumber *)productID;
- (void)removeBookmarkProductWithProductID:(NSNumber *)productID;

- (void)bookmarkProductWithProductID:(NSNumber *)productID;
- (void)bookmarkProductWithProductID:(NSNumber *)productID withNumber:(NSInteger)number;
- (void)updateProductWithProductID:(NSNumber *)productID withNumber:(NSInteger)number;

- (NSMutableArray *)getBookmarkProducts;

@end
