//
//  UAFirstViewController.h
//  UKRYAMA
//
//  Created by San on 03.07.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UAFirstViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *loginTextField;
@property (weak, nonatomic) IBOutlet UISwitch *saveStateSwitch;
@property (assign, nonatomic) BOOL exitUser;

- (IBAction)actionRegisterUserButton:(UIButton *)sender;
- (IBAction)actionConnectUserButton:(UIButton *)sender;
//- (IBAction)actionSaveUserSwitch:(UISwitch *)sender;

@end
