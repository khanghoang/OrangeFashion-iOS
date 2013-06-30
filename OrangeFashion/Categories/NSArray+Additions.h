//
//  NSArray+NSArray_Additions.h
//  Aurora
//
//  Created by Seivan Heidari on 1/27/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//


@interface NSArray (Additions)
- (NSArray *)paginatedWithNumberOfObjectsPerPage:(NSUInteger)numberOfObjects;
- (NSArray*) deepCopy;
+ (NSArray *)hgwFacebookPermissionsArray;
@end
