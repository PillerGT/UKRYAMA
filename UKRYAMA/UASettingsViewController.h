//
//  UASettingsViewController.h
//  UKRYAMA
//
//  Created by San on 31.03.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UASettingsViewController : UITableViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *servStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *servStatusTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (weak, nonatomic) IBOutlet UISwitch *saveFilterSwitch;

- (IBAction)connectButton:(id)sender;
- (IBAction)actionSaveFilterSwitch:(UISwitch *)sender;
- (IBAction)actionSendMailButton:(UIButton *)sender;

@end
