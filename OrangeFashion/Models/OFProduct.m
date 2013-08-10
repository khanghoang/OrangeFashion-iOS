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
        product.category_id = @([dictionary[@"MaLoaiSanPham"] integerValue]);
        product.collection_id = @([dictionary[@"MaBoSuuTap"] integerValue]);
    }    
    return product;
}

@end
