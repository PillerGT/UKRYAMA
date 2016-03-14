//
//  UAAddMapViewController.m
//  UKRYAMA
//
//  Created by San on 20.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAAddMapViewController.h"
#import "UAAddDefectViewController.h"
#import "UAAdress.h"

@interface UAAddMapViewController ()

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (assign, nonatomic) CLLocationCoordinate2D location;
@property (strong, nonatomic) UAAdress* adressCoordinate;

@end

@implementation UAAddMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CALayer *viewLayerDateFixed = self.defectAdressView.layer;
    [viewLayerDateFixed setCornerRadius:10];
    [viewLayerDateFixed setBorderWidth:1];
    [viewLayerDateFixed setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [viewLayerDateFixed setMasksToBounds:YES];
    
    self.defectAdressLabel.text = @"Визначаю координати";
    self.gotovoButton.enabled = NO;
    self.adressCoordinate = [[UAAdress alloc] init];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    
    //self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    
    self.tabBarController.tabBar.hidden = YES;
}

- (UAAdress*) adressSearchLatitude:(NSString*) latitude longitude:(NSString*) longitude{
    
    NSString* url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true_or_false&language=uk",latitude,longitude];
    //NSLog(@"REQUEST = %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //[request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        
        //return nil;
    }
    
    //NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    //NSLog(@"JSON = %@",result);
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:oResponseData options:0 error:&localError];
    
    if (localError != nil) {
        //*error = localError;
        //return nil;
    }
    
    NSDictionary *results = [parsedObject valueForKey:@"results"];
    
    return [[UAAdress alloc] initWithServerResponse:results];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    //[self.locationManager requestAlwaysAuthorization];
    //[self.locationManager startUpdatingLocation];
    //self.location = locations.lastObject;
    
    NSLog(@"%@", [locations lastObject]);
    
    self.location = [[locations lastObject] coordinate];

    self.mapView.camera = [GMSCameraPosition cameraWithTarget:self.location zoom:15 bearing:0 viewingAngle:0];

    /*
    GMSMarker* marker = [GMSMarker markerWithPosition:location];
    marker.title = @"Я тут";
    marker.map = self.mapView;
     */
    [self.locationManager stopUpdatingLocation];
    
    self.adressCoordinate = [self adressSearchLatitude:[NSString stringWithFormat:@"%f", self.location.latitude] longitude:[NSString stringWithFormat:@"%f", self.location.longitude]];
    
    self.defectAdressLabel.text = self.adressCoordinate.adressFormat;
    
    self.adressCoordinate.latitude  = [NSString stringWithFormat:@"%f", self.location.latitude];
    self.adressCoordinate.longitude = [NSString stringWithFormat:@"%f", self.location.longitude];
    
    self.gotovoButton.enabled = YES;
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.myLocationEnabled = YES;
        self.mapView.settings.myLocationButton = YES;
        self.mapView.settings.compassButton = YES;
        
    }
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    
    [self.mapView clear];
    
    GMSMarker* marker = [GMSMarker markerWithPosition:coordinate];
    marker.title = @"Дефекти на цiй дорозi";
    marker.map = self.mapView;
    
    self.adressCoordinate = [self adressSearchLatitude:[NSString stringWithFormat:@"%f", coordinate.latitude] longitude:[NSString stringWithFormat:@"%f", coordinate.longitude]];
    
    self.adressCoordinate.latitude  = [NSString stringWithFormat:@"%f", coordinate.latitude];
    self.adressCoordinate.longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    self.defectAdressLabel.text = self.adressCoordinate.adressFormat;
    self.gotovoButton.enabled = YES;
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You LongPress at %f,%f", coordinate.latitude, coordinate.longitude);
}
/*
- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapView {
    
    //self.mapView.myLocationEnabled = YES;
    return NO;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    self.tabBarController.tabBar.hidden = NO;
    
    UAAddDefectViewController* vc = [segue destinationViewController];
    [vc setDefectAdress:self.adressCoordinate];
    
    NSString* tmpLatitude = [NSString stringWithFormat:@"%2.11f", self.location.latitude];
    NSString* tmpLongitude = [NSString stringWithFormat:@"%2.11f", self.location.longitude];
    
    [vc setTempLatityde:tmpLatitude];
    [vc setTempLongitude:tmpLongitude];
    
}
*/
/*
- (void)mapView:(MKMapView *)aMapView didUpdateUserLocation:(MKUserLocation *)aUserLocation {
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    CLLocationCoordinate2D location;
    location.latitude = aUserLocation.coordinate.latitude;
    location.longitude = aUserLocation.coordinate.longitude;
    region.span = span;
    region.center = location;
    [aMapView setRegion:region animated:YES];
}
*/
/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}
*/
- (IBAction)actionGotovoButton:(UIButton *)sender {
    
    [self.delegate backAddressVC:self address:self.adressCoordinate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionBackButton:(UIBarButtonItem *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
