//
//  NSMutableArray+Additions.m
//  EagleChild
//
//  Created by Torin on 15/7/13.
//
//

#import "NSMutableArray+Additions.h"

@implementation NSMutableArray (Additions)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = arc4random_uniform(nElements) + i;
        [self exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
