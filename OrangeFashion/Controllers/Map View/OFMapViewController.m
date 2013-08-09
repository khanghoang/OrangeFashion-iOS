//
//  OFMapViewController.m
//  OrangeFashion
//
//  Created by Khang on 2/8/13.
//  Copyright (c) 2013 Khang. All rights reserved.
//

#import "OFMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface OFMapViewController ()

@property (strong, nonatomic) GMSMapView *mapView;

@end

@implementation OFMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SVProgressHUD dismiss];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = @"Bản đồ";
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    // Do any additional setup after loading the view from its nib.
    
    self.view = self.mapView;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:SETTINGS_ORANGE_SHOP_LATITUDE
                                                            longitude:SETTINGS_ORANGE_SHOP_LONGITUDE
                                                                 zoom:16];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(SETTINGS_ORANGE_SHOP_LATITUDE, SETTINGS_ORANGE_SHOP_LONGITUDE);
    marker.title = @"Orange Fashion";
    marker.snippet = ORANGE_SHOP_MAP_SNIPPET;
    marker.map = self.mapView;
}

@end
