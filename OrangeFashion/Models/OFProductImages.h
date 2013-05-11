#import "_OFProductImages.h"

@interface OFProductImages : _OFProductImages {}
// Custom logic goes here.
+ (void)getImagesForProduct:(OFProduct *)product successBlock:(OFJSONRequestSuccessBlock)successBlock failureBlock:(OFJSONRequestFailureBlock)failureBlock;

@end
