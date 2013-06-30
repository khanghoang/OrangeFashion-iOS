//
//  UIView+Nib.h
//  Snap
//
//  Created by Hu Junfeng on 7/2/13.
//  Copyright (c) 2013 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Nib)

/**
 Creates and returns an UIView object in the specified nib file. The class of the first object in the nib file must be the class that calls this method.
 
 @param nibNameOrNil The name of the nib file, which need not include the .nib extension.
 @param bundleOrNil The name of the bundle that the nib file is located in.
 @param owner The object to assign as the nib's File's Owner object.
 
 @return An UIView object created from in the specified nib.
 
 @note This method is extracted from ViewUtils.
 */
+ (id)instanceWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)bundleOrNil owner:(id)owner;

/**
 It calls instanceWithNibName:bundle:ower by passing nil to all parameters.
 */
+ (id)instanceWithNib;

@end
