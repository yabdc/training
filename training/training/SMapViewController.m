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
#import <AddressBookUI/AddressBookUI.h>
#import <iMessageUtility.h>
@interface SMapViewController ()<MKMapViewDelegate>
{
    NSString *m_strAddress;
    NSString *m_strSendAddress;
    UIBarButtonItem *m_backUserLocationBarButtonItem;
    UITapGestureRecognizer *m_pinViewGestureRecognizer;
}
@property (weak, nonatomic) IBOutlet UIImageView *m_markView;
@property (weak, nonatomic) IBOutlet MKMapView *m_MKMapView;
@property (weak, nonatomic) IBOutlet UILabel *m_addressLabel;
@property (weak, nonatomic) IBOutlet UIView *m_pinView;

@property (strong,nonatomic) CLLocationManager *m_locationManager;

@end

@implementation SMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_g_bBrowseMode==YES) {
        self.m_markView.hidden=YES;
        self.m_pinView.hidden=YES;
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(messageNotification:)
                                                     name:@"N0000001"
                                                   object:nil];
    }
    m_strAddress=nil;
    m_backUserLocationBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(setMapCenter)];
    self.navigationItem.rightBarButtonItem=m_backUserLocationBarButtonItem;
    
    self.m_locationManager=[[CLLocationManager alloc] init];
    [self.m_locationManager requestWhenInUseAuthorization];
    MKCoordinateRegion regin =MKCoordinateRegionMakeWithDistance(self.m_MKMapView.userLocation.location.coordinate, 2000.0f, 2000.0f);
    [self.m_MKMapView setRegion:regin animated:YES];
    self.m_MKMapView.delegate=self;
    
    
}

-(void)setMapCenter
{
    [self.m_MKMapView setCenterCoordinate:_m_MKMapView.userLocation.coordinate];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.m_pinView.layer.cornerRadius=5;
    NSLog(@"viewWillLayoutSubviews");
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    if (_g_bBrowseMode==YES) {
        //
    }else{
    m_pinViewGestureRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPinView:)];
    m_pinViewGestureRecognizer.numberOfTapsRequired= 1;
    [self.m_pinView addGestureRecognizer:m_pinViewGestureRecognizer];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- MKMapView Delegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    mapView.centerCoordinate =userLocation.location.coordinate;
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    NSLog(@"mapViewDidFinishLoadingMap");
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.m_pinView.hidden=YES;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (_g_bBrowseMode==YES) {
//    self.m_pinView.hidden=YES;
    }else{
    self.m_pinView.hidden=NO;
    [self change:mapView.centerCoordinate];
    }
}

-(void)change:(CLLocationCoordinate2D)coordinate{
    CLLocation *newLocation=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude: coordinate.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks,
                                       NSError *error)
     {
         CLPlacemark *placemark=[placemarks objectAtIndex:0];
         m_strAddress = ABCreateStringWithAddressDictionary(placemark.addressDictionary, NO);
         m_strAddress=[m_strAddress stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         self.m_addressLabel.text=m_strAddress;
     }];
    
}

- (void)messageNotification:(NSNotification *)notification{
    NSLog(@"%@",notification);
}

-(void)tapPinView:(UITapGestureRecognizer *)recognizer{
    m_strSendAddress=[NSString stringWithFormat:@"%@//%f//%f", m_strAddress, _m_MKMapView.centerCoordinate.latitude, _m_MKMapView.centerCoordinate.longitude];
    [[iMessageUtility sharedManager] sendMsgWithContent:m_strSendAddress ContentType:2 bySequenceID:nil toPhone:@"0000001"];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
