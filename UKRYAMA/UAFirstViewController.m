//
//  UAFirstViewController.m
//  UKRYAMA
//
//  Created by San on 03.07.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAFirstViewController.h"
//#import "UAAddDefectViewController.h"

#import "UAServerMeneger.h"
#import "UAUserDefaultSetting.h"

#import "UAUser.h"

@interface UAFirstViewController ()

@end

@implementation UAFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.exitUser) {
        NSLog(@"exitUser");
    }else
        NSLog(@"newUser");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*
 SHAutorizationKodViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SHAutorizationKodViewController"];
 
 [self presentViewController:vc animated:YES completion:nil];
 */

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isFirstResponder]) {
        
        [self.passwordTextField becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //NSLog(@"toch");
    
    [self.loginTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - Action
- (IBAction)actionRegisterUserButton:(UIButton *)sender {
    
    NSString* urlString = [NSString stringWithFormat:@"%@/userGroups/user/register/", UKRYAMA];
    NSURL* url = [NSURL URLWithString:urlString];
    
    [[UIApplication sharedApplication] openURL:url];
}

- (IBAction)actionConnectUserButton:(UIButton *)sender {
    
    BOOL save;
    
    if ([self.saveStateSwitch isOn]) {
        
            save = YES;
    }else   save = NO;
    /*
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Пiдключаюсь"
                                                   message:@"Надсилаю запит до сервера"
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:nil];
    [alertView show];
    */
    [[UAServerMeneger sharedMeneger] getUserAuthorize:self.loginTextField.text
                                       passwordString:self.passwordTextField.text
                                            onSuccess:^(UAUser *user) {
                                                
                                                //[alertView dismissWithClickedButtonIndex:0 animated:NO];
                                                
                                                [[UAUserDefaultSetting sharedManager] saveUserSetting:save
                                                                                                login:self.loginTextField.text
                                                                                         passwordhash:user.passwordhash];
                                                
                                                [[UAUserDefaultSetting sharedManager] saveUserInfoID:user.userID
                                                                                        userNameFull:user.usernameFull];
                                                
                                                if (self.exitUser) {
                                                    
                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                    
                                                }else {
                                                    
                                                    UITabBarController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UATabBar"];
                                                    [self presentViewController:vc animated:YES completion:nil];
                                                }
                                                
                                            }
                                            onFailure:^(NSError *error, NSInteger statusCode) {
                                                
                                                //[alertView dismissWithClickedButtonIndex:0 animated:NO];
                                                
                                                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Помилка!"
                                                                                                    message:@"Стався збiй. Мережа iнтернет вiдсутня або сервер не вiдповiдаэ! Спробуйте пiзнiше."
                                                                                                   delegate:self
                                                                                          cancelButtonTitle:@"Добре"
                                                                                          otherButtonTitles:nil];
                                                [alertView show];
                                                
                                            }];
   
}


@end
