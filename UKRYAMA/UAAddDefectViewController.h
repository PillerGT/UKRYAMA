//
//  UAAddDefectViewController.h
//  UKRYAMA
//
//  Created by San on 04.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAAddMapViewController.h"

@class UAAdress;

@interface UAAddDefectViewController : UITableViewController <UITextViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString* tempLatityde;
@property (strong, nonatomic) NSString* tempLongitude;

@property (weak, nonatomic) IBOutlet UIImageView *addDefectImage;
@property (weak, nonatomic) IBOutlet UIView *viewImageText;
@property (weak, nonatomic) IBOutlet UILabel *addDefectTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *addAdressTextLabel;
@property (weak, nonatomic) IBOutlet UITextView * addCommentTextView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *typeDefectButton;
@property (weak, nonatomic) IBOutlet UILabel *typeDefectLabel;
@property (weak, nonatomic) IBOutlet UILabel *addDateLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *uploadActivityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *uploadImageButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@property (weak, nonatomic) IBOutlet UIImageView *addPhotoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addGeopositionImageView;


@property (strong, nonatomic) UAAdress* defectAdress;

//- (IBAction)actionAddPhotoButton:(UIButton *)sender;
//- (IBAction)actionAddAddressButton:(UIButton *)sender;

- (IBAction)actionUploadDefect:(UIButton *)sender;
- (IBAction)activeDefectButton:(UIButton *)sender;

@end

