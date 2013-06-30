//
//  MKMapView+Additions.h
//  TemplateProject
//
//  Created by Torin on 22/4/13.
//  Copyright (c) 2013 MyCompany. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (Additions)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;
@end
