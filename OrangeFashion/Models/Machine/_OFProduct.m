// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OFProduct.m instead.

#import "_OFProduct.h"

const struct OFProductAttributes OFProductAttributes = {
	.category_id = @"category_id",
	.collection_id = @"collection_id",
	.colors = @"colors",
	.details = @"details",
	.like_counter = @"like_counter",
	.material = @"material",
	.name = @"name",
	.price = @"price",
	.product_code = @"product_code",
	.product_id = @"product_id",
	.public_date = @"public_date",
	.review = @"review",
	.sold = @"sold",
	.status_id = @"status_id",
	.store = @"store",
	.viewed_counter = @"viewed_counter",
};

const struct OFProductRelationships OFProductRelationships = {
	.images = @"images",
};

const struct OFProductFetchedProperties OFProductFetchedProperties = {
};

@implementation OFProductID
@end

@implementation _OFProduct

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OFProduct" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OFProduct";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OFProduct" inManagedObjectContext:moc_];
}

- (OFProductID*)objectID {
	return (OFProductID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"category_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"category_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"collection_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"collection_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"like_counterValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"like_counter"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"product_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"product_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"soldValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sold"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"status_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"status_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"storeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"store"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"viewed_counterValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"viewed_counter"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic category_id;



- (int32_t)category_idValue {
	NSNumber *result = [self category_id];
	return [result intValue];
}

- (void)setCategory_idValue:(int32_t)value_ {
	[self setCategory_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCategory_idValue {
	NSNumber *result = [self primitiveCategory_id];
	return [result intValue];
}

- (void)setPrimitiveCategory_idValue:(int32_t)value_ {
	[self setPrimitiveCategory_id:[NSNumber numberWithInt:value_]];
}





@dynamic collection_id;



- (int32_t)collection_idValue {
	NSNumber *result = [self collection_id];
	return [result intValue];
}

- (void)setCollection_idValue:(int32_t)value_ {
	[self setCollection_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveCollection_idValue {
	NSNumber *result = [self primitiveCollection_id];
	return [result intValue];
}

- (void)setPrimitiveCollection_idValue:(int32_t)value_ {
	[self setPrimitiveCollection_id:[NSNumber numberWithInt:value_]];
}





@dynamic colors;






@dynamic details;






@dynamic like_counter;



- (int32_t)like_counterValue {
	NSNumber *result = [self like_counter];
	return [result intValue];
}

- (void)setLike_counterValue:(int32_t)value_ {
	[self setLike_counter:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveLike_counterValue {
	NSNumber *result = [self primitiveLike_counter];
	return [result intValue];
}

- (void)setPrimitiveLike_counterValue:(int32_t)value_ {
	[self setPrimitiveLike_counter:[NSNumber numberWithInt:value_]];
}





@dynamic material;






@dynamic name;






@dynamic price;






@dynamic product_code;






@dynamic product_id;



- (int32_t)product_idValue {
	NSNumber *result = [self product_id];
	return [result intValue];
}

- (void)setProduct_idValue:(int32_t)value_ {
	[self setProduct_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveProduct_idValue {
	NSNumber *result = [self primitiveProduct_id];
	return [result intValue];
}

- (void)setPrimitiveProduct_idValue:(int32_t)value_ {
	[self setPrimitiveProduct_id:[NSNumber numberWithInt:value_]];
}





@dynamic public_date;






@dynamic review;






@dynamic sold;



- (int32_t)soldValue {
	NSNumber *result = [self sold];
	return [result intValue];
}

- (void)setSoldValue:(int32_t)value_ {
	[self setSold:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveSoldValue {
	NSNumber *result = [self primitiveSold];
	return [result intValue];
}

- (void)setPrimitiveSoldValue:(int32_t)value_ {
	[self setPrimitiveSold:[NSNumber numberWithInt:value_]];
}





@dynamic status_id;



- (int32_t)status_idValue {
	NSNumber *result = [self status_id];
	return [result intValue];
}

- (void)setStatus_idValue:(int32_t)value_ {
	[self setStatus_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStatus_idValue {
	NSNumber *result = [self primitiveStatus_id];
	return [result intValue];
}

- (void)setPrimitiveStatus_idValue:(int32_t)value_ {
	[self setPrimitiveStatus_id:[NSNumber numberWithInt:value_]];
}





@dynamic store;



- (int32_t)storeValue {
	NSNumber *result = [self store];
	return [result intValue];
}

- (void)setStoreValue:(int32_t)value_ {
	[self setStore:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveStoreValue {
	NSNumber *result = [self primitiveStore];
	return [result intValue];
}

- (void)setPrimitiveStoreValue:(int32_t)value_ {
	[self setPrimitiveStore:[NSNumber numberWithInt:value_]];
}





@dynamic viewed_counter;



- (int32_t)viewed_counterValue {
	NSNumber *result = [self viewed_counter];
	return [result intValue];
}

- (void)setViewed_counterValue:(int32_t)value_ {
	[self setViewed_counter:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveViewed_counterValue {
	NSNumber *result = [self primitiveViewed_counter];
	return [result intValue];
}

- (void)setPrimitiveViewed_counterValue:(int32_t)value_ {
	[self setPrimitiveViewed_counter:[NSNumber numberWithInt:value_]];
}





@dynamic images;

	
- (NSMutableSet*)imagesSet {
	[self willAccessValueForKey:@"images"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"images"];
  
	[self didAccessValueForKey:@"images"];
	return result;
}
	






@end
