// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OFProduct.h instead.

#import <CoreData/CoreData.h>


extern const struct OFProductAttributes {
	__unsafe_unretained NSString *category_id;
	__unsafe_unretained NSString *collection_id;
	__unsafe_unretained NSString *colors;
	__unsafe_unretained NSString *details;
	__unsafe_unretained NSString *like_counter;
	__unsafe_unretained NSString *material;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
	__unsafe_unretained NSString *product_code;
	__unsafe_unretained NSString *product_id;
	__unsafe_unretained NSString *public_date;
	__unsafe_unretained NSString *review;
	__unsafe_unretained NSString *sold;
	__unsafe_unretained NSString *status_id;
	__unsafe_unretained NSString *store;
	__unsafe_unretained NSString *viewed_counter;
} OFProductAttributes;

extern const struct OFProductRelationships {
	__unsafe_unretained NSString *images;
} OFProductRelationships;

extern const struct OFProductFetchedProperties {
} OFProductFetchedProperties;

@class OFProductImages;


















@interface OFProductID : NSManagedObjectID {}
@end

@interface _OFProduct : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (OFProductID*)objectID;





@property (nonatomic, strong) NSNumber* category_id;



@property int32_t category_idValue;
- (int32_t)category_idValue;
- (void)setCategory_idValue:(int32_t)value_;

//- (BOOL)validateCategory_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* collection_id;



@property int32_t collection_idValue;
- (int32_t)collection_idValue;
- (void)setCollection_idValue:(int32_t)value_;

//- (BOOL)validateCollection_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* colors;



//- (BOOL)validateColors:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* details;



//- (BOOL)validateDetails:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* like_counter;



@property int32_t like_counterValue;
- (int32_t)like_counterValue;
- (void)setLike_counterValue:(int32_t)value_;

//- (BOOL)validateLike_counter:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* material;



//- (BOOL)validateMaterial:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* price;



//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* product_code;



//- (BOOL)validateProduct_code:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* product_id;



@property int32_t product_idValue;
- (int32_t)product_idValue;
- (void)setProduct_idValue:(int32_t)value_;

//- (BOOL)validateProduct_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* public_date;



//- (BOOL)validatePublic_date:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* review;



//- (BOOL)validateReview:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sold;



@property int32_t soldValue;
- (int32_t)soldValue;
- (void)setSoldValue:(int32_t)value_;

//- (BOOL)validateSold:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* status_id;



@property int32_t status_idValue;
- (int32_t)status_idValue;
- (void)setStatus_idValue:(int32_t)value_;

//- (BOOL)validateStatus_id:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* store;



@property int32_t storeValue;
- (int32_t)storeValue;
- (void)setStoreValue:(int32_t)value_;

//- (BOOL)validateStore:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* viewed_counter;



@property int32_t viewed_counterValue;
- (int32_t)viewed_counterValue;
- (void)setViewed_counterValue:(int32_t)value_;

//- (BOOL)validateViewed_counter:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *images;

- (NSMutableSet*)imagesSet;





@end

@interface _OFProduct (CoreDataGeneratedAccessors)

- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(OFProductImages*)value_;
- (void)removeImagesObject:(OFProductImages*)value_;

@end

@interface _OFProduct (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCategory_id;
- (void)setPrimitiveCategory_id:(NSNumber*)value;

- (int32_t)primitiveCategory_idValue;
- (void)setPrimitiveCategory_idValue:(int32_t)value_;




- (NSNumber*)primitiveCollection_id;
- (void)setPrimitiveCollection_id:(NSNumber*)value;

- (int32_t)primitiveCollection_idValue;
- (void)setPrimitiveCollection_idValue:(int32_t)value_;




- (NSString*)primitiveColors;
- (void)setPrimitiveColors:(NSString*)value;




- (NSString*)primitiveDetails;
- (void)setPrimitiveDetails:(NSString*)value;




- (NSNumber*)primitiveLike_counter;
- (void)setPrimitiveLike_counter:(NSNumber*)value;

- (int32_t)primitiveLike_counterValue;
- (void)setPrimitiveLike_counterValue:(int32_t)value_;




- (NSString*)primitiveMaterial;
- (void)setPrimitiveMaterial:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePrice;
- (void)setPrimitivePrice:(NSString*)value;




- (NSString*)primitiveProduct_code;
- (void)setPrimitiveProduct_code:(NSString*)value;




- (NSNumber*)primitiveProduct_id;
- (void)setPrimitiveProduct_id:(NSNumber*)value;

- (int32_t)primitiveProduct_idValue;
- (void)setPrimitiveProduct_idValue:(int32_t)value_;




- (NSDate*)primitivePublic_date;
- (void)setPrimitivePublic_date:(NSDate*)value;




- (NSString*)primitiveReview;
- (void)setPrimitiveReview:(NSString*)value;




- (NSNumber*)primitiveSold;
- (void)setPrimitiveSold:(NSNumber*)value;

- (int32_t)primitiveSoldValue;
- (void)setPrimitiveSoldValue:(int32_t)value_;




- (NSNumber*)primitiveStatus_id;
- (void)setPrimitiveStatus_id:(NSNumber*)value;

- (int32_t)primitiveStatus_idValue;
- (void)setPrimitiveStatus_idValue:(int32_t)value_;




- (NSNumber*)primitiveStore;
- (void)setPrimitiveStore:(NSNumber*)value;

- (int32_t)primitiveStoreValue;
- (void)setPrimitiveStoreValue:(int32_t)value_;




- (NSNumber*)primitiveViewed_counter;
- (void)setPrimitiveViewed_counter:(NSNumber*)value;

- (int32_t)primitiveViewed_counterValue;
- (void)setPrimitiveViewed_counterValue:(int32_t)value_;





- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;


@end
