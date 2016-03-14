//
//  UAFilterDefectViewController.h
//  UKRYAMA
//
//  Created by San on 05.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UAFilterDefectViewControllerDelegate;
@class UAFilter;


@interface UAFilterDefectViewController : UITableViewController <UITextFieldDelegate>

@property (strong, nonatomic) UAFilter* filter;

@property (strong, nonatomic) IBOutlet UITextField *adressTextField;
@property (strong, nonatomic) IBOutlet UISegmentedControl *statusDefectSegment;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *typeDefectButton;
@property (strong, nonatomic) IBOutlet UILabel *typeDefectLabel;
@property (weak, nonatomic) IBOutlet UISwitch *myDefectSwitch;

@property (weak, nonatomic) id<UAFilterDefectViewControllerDelegate> delegate;

- (IBAction)actionDefectAdress:(id)sender;
- (IBAction)actionDefectStateSegment:(id)sender;
- (IBAction)actionDefectButton:(UIButton *)sender;
- (IBAction)actionDefectMy:(id)sender;

- (IBAction)actionFilterRequestButton:(id)sender;
- (IBAction)actionResetFilterButton:(UIButton *)sender;

@end

@protocol UAFilterDefectViewControllerDelegate <NSObject>

@optional
- (void) filterVC:(UAFilterDefectViewController*) vc filter:(UAFilter*) filter;

@end

/*

 GET /?filter_type=holeonroad&filter_status=fixed
 
 filter_city
 filter_status
 filter_type
 limit
 offset
 page
 archive
 polygons

*/