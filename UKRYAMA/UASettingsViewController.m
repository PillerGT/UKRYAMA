//
//  UASettingsViewController.m
//  UKRYAMA
//
//  Created by San on 31.03.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UASettingsViewController.h"
#import "UAServerMeneger.h"
#import "UAUserDefaultSetting.h"
#import "UAFirstViewController.h"

#import "CTFeedback/Classes/CTFeedbackViewController.h"

@interface UASettingsViewController ()

@property (assign, nonatomic) BOOL checkServer;

@end

@implementation UASettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([[UAUserDefaultSetting sharedManager] loadFilterON]) {
        [self.saveFilterSwitch setOn:YES animated:NO];
    }else
        [self.saveFilterSwitch setOn:NO animated:NO];
    
    [self stateButtonLogin];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    self.userTextLabel.text = [[[UAUserDefaultSetting sharedManager] loadUserInfo] objectForKey:@"userNameFull"];
    NSLog(@"USER TEXT ------------------- %@", self.userTextLabel.text);
    [self checkStatusServer];
    
    if (self.checkServer) {
        self.servStatusImageView.image = [UIImage imageNamed:@"fixedDots"];
        self.servStatusTextLabel.text = @"звязок з сервером присутнiй";
    }else {
        self.servStatusImageView.image = [UIImage imageNamed:@"achtungDots"];
        self.servStatusTextLabel.text = @"звязок з сервером вiдсутнiй";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ServerRequest
- (void) checkStatusServer {
    
    NSDictionary* dict  = [[UAUserDefaultSetting sharedManager] loadUserSetting];
    NSString* login     = [dict objectForKey:@"login"];
    NSString* password  = [dict objectForKey:@"passwordhash"];
    
    dispatch_queue_t queue = dispatch_queue_create("com.ukryama.load.check_auth", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        
        [[UAServerMeneger sharedMeneger] getUserCheckAuth:login
                                           passwordString:password
                                                onSuccess:^(BOOL result) {
                                                    
                                                    self.checkServer = result;
                                                }
                                                onFailure:^(NSError *error, NSInteger statusCode) {
                                                    
                                                    self.checkServer = NO;
                                                }];
    });
}

- (void) checkExitUserFromServer {
    
    NSDictionary* dict  = [[UAUserDefaultSetting sharedManager] loadUserSetting];
    NSString* login     = [dict objectForKey:@"login"];
    
    [[UAServerMeneger sharedMeneger] getUserExit:login
                                       onSuccess:^(BOOL result) {
                                           
                                           NSString* title = @"Вихiд";
                                           NSString* message = nil;
                                           
                                           if (result) {
                                               message = @"Користувач успiшно вийшов";
                                               [self clearUserData];
                                               [[UAUserDefaultSetting sharedManager] saveUserSetting:NO
                                                                                               login:@""
                                                                                        passwordhash:@""];
                                               self.userTextLabel.text = @"Не авторизований";
                                               self.checkServer = NO;
                                               self.servStatusImageView.image = [UIImage imageNamed:@"achtungDots.png"];
                                               self.servStatusTextLabel.text = @"звязок з сервером вiдсутнiй";
                                           }else
                                               message = @"Не вдалось вийти";
                                           
                                           UIAlertView* checkAV = [[UIAlertView alloc] initWithTitle:title
                                                                                             message:message
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"Добре"
                                                                                   otherButtonTitles:nil];
                                           [checkAV show];
                                           
                                           if (result) {
                                               UAFirstViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UAFirstViewController"];
                                               vc.exitUser = YES;
                                               [self presentViewController:vc animated:NO completion:nil];
                                           }
                                           
                                       }
                                       onFailure:^(NSError *error, NSInteger statusCode) {
                                           
                                           UIAlertView* checkAV = [[UIAlertView alloc] initWithTitle:@"Помилка"
                                                                                             message:@"Вiдсутнiй iнтернет або сервер не вiдповiв на запит"
                                                                                            delegate:nil
                                                                                   cancelButtonTitle:@"Добре"
                                                                                   otherButtonTitles:nil];
                                           [checkAV show];
                                           
                                       }];
}

#pragma mark - SupportFunction
- (void) clearUserData {
    
    [[UAUserDefaultSetting sharedManager] saveUserInfoID:@""
                                            userNameFull:@""];
    
    [[UAUserDefaultSetting sharedManager] saveMyList:NO
                                                city:@""
                                               state:@""
                                                type:@""];
    
    [[UAUserDefaultSetting sharedManager] saveFilterON:NO];
    
}

- (void) stateButtonLogin {
    
    NSDictionary* dict = [[UAUserDefaultSetting sharedManager] loadUserSetting];
    NSString* login = [dict objectForKey:@"login"];
    
    if (login.length == 0) {
        login = nil;
    }
    
    if (login) {
        self.connectButton.titleLabel.text = @"Вийти";
    }else
        self.connectButton.titleLabel.text = @"Увiйти";
}

/*
 # pragma mark - UITextFieldDelegate
 
 - (BOOL)textFieldShouldReturn:(UITextField *)textField {
 
 
 //for (UITextField* tempTextField in self.textField) {
 
 if ([textField isEqual: self.loginField]) {
 
 [self.passwordField becomeFirstResponder];
 }else
 
 [textField resignFirstResponder];
 
 //}
 
 return YES;
 
 }
 */
/*
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}
*/
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - ActionButton
- (IBAction)connectButton:(id)sender {
    
    NSDictionary* dict  = [[UAUserDefaultSetting sharedManager] loadUserSetting];
    NSString* login     = [dict objectForKey:@"login"];
    
    if (login.length == 0) {
        login = nil;
    }
    
    if (login) {
        [self checkExitUserFromServer];
    }else
    {
        UAFirstViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UAFirstViewController"];
        [self presentViewController:vc animated:NO completion:nil];
    }
    
}

- (IBAction)actionSaveFilterSwitch:(UISwitch *)sender {
    
    BOOL state = [[UAUserDefaultSetting sharedManager] loadFilterON];
    
    if (state) {
        [self clearUserData];
    }else {
        [[UAUserDefaultSetting sharedManager] saveFilterON:YES];
    }
}

- (IBAction)actionSendMailButton:(UIButton *)sender {
    
    UIAlertView* mailAlertView = [[UIAlertView alloc] initWithTitle:@"Написати листа"
                                                            message:@"Виберiть, будь-ласка, адресата якому потрiбно вiдправити листа"
                                                           delegate:self
                                                  cancelButtonTitle:@"Вiдмiнити"
                                                  otherButtonTitles:@"Проекту УкрЯма", @"Розробнику додатка", nil];
    [mailAlertView show];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    //NSLog(@"%d",buttonIndex);
    
    if (buttonIndex == 1) {
        [self sendMail:@"info@ukryama.com"];
    }else if (buttonIndex == 2) {
        [self sendMail:@"kovalov.help@gmail.com"];
    }
    
    //feedbackViewController.useHTML = NO;
    //[self.navigationController pushViewController:feedbackViewController animated:YES];
    //[self presentViewController:feedbackViewController animated:YES completion:nil];
}

- (void) sendMail:(NSString*) mail {
    
    CTFeedbackViewController *feedbackViewController = [CTFeedbackViewController controllerWithTopics:CTFeedbackViewController.defaultTopics
                                                                                      localizedTopics:CTFeedbackViewController.defaultLocalizedTopics];
    feedbackViewController.toRecipients = @[mail];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedbackViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

@end
