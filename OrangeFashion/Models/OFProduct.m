#define STORE_PRODUCT_BOOKMARK          @"bookmark_products"

#import "OFProduct.h"

@implementation OFProduct

#pragma mark - Helper methods

+ (OFProduct *)productWithDictionary:(NSDictionary *)dictionary
{
    // look for the core data first
    OFProduct *product = [[OFProduct MR_findByAttribute:@"product_id" withValue:dictionary[@"MaSanPham"]] lastObject];
    
    if (!product && ![dictionary[@"MaSanPham"] isKindOfClass:[NSNull class]]) {
        product = [OFProduct MR_createEntity];
        
        NSString *product_id_str = (NSString *)dictionary[@"MaSanPham"];
        product.product_id = [NSNumber numberWithInt:[product_id_str intValue]];
        
        product.name = dictionary[@"TenSanPham"];
        product.price = dictionary[@"GiaBan"];
        product.material = dictionary[@"ChatLieu"];
        product.colors = dictionary[@"Mau"];
        product.product_code = dictionary[@"MaHienThi"];
        
    }    
    return product;
}

#pragma mark - Get product details from server

+ (void)getProductsWithCategoryID:(NSInteger)category_id onSuccess:(OFJSONRequestSuccessBlock)successBlock failure:(OFJSONRequestFailureBlock)failureBlock
{
    NSDictionary *params = @{
                             @"rquest"          : @"getProductsFromCategory",
                             @"category_id"     : [NSNumber numberWithInteger:category_id]
                             };
    
    [[OFHTTPClient sharedClient] getPath:API_SERVER_HOST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {        
        
        [OFProduct productsFromReponseObject:responseObject];
        
        if (successBlock) {
            successBlock(operation.response.statusCode, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failureBlock) {
            failureBlock(operation.response.statusCode, error);
        }
    }];
}

+ (void)getProductsOnSuccess:(OFJSONRequestSuccessBlock)successBlock failure:(OFJSONRequestFailureBlock)failureBlock
{
    NSDictionary *params = @{@"rquest": @"getproducts"};
    [[OFHTTPClient sharedClient] getPath:API_SERVER_HOST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [OFProduct productsFromReponseObject:responseObject];
        
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

- (void)getImagesForProductOnSuccess:(OFJSONRequestSuccessBlock)successBlock failure:(OFJSONRequestFailureBlock)failureBlock
{
    [OFProductImages getImagesForProduct:self successBlock:^(NSInteger statusCode, id obj){
        NSArray *imgsArr = (NSArray *)obj;
        [imgsArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self addImagesObject:obj];
        }];
        
        if (successBlock) {
            successBlock(statusCode, self);
        }
        
    } failureBlock:^(NSInteger statusCode, id obj) {
        
        // set offline data from coredata
        OFProduct *product = [[OFProduct MR_findByAttribute:@"product_id" withValue:self.product_id] lastObject];
        
        if (product&&successBlock) {
            successBlock(statusCode, product);
        }
        
        //Hanlder when failure
        if (failureBlock) {
            failureBlock(statusCode, obj);
        }
        
    }];
}

#pragma mark - Helpers

+ (void)productsFromReponseObject:(id)responseObject
{
    NSMutableArray *arrProduct = [[NSMutableArray alloc] init];
    
    NSBlockOperation *saveInBackground = [NSBlockOperation blockOperationWithBlock:^{
        [responseObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            OFProduct *product = [OFProduct MR_createEntity];
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

+ (void)saveBookmarkProductWithArray:(NSArray *)array
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:array forKey:STORE_PRODUCT_BOOKMARK];
    [userDefault synchronize];
}

+ (void)saveBookmarkProductWithMutableArray:(NSMutableArray *)array
{
    [self saveBookmarkProductWithArray:array];
}

+ (NSMutableArray *)getBookmarkProducts
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSMutableArray *arr = [[userDefault objectForKey:STORE_PRODUCT_BOOKMARK] mutableCopy];
    
    if (arr) {
        return arr;
    }
    
    return [[NSMutableArray alloc] init];
}

+ (void)removeBookmarkProductWithProductID:(NSNumber *)productID
{
    NSMutableArray *bookmarkedProducts = [OFProduct getBookmarkProducts];
    int count = bookmarkedProducts.count;
    for (int i = 0; i < count; i++) {
        NSNumber *bookmarkedProductID = [bookmarkedProducts objectAtIndex:i];
        if ([bookmarkedProductID integerValue] == [productID integerValue])
            [bookmarkedProducts removeObject:bookmarkedProductID];
    }
    
    [OFProduct saveBookmarkProductWithArray:bookmarkedProducts];
}

+ (void)bookmarkProductWithProduct:(OFProduct *)product
{
    NSNumber *productID = product.product_id;
    [self bookmarkProductWithProductID:productID];
}

+ (void)bookmarkProductWithProductID:(NSNumber *)productID
{
    NSMutableArray *bookmarkProducts = [self getBookmarkProducts];
    
    if ([OFProduct isBookmarkedAlreadyWithProductID:productID])
        return;
    [bookmarkProducts addObject:productID];
    [self saveBookmarkProductWithMutableArray:bookmarkProducts];
}

+ (BOOL)isBookmarkedAlreadyWithProductID:(NSNumber *)productID
{
    NSMutableArray *bookmarkProducts = [OFProduct getBookmarkProducts];
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
