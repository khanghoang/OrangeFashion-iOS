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
+ (void)getImagesForProduct:(OFProduct *)product
               successBlock:(OFJSONRequestSuccessBlock)successBlock
               failureBlock:(OFJSONRequestFailureBlock)failureBlock
{    
    NSDictionary *params = @{@"product_id": product.product_id,
                             @"rquest": @"getimages"};
    
    [[OFHTTPClient sharedClient] getPath:API_SERVER_HOST parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *setOfImage = (NSArray *)responseObject;
        OFProduct *storedProduct = [[OFProduct MR_findByAttribute:@"product_id" withValue:product.product_id] lastObject];
        NSArray *arrImages =  [OFProductImages productImagesWithArray:setOfImage];
        storedProduct.images = [NSSet setWithArray:arrImages];
        
        NSManagedObjectContext *mainContext = [NSManagedObjectContext MR_defaultContext];
        [mainContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
            DLog(@"Finish save to magical record");
        }];
        
        successBlock(operation.response.statusCode, arrImages);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        OFProduct *storedProduct = [[OFProduct MR_findByAttribute:@"product_id" withValue:product.product_id] lastObject];
        if (storedProduct.images.count > 0) {
            successBlock(operation.response.statusCode, [storedProduct.images allObjects]);
        }
        else{
            //Handler when no internet
            DLog(@"%@", [error description]);
            if (failureBlock) {
                failureBlock(operation.response.statusCode, error);
            }
        }
    }];
}

@end
