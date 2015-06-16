//
//  SMapViewController.m
//  training
//
//  Created by 1500244 on 2015/6/15.
//  Copyright (c) 2015年 andychan. All rights reserved.
//

#import "SMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface SMapViewController ()<MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *m_MKMapView;
@property (strong,nonatomic) CLLocationManager *locationManager;
@end

@implementation SMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locationManager=[[CLLocationManager alloc] init];
    [self.locationManager requestWhenInUseAuthorization];
    MKCoordinateRegion regin =MKCoordinateRegionMakeWithDistance(self.m_MKMapView.userLocation.location.coordinate, 2000.0f, 2000.0f);
    [self.m_MKMapView setRegion:regin animated:YES];
    self.m_MKMapView.delegate=self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- MKMapView Delegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    mapView.centerCoordinate =userLocation.location.coordinate;
}

@end
