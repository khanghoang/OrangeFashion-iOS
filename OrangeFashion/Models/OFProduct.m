#import "OFProduct.h"


@interface OFProduct ()

// Private interface goes here.

@end


@implementation OFProduct

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
    }
    
    DLog(@"%@", [dictionary description]);
    
    return product;
}

+ (void)getProductsOnSuccess:(OFJSONRequestSuccessBlock)successBlock failure:(OFJSONRequestFailureBlock)failureBlock
{
    NSDictionary *params = @{@"rquest": @"getproducts"};
    [[OFHTTPClient sharedClient] getPath:BASE_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

@end
