//
//  UAAddMapViewController.h
//  UKRYAMA
//
//  Created by San on 20.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapKit/MapKit.h"
#import <CoreLocation/CLLocationManager.h>
#import <GoogleMaps/GoogleMaps.h>

@class UAAdress;
@protocol UAAddMapViewControllerDelegate;

@interface UAAddMapViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *defectAdressLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotovoButton;
@property (weak, nonatomic) IBOutlet UIView *defectAdressView;

@property (weak, nonatomic) id <UAAddMapViewControllerDelegate> delegate;

- (IBAction)actionGotovoButton:(UIButton *)sender;
- (IBAction)actionBackButton:(UIBarButtonItem *)sender;

@end



@protocol UAAddMapViewControllerDelegate <NSObject>
@optional
- (void) backAddressVC:(UAAddMapViewController*) addMapVC address:(UAAdress*) address;

@end