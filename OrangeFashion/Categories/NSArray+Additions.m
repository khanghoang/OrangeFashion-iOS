//
//  NSArray+NSArray_Additions.m
//  Aurora
//
//  Created by Seivan Heidari on 1/27/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import "NSArray+Additions.h"

@implementation NSArray (Additions)

- (NSArray *)paginatedWithNumberOfObjectsPerPage:(NSUInteger)numberOfObjects {
  NSMutableArray *pagedArticles = [NSMutableArray array];
  
  __block NSMutableArray *articlesPerPage = [NSMutableArray array];
  [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    [articlesPerPage addObject:obj];
    BOOL shouldAddArticlesToPage = ( (idx > 0 && ((idx+1) % numberOfObjects) == 0) || (idx == self.count-1));    
    if (shouldAddArticlesToPage) { 
      [pagedArticles addObject:[articlesPerPage copy]];
      articlesPerPage = [NSMutableArray array];
    }
  }];
  
  return [pagedArticles copy];
}

- (NSArray*) deepCopy {
  unsigned int count = [self count];
  NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:count];
  
  for (unsigned int i = 0; i < count; ++i) {
    id obj = [self objectAtIndex:i];
    if ([obj respondsToSelector:@selector(deepCopy)])
      [newArray addObject:[obj deepCopy]];
    else
      [newArray addObject:[obj copy]];
  }
  
  NSArray *returnArray = [newArray copy];
  newArray = nil;
  return returnArray;
}

+ (NSArray *)hgwFacebookPermissionsArray {
    return [[NSArray alloc] initWithObjects:
            @"email",
            @"user_birthday",
            @"user_status",
            @"friends_status",
            nil];
}
@end
