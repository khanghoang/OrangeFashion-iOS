//
//  BaseLocationManager.h
//
//
//  Created by Torin on 27/5/13.
//  Copyright (c) 2013 2359 Media Pte Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LocationManagerCompletionBlock)(CLLocationCoordinate2D currentCoordinate);

@interface BaseLocationManager : BaseManager

- (void)startUpdatingLocationContinuous;
- (void)startUpdatingLocationOnceOnCompletion:(LocationManagerCompletionBlock)completion;
                                               
- (void)stopUpdatingLocation;

- (CLLocationCoordinate2D)getCurrentCoordinate;

@end
