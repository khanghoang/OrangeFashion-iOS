#import "OFProductImages.h"


@interface OFProductImages ()

// Private interface goes here.

@end


@implementation OFProductImages

+ (NSArray *)productImagesWithArray:(NSArray *)array
{
    __block NSMutableArray *result = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [result addObject:[OFProductImages productImageWithURL:obj]];
    }];
    
    return [result copy];
}

+ (OFProductImages *)productImageWithURL:(NSString *)stringURL
{
    OFProductImages *img = [OFProductImages MR_createEntity];
    [img setPicasa_store_source:stringURL];
    return img;
}

// Custom logic goes here.
+ (void)getImagesForProduct:(OFProduct *)product successBlock:(OFJSONRequestSuccessBlock)successBlock failureBlock:(OFJSONRequestFailureBlock)failureBlock
{    
    NSDictionary *params = @{@"product_id": product.product_id,
                             @"rquest": @"getimages"};
    [[OFHTTPClient sharedClient] getPath:BASE_URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *setOfImage = (NSArray *)responseObject;
        successBlock(operation.response.statusCode, [OFProductImages productImagesWithArray:setOfImage]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //Handler when no internet
        DLog(@"%@", [error description]);
    }];
}

@end
