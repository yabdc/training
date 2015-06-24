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
#import "SDefine.h"
@interface SMapViewController ()<MKMapViewDelegate>
{
    NSString *m_strAddress;
    NSString *m_strSendAddress;
    UIBarButtonItem *m_backUserLocationBarButtonItem;
    UITapGestureRecognizer *m_pinViewGestureRecognizer;
    float m_flatitude;
    float m_flongitude;
    MKPointAnnotation *m_annotation;
}
@property (weak, nonatomic) IBOutlet UIImageView *m_markView;
@property (weak, nonatomic) IBOutlet MKMapView *m_MKMapView;
@property (weak, nonatomic) IBOutlet UILabel *m_addressLabel;
@property (weak, nonatomic) IBOutlet UIView *m_pinView;
@property (weak, nonatomic) IBOutlet UIButton *m_flagButton;
@property (strong,nonatomic) CLLocationManager *m_locationManager;

@end

@implementation SMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_g_bBrowseMode==YES) {
        self.m_markView.hidden=YES;
        self.m_pinView.hidden=YES;
        NSArray *aryContent = [self.g_mapMessageItem.Content componentsSeparatedByString:@"//"];
        NSLog(@"%@",aryContent);
        m_flatitude = [aryContent[1] floatValue];
        m_flongitude = [aryContent[2] floatValue];
        m_annotation = [[MKPointAnnotation alloc] init];
        [m_annotation setCoordinate:CLLocationCoordinate2DMake(m_flatitude
                                                               ,m_flongitude)];
        [m_annotation setTitle:aryContent[0]];
    }else{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(messageNotification:)
                                                     name:@"N0000001"
                                                   object:nil];
        self.m_flagButton.hidden=YES;
    }
    m_strAddress=nil;
    UIImage *baritemImage=[UIImage imageNamed: @"UserLocation"];
    baritemImage=[self imageWithImageSimple:baritemImage scaledToSize:CGSizeMake(25, 25)];
    m_backUserLocationBarButtonItem=[[UIBarButtonItem alloc] initWithImage:baritemImage style:UIBarButtonItemStylePlain target:self action:@selector(setMapCenter)];
    
    self.navigationItem.rightBarButtonItem=m_backUserLocationBarButtonItem;
    
    self.m_locationManager=[[CLLocationManager alloc] init];
    [self.m_locationManager requestWhenInUseAuthorization];
    MKCoordinateRegion regin =MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(m_flatitude,m_flongitude), MapArea, MapArea);
    [self.m_MKMapView setRegion:regin animated:YES];
    self.m_MKMapView.delegate=self;
    
    
}

-(void)setMapCenter
{
    [self.m_MKMapView setCenterCoordinate:_m_MKMapView.userLocation.coordinate];
}
- (IBAction)setFlagCenter:(id)sender {
    [self.m_MKMapView setCenterCoordinate:CLLocationCoordinate2DMake(m_flatitude,m_flongitude)];
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
    
    if (_g_bBrowseMode==YES) {
        [self.m_MKMapView addAnnotation:m_annotation];
        [self.m_MKMapView selectAnnotation:m_annotation animated:YES];
    }else{
        mapView.centerCoordinate =userLocation.location.coordinate;
    }
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    
}

-(void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    self.m_pinView.hidden=YES;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    if (_g_bBrowseMode==YES) {

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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.image = [UIImage imageNamed:@"Flag"];
            
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    float width,height;
    if (image.size.width<newSize.width && image.size.height<newSize.height){
        //如果已經小於newSize則不縮小
        width=image.size.width;
        height=image.size.height;
    }else if (image.size.height >= (newSize.height/newSize.width)*image.size.width){
        width=image.size.width/image.size.height*newSize.height;
        height=newSize.height;
    }else{
        height=image.size.height/image.size.width*newSize.height;
        width=newSize.width;
    }
    newSize.width=width;
    newSize.height=height;
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
@end
