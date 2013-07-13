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
        successBlock(operation.response.statusCode, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(operation.response.statusCode, error);
    }];
}

+ (void)getProductsOnSuccess:(OFJSONRequestSuccessBlock)successBlock failure:(OFJSONRequestFailureBlock)failureBlock
{
    NSDictionary *params = @{@"rquest": @"getproducts"};
    [[OFHTTPClient sharedClient] getPath:API_SERVER_HOST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        successBlock(operation.response.statusCode, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock(operation.response.statusCode, error); 
    }];
}

- (void)getImagesForProductOnSuccess:(OFJSONRequestSuccessBlock)successBlock failure:(OFJSONRequestFailureBlock)failureBlock
{
    [OFProductImages getImagesForProduct:self successBlock:^(NSInteger statusCode, id obj){
        NSArray *imgsArr = (NSArray *)obj;
        [imgsArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self addImagesObject:obj];
        }];
        
        successBlock(statusCode, self);
    } failureBlock:^(NSInteger statusCode, id obj) {
        //Hanlder when failure
    }];
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
    [self saveBookmarkProductWithMutableArray:array];
}

+ (NSMutableArray *)getBookmarkProducts
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [[userDefault objectForKey:STORE_PRODUCT_BOOKMARK] mutableCopy];
}

+ (void)bookmarkProductWithProduct:(OFProduct *)product
{
    NSNumber *productID = product.product_id;
    [self bookmarkProductWithProductID:productID];
}

+ (void)bookmarkProductWithProductID:(NSNumber *)productID
{
    NSMutableArray *bookmarkProducts = [self getBookmarkProducts];
    [bookmarkProducts addObject:productID];
    
    [self saveBookmarkProductWithMutableArray:bookmarkProducts];
}

@end
