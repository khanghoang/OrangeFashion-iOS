// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OFProductImages.h instead.

#import <CoreData/CoreData.h>


extern const struct OFProductImagesAttributes {
	__unsafe_unretained NSString *image_id;
	__unsafe_unretained NSString *of_store_source;
	__unsafe_unretained NSString *picasa_store_source;
	__unsafe_unretained NSString *product_id;
} OFProductImagesAttributes;

extern const struct OFProductImagesRelationships {
	__unsafe_unretained NSString *product;
} OFProductImagesRelationships;

extern const struct OFProductImagesFetchedProperties {
} OFProductImagesFetchedProperties;

@class OFProduct;






@interface OFProductImagesID : NSManagedObjectID {}
@end

@interface _OFProductImages : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OFProductImagesID*)objectID;





@property (nonatomic, strong) NSNumber* image_id;



@property int32_t image_idValue;
- (int32_t)image_idValue;
- (void)setImage_idValue:(int32_t)value_;

//- (BOOL)validateImage_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* of_store_source;



//- (BOOL)validateOf_store_source:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* picasa_store_source;



//- (BOOL)validatePicasa_store_source:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* product_id;



@property int32_t product_idValue;
- (int32_t)product_idValue;
- (void)setProduct_idValue:(int32_t)value_;

//- (BOOL)validateProduct_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) OFProduct *product;

//- (BOOL)validateProduct:(id*)value_ error:(NSError**)error_;





@end

@interface _OFProductImages (CoreDataGeneratedAccessors)

@end

@interface _OFProductImages (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveImage_id;
- (void)setPrimitiveImage_id:(NSNumber*)value;

- (int32_t)primitiveImage_idValue;
- (void)setPrimitiveImage_idValue:(int32_t)value_;




- (NSString*)primitiveOf_store_source;
- (void)setPrimitiveOf_store_source:(NSString*)value;




- (NSString*)primitivePicasa_store_source;
- (void)setPrimitivePicasa_store_source:(NSString*)value;




- (NSNumber*)primitiveProduct_id;
- (void)setPrimitiveProduct_id:(NSNumber*)value;

- (int32_t)primitiveProduct_idValue;
- (void)setPrimitiveProduct_idValue:(int32_t)value_;





- (OFProduct*)primitiveProduct;
- (void)setPrimitiveProduct:(OFProduct*)value;


@end
