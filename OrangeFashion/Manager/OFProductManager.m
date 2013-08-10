//
//  OFProductManager.m
//  OrangeFashion
//
//  Created by Khang on 30/6/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFProductManager.h"

static NSString * STORE_PRODUCT_BOOKMARK = @"bookmark_products";

@implementation OFProductManager

SINGLETON_MACRO

#pragma mark - Get product details from server

- (OFProduct *)productWithProductID:(NSInteger)productID
{
    // look for the core data first
    OFProduct *product = [[OFProduct MR_findByAttribute:@"product_id" withValue:@(productID)] lastObject];
    
    return product;
}

- (void)getProductsWithCategoryID:(NSInteger)category_id onSuccess:(OFJSONRequestSuccessBlock)successBlock failure:(OFJSONRequestFailureBlock)failureBlock
{
    NSDictionary *params = @{
                             @"rquest"          : @"getProductsFromCategory",
                             @"category_id"     : [NSNumber numberWithInteger:category_id]
                             };
    
    [[OFHTTPClient sharedClient] getPath:API_SERVER_HOST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[OFProductManager sharedInstance] productsFromReponseObject:responseObject];
        
        if (successBlock) {
            successBlock(operation.response.statusCode, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSArray *arr = [self getStoredProductsWithCategoryId:category_id];
        if (arr.count > 0) {
            successBlock(operation.response.statusCode, arr);
        }
        
        if (failureBlock) {
            failureBlock(operation.response.statusCode, error);
        }
    }];
}

- (NSArray *)getStoredProductsWithCategoryId:(NSInteger)category_id
{
    NSNumber *catID = @(category_id);
    NSArray *arrProducts = [[NSArray alloc] init];
    
    // if new arrived
    if (category_id == 21) {
        arrProducts = [OFProduct MR_findAllSortedBy:@"public_date" ascending:NO];
        return arrProducts;
    }
    
    arrProducts = [OFProduct MR_findByAttribute:@"category_id" withValue:catID];
    return arrProducts;
}

- (void)getProductsOnSuccess:(OFJSONRequestSuccessBlock)successBlock failure:(OFJSONRequestFailureBlock)failureBlock
{
    NSDictionary *params = @{@"rquest": @"getproducts"};
    [[OFHTTPClient sharedClient] getPath:API_SERVER_HOST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[OFProductManager sharedInstance] productsFromReponseObject:responseObject];
        
        if (successBlock) {
            successBlock(operation.response.statusCode, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSArray *arrProduct = [OFProduct MR_findAll];
        
        if (arrProduct.count > 0 && successBlock) {
            successBlock(operation.response.statusCode, arrProduct);
        }
        
        if (failureBlock) {
            failureBlock(operation.response.statusCode, error);
        }
        
    }];
}

#pragma mark - Helpers

- (void)productsFromReponseObject:(id)responseObject
{
    NSMutableArray *arrProduct = [[NSMutableArray alloc] init];
    
    NSBlockOperation *saveInBackground = [NSBlockOperation blockOperationWithBlock:^{
        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            OFProduct *product;
            product = [OFProduct productWithDictionary:obj];
            [arrProduct addObject:product];
        }];
    }];
    
    [saveInBackground setCompletionBlock:^{
        NSManagedObjectContext *mainContext  = [NSManagedObjectContext MR_defaultContext];
        [mainContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            DLog(@"Finish save to magical record");
        }];
    }];
    
    [saveInBackground start];
}

#pragma mark - Store and get bookmark products

- (void)saveBookmarkProductWithArray:(NSArray *)array
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:array forKey:STORE_PRODUCT_BOOKMARK];
    [userDefault synchronize];
}

- (void)saveBookmarkProductWithMutableArray:(NSMutableArray *)array
{
    [self saveBookmarkProductWithArray:array];
}

- (NSMutableArray *)getBookmarkProducts
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[userDefault objectForKey:STORE_PRODUCT_BOOKMARK] mutableCopy];
    
    if (arr) {
        return arr;
    }
    
    return [[NSMutableArray alloc] init];
}

- (void)removeBookmarkProductWithProductID:(NSNumber *)productID
{
    NSMutableArray *bookmarkedProducts = [self getBookmarkProducts];
    for (int i = 0; i < bookmarkedProducts.count; i++) {
        NSNumber *bookmarkedProductID = [bookmarkedProducts objectAtIndex:i];
        if ([bookmarkedProductID integerValue] == [productID integerValue])
            [bookmarkedProducts removeObject:bookmarkedProductID];
    }
    
    [self saveBookmarkProductWithArray:bookmarkedProducts];
}

- (void)bookmarkProductWithProduct:(OFProduct *)product
{
    NSNumber *productID = product.product_id;
    [self bookmarkProductWithProductID:productID];
}

- (void)bookmarkProductWithProductID:(NSNumber *)productID
{
    NSMutableArray *bookmarkProducts = [self getBookmarkProducts];
    
    if ([self isBookmarkedAlreadyWithProductID:productID])
        return;
    [bookmarkProducts addObject:productID];
    [self saveBookmarkProductWithMutableArray:bookmarkProducts];
}

- (BOOL)isBookmarkedAlreadyWithProductID:(NSNumber *)productID
{
    NSMutableArray *bookmarkProducts = [self getBookmarkProducts];
    int count = bookmarkProducts.count;
    
    for (int i = 0; i < count; i++) {
        NSNumber *product = [bookmarkProducts objectAtIndex:i];
        if ([productID integerValue] == [product integerValue]) {
            return YES;
        }
    }
    
    return NO;
}

@end
