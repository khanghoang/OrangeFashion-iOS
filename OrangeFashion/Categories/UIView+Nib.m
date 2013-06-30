//
//  UIView+Nib.m
//  Snap
//
//  Created by Hu Junfeng on 7/2/13.
//  Copyright (c) 2013 2359 Media Pte Ltd. All rights reserved.
//

#import "UIView+Nib.h"

@implementation UIView (Nib)

+ (id)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner
{
    //default values
    NSString *nibName = nibNameOrNil ?: NSStringFromClass(self);
    NSBundle *bundle = bundleOrNil ?: [NSBundle mainBundle];
    
    //cache nib to prevent unnecessary filesystem access
    static NSCache *nibCache = nil;
    if (nibCache == nil)
    {
        nibCache = [[NSCache alloc] init];
    }
    NSString *pathKey = [NSString stringWithFormat:@"%@.%@", bundle.bundleIdentifier, nibName];
    UINib *nib = [nibCache objectForKey:pathKey];
    if (nib == nil)
    {
        NSString *nibPath = [bundle pathForResource:nibName ofType:@"nib"];
        if (nibPath) nib = [UINib nibWithNibName:nibName bundle:bundle];
        [nibCache setObject:nib ?: [NSNull null] forKey:pathKey];
    }
    else if ([nib isKindOfClass:[NSNull class]])
    {
        nib = nil;
    }
    
    if (nib)
    {
        //attempt to load from nib
        NSArray *contents = [nib instantiateWithOwner:owner options:nil];
        UIView *view = [contents count]? [contents objectAtIndex:0]: nil;
        NSAssert ([view isKindOfClass:self], @"First object in nib '%@' was '%@'. Expected '%@'", nibName, view, self);
        return view;
    }
    
    //return empty view
    return [[[self class] alloc] init];
}

+ (id)instanceWithNib
{
    return [self instanceWithNibName:nil bundle:nil owner:nil];
}

@end
