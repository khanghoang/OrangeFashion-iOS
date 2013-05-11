// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to OFProductImages.m instead.

#import "_OFProductImages.h"

const struct OFProductImagesAttributes OFProductImagesAttributes = {
	.image_id = @"image_id",
	.of_store_source = @"of_store_source",
	.picasa_store_source = @"picasa_store_source",
	.product_id = @"product_id",
};

const struct OFProductImagesRelationships OFProductImagesRelationships = {
	.product = @"product",
};

const struct OFProductImagesFetchedProperties OFProductImagesFetchedProperties = {
};

@implementation OFProductImagesID
@end

@implementation _OFProductImages

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"OFProductImages" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"OFProductImages";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"OFProductImages" inManagedObjectContext:moc_];
}

- (OFProductImagesID*)objectID {
	return (OFProductImagesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"image_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"image_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"product_idValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"product_id"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic image_id;



- (int32_t)image_idValue {
	NSNumber *result = [self image_id];
	return [result intValue];
}

- (void)setImage_idValue:(int32_t)value_ {
	[self setImage_id:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveImage_idValue {
	NSNumber *result = [self primitiveImage_id];
	return [result intValue];
}

- (void)setPrimitiveImage_idValue:(int32_t)value_ {
	[self setPrimitiveImage_id:[NSNumber numberWithInt:value_]];
}





@dynamic of_store_source;






@dynamic picasa_store_source;






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





@dynamic product;

	






@end
