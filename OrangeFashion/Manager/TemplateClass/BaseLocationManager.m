//
//  BaseLocationManager.m
//
//
//  Created by Torin on 27/5/13.
//  Copyright (c) 2013 2359 Media Pte Ltd. All rights reserved.
//

#import "BaseLocationManager.h"

@interface BaseLocationManager() <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, assign) CLLocationCoordinate2D currentCoordinate;
@property (nonatomic, assign) BOOL continuousMode;
@property (nonatomic, strong) LocationManagerCompletionBlock completionBlock;
@end

@implementation BaseLocationManager

SINGLETON_MACRO

- (void)setup
{
    self.continuousMode = NO;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
}

- (void)startUpdatingLocationContinuous
{
    if (self.locationManager == nil)
        [self setup];
    
    self.continuousMode = YES;
    [self.locationManager startUpdatingLocation];
}

- (void)startUpdatingLocationOnceOnCompletion:(LocationManagerCompletionBlock)completion
{
    self.completionBlock = completion;
    
    if (ENABLE_FAKE_LOCATION)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^ {
            CLLocationCoordinate2D fakeCoordinate = FAKE_COORDINATE;
            [self updateCoordinate:fakeCoordinate];
        });
        return;
    }
    
    if (self.locationManager == nil)
        [self setup];
    
    self.continuousMode = NO;
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation
{
    self.continuousMode = NO;
    [self.locationManager stopUpdatingLocation];
}

- (CLLocationCoordinate2D)getCurrentCoordinate
{
    return self.currentCoordinate;
}


#pragma mark - Helpers

- (void)updateCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.currentCoordinate = newCoordinate;
    
    if (self.completionBlock)
        self.completionBlock(newCoordinate);
    
    if (self.continuousMode == NO)
        [self.locationManager stopUpdatingLocation];
}



#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [self updateCoordinate:newLocation.coordinate];
}

@end
