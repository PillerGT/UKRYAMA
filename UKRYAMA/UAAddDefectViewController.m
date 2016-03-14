//
//  UAAddDefectViewController.m
//  UKRYAMA
//
//  Created by San on 04.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAAddDefectViewController.h"
#import "UzysAssetsPickerController.h"
#import "UAAddMapViewController.h"
#import "UAFirstViewController.h"
#import "UAUserDefaultSetting.h"
#import "UAInterfaceStyle.h"

#import "UADefect.h"
#import "UAAdress.h"
#import "UAUser.h"

#import "UAServerMeneger.h"

@interface UAAddDefectViewController () <UzysAssetsPickerControllerDelegate, UITextFieldDelegate, UAAddMapViewControllerDelegate>

@property (strong, nonatomic) UADefect* addDefect;
@property (strong, nonatomic) NSMutableArray* arrayImage;

@property (assign, nonatomic) NSInteger numberDefectType;
@property (strong, nonatomic) NSArray* defectImageArray;
@property (strong, nonatomic) NSDictionary* defectListDict;
@property (strong, nonatomic) NSArray* arrayHeader;

@end

@implementation UAAddDefectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.arrayHeader = @[@"Фото та мiсце *",
                         @"Тип дефекту *",
                         @"Опис"];
    
    //self.view.frame.size.height;
    //self.view.frame.size.width;
    
    //UIView* showInfoView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame), 240, 128)];
    //CGRect rect = CGRectMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame), 240, 128);
    //[self.tableView addSubview: showInfoView];
    
    CALayer *viewLayer = self.viewImageText.layer;
    [viewLayer setCornerRadius:10];
    [viewLayer setBorderWidth:0];
    [viewLayer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [viewLayer setMasksToBounds:YES];
    
    CALayer *viewLayerComment = self.addCommentTextView.layer;
    [viewLayerComment setCornerRadius:10];
    [viewLayerComment setBorderWidth:0];
    [viewLayerComment setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [viewLayerComment setMasksToBounds:YES];
    
    self.defectImageArray  = @[@"badroad",
                               @"holeonroad",
                               @"hatch",
                               @"holeinyard",
                               @"badrepair",
                               @"nomarking",
                               @"snow",
                               @"unfinished-repair",
                               @"sidewalk"];
    
    self.defectListDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Розбита дорога",               @"badroad",
                           @"Яма на дорозі",                @"holeonroad",
                           @"Люк",                          @"hatch",
                           @"Яма у дворі",                  @"holeinyard",
                           @"Неякісний ремонт дороги",      @"badrepair",
                           @"Відсутність розмітки",         @"nomarking",
                           @"Сніг",                         @"snow",
                           @"Незавершений ремонт дороги",   @"unfinished-repair",
                           @"Тротуар",                      @"sidewalk",
                           nil];
    
    self.addDefect = [[UADefect alloc] init];
    self.addDefect.user = [[UAUser alloc] init];
    self.addDefect.adress = [[UAAdress alloc] init];
    
    if (self.defectAdress) {
        self.addAdressTextLabel.text = self.defectAdress.adressFormat;
    }
    
    CALayer *imageLayer = self.addDefectImage.layer;
    [imageLayer setCornerRadius:10];
    [imageLayer setBorderWidth:0];
    [imageLayer setBorderColor:[ACTIVE_BACKGROUND CGColor]];
    [imageLayer setMasksToBounds:YES];
    
    CALayer *adressLayer = self.addAdressTextLabel.layer;
    [adressLayer setCornerRadius:10];
    [adressLayer setBorderWidth:1];
    [adressLayer setBorderColor:[ACTIVE_BACKGROUND CGColor]];
    [adressLayer setMasksToBounds:YES];
    /*
    CGRect frameRect = self.addCommentField.frame;
    frameRect.size.height = 83;
    self.addCommentField.frame = frameRect;
    self.addCommentField;
    */
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSDate* date = [NSDate date];
    NSDateFormatter* format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH:mm - dd.MM.yy"];
    self.addDateLabel.text = [format stringFromDate:date];
 /*
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    [tempImageView setFrame:self.tableView.frame];
    
    //self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = tempImageView;
*/
    
    UITapGestureRecognizer *tapGestureImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionAddPhotoButton:)];
    tapGestureImage.numberOfTapsRequired = 1;
    [self.addDefectImage addGestureRecognizer:tapGestureImage];
    self.addDefectImage.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureAdress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionAddAddressButton:)];
    tapGestureAdress.numberOfTapsRequired = 1;
    [self.addAdressTextLabel addGestureRecognizer:tapGestureAdress];
    self.addAdressTextLabel.userInteractionEnabled = YES;
    
}

- (void) viewDidAppear:(BOOL)animated {
    
    //[self loadAuthentification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LoadDialogAuthentification

- (void) loadAuthentification {
    
    NSDictionary* dict = [[UAUserDefaultSetting sharedManager] loadUserSetting];
    NSString* tempStr = [dict objectForKey:@"passwordhash"];

    if (tempStr.length == 0) {
        UAFirstViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UAFirstViewController"];
        [self presentViewController:vc animated:NO completion:nil];
    }

}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame: CGRectMake(0, 5, tableView.frame.size.width, 20.0)];
    sectionHeaderView.backgroundColor = TABLE_HEADER_BACKGROUND;
    
    //UIImageView* sectionHeaderView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 5, tableView.frame.size.width, 20.0)];
    //sectionHeaderView.image = [UIImage imageNamed:@"statusBarFolded.png"];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 0, sectionHeaderView.frame.size.width - 5, 20.0)];
    
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentLeft;
    headerLabel.font = [UIFont fontWithName:@"System" size:16.0];
    headerLabel.font = [headerLabel.font fontWithSize:16];
    [sectionHeaderView addSubview:headerLabel];
    
    headerLabel.text = [self.arrayHeader objectAtIndex:section];
    
    return sectionHeaderView;
}

/*
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:115 green:185 blue:240 alpha:0.1];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor orangeColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}
*/
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
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

/*- (void) backAddressBlock:(void(^)(UAAdress*))backAddress {
    
    self.addAdressTextLabel.text =
    
}*/

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    NSString *newText = [ textView.text stringByReplacingCharactersInRange: range withString: text ];
    
    if( [newText length] <= 210 ){
        
        textView.font = [UIFont systemFontOfSize:16];
        //NSLog(@"%d", [newText length]);
        return YES;
    }
    
    textView.text = [ newText substringToIndex: 210 ];
    
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"скористайтесь можливiстю додати свiй коментар"]) {
        
        textView.text = @"";
    }
}

#pragma mark - Action
- (IBAction)actionAddPhotoButton:(id)sender {
    
    //if you want to checkout how to config appearance, just uncomment the following 4 lines code.
#if 0
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker.png";
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    
        picker.maximumNumberOfSelectionPhoto = 10;
   
    [self presentViewController:picker animated:YES completion:^{
        
    }];
    
}

- (IBAction)actionAddAddressButton:(id)sender {
    
    
    
    UAAddMapViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UAAddMapViewController"];
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)actionUploadDefect:(UIButton *)sender {
    
    //[self.uploadActivityIndicator initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.uploadActivityIndicator startAnimating];
    [self.uploadActivityIndicator setColor:[UIColor redColor]];
    [self.uploadActivityIndicator setHidesWhenStopped:YES];
    
    self.uploadImageButton.hidden = YES;
    self.uploadButton.hidden = YES;
    
    [self performSelectorInBackground:@selector(uploadDefect) withObject:nil];
}

-(void) uploadDefect {
    
    NSDictionary* dict = [[UAUserDefaultSetting sharedManager] loadUserSetting];
    
    self.addDefect.user.login = [dict objectForKey:@"login"];
    self.addDefect.user.passwordhash = [dict objectForKey:@"passwordhash"];
    
    //self.addDefect.user.login           = @"PillerKOA";
    //self.addDefect.user.passwordhash    = @"483e0c483bb54c80ffd3f81589df6eef";
    //self.addDefect.adress.adressFormat      = self.defectAdress.adressFormat;
    //self.addDefect.adress.adressFormatxAL   = self.defectAdress.adressFormatxAL;
    //self.addDefect.latitude         = @"49.93428337284";
    //self.addDefect.longitude        = @"36.41086667776";
    //self.addDefect.commentfresh   = self.addCommentTextView.text;
    //self.addDefect.commentfresh     = @"Test comment";
    //self.addDefect.typeCode         = @"badroad";
    
    if (self.numberDefectType == 0) {
        self.addDefect.typeCode = @"";
    }else
        self.addDefect.typeCode = [self.defectImageArray objectAtIndex:self.numberDefectType - 1];
    
    if ([self.addCommentTextView.text isEqualToString:@"скористайтесь можливiстю додати свiй коментар"]) {
        
        self.addDefect.commentfresh = @"";
    }else
        self.addDefect.commentfresh = self.addCommentTextView.text;
    
    //self.addDefect.arrayAddImage    = self.arrayImage;
    
    if (([self.arrayImage count] == 0) ||
        ([self.addDefect.adress.adressFormatxAL isEqualToString:@"Натиснiть на фото чи адресу, щоб додати потрiбне"]) ||
        ([self.addDefect.typeCode length] == 0)) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Увага!"
                                                        message:@"Заповнiть всi обов'язковi поля з зiрочкою"
                                                       delegate:nil
                                              cancelButtonTitle:@"Добре"
                                              otherButtonTitles:nil];
        [alert show];
        
    }else {
        
        if ([self.arrayImage count] > 0) {
            
            dispatch_queue_t queue = dispatch_queue_create("com.ukryama.image.resize", DISPATCH_QUEUE_SERIAL);
            dispatch_sync(queue, ^{
                [self newArrayResizeImage];
            });
        }
        
        
    [[UAServerMeneger sharedMeneger] postUserDefectsAuthorize:self.addDefect
                                                    onSuccess:^(NSString *exit) {
                                                        
                                                       [self.uploadActivityIndicator stopAnimating];
                                                        
                                                    NSString* defectNumberStr = [NSString stringWithFormat:@"Дякуэмо! Заявка №%@ завантажена на сервер та успiшно додана в базу", exit];
                                                        
                                                        UIAlertView* final = [[UIAlertView alloc] initWithTitle:@"Успiх"
                                                                                                       message:defectNumberStr
                                                                                                      delegate:nil
                                                                                             cancelButtonTitle:@"Добре"
                                                                                             otherButtonTitles: nil];
                                                        [final show];
                                                        
                                                        dispatch_sync(dispatch_get_main_queue(), ^{
                                                            
                                                            self.addDefectImage.image = nil;
                                                            self.addDefectTextLabel.text = @"0";
                                                            self.addAdressTextLabel.text = @"Натиснiть на фото чи адресу, щоб додати потрiбне";
                                                            self.typeDefectLabel.text = @"Не вибрано";
                                                            self.addCommentTextView.text = @"скористайтесь можливiстю додати свiй коментар";
                                                            self.numberDefectType = 0;
                                                            self.addGeopositionImageView.hidden = NO;
                                                            self.addPhotoImageView.hidden = NO;
                                                            
                                                            for (UIButton* button in self.typeDefectButton) {
                                                                NSInteger index = button.tag;
                                                                NSString* imageName = [self.defectImageArray objectAtIndex:index - 1];
                                                                imageName = [imageName stringByAppendingString:@".png"];
                                                                UIImage* image = [UIImage imageNamed:imageName];
                                                                [button setImage:image forState:UIControlStateNormal];
                                                            }
                                                        });
                                                
                                                    }
                                                    onFailure:^(NSError *error, NSInteger statusCode) {
                                                        
                                                        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Помилка!"
                                                                                                            message:@"Стався збiй. Мережа iнтернет вiдсутня або сервер не вiдповiдаэ! Спробуйте пiзнiше."
                                                                                                           delegate:self
                                                                                                  cancelButtonTitle:@"Добре"
                                                                                                  otherButtonTitles:nil];
                                                        [alertView show];
                                                        
                                                    }];
        
    }
    
    self.uploadImageButton.hidden = NO;
    self.uploadButton.hidden = NO;
    [self.uploadActivityIndicator stopAnimating];
}

-(void) activeDefectButton:(UIButton*) sender {
    
    NSString* defectType = [self.defectImageArray objectAtIndex:(sender.tag - 1)];
    
    //делаем активной выбранную кнопку
    if (self.numberDefectType != sender.tag) {
        for (UIButton* button in self.typeDefectButton) {
            if (button.tag == sender.tag) {
                
                NSString* imageName = [defectType stringByAppendingString:@"-active.png"];
                UIImage* image = [UIImage imageNamed:imageName];
                [button setImage:image forState:UIControlStateNormal];
                
                self.numberDefectType = sender.tag;
                self.typeDefectLabel.text = [self.defectListDict objectForKey:defectType];
                self.typeDefectLabel.textColor = TEXT_ACTIVE;
            }
            //делаем неактивной все кнопки
            else
            {
                NSInteger index = button.tag;
                NSString* imageName = [self.defectImageArray objectAtIndex:index - 1];
                imageName = [imageName stringByAppendingString:@".png"];
                UIImage* image = [UIImage imageNamed:imageName];
                [button setImage:image forState:UIControlStateNormal];
            }
        }
        
    }//делаем неактивной выбранную кнопку
    else
        for (UIButton* button in self.typeDefectButton) {
            if ((button.tag == sender.tag) ) {
                
                NSString* imageName = [defectType stringByAppendingString:@".png"];
                UIImage* image = [UIImage imageNamed:imageName];
                [button setImage:image forState:UIControlStateNormal];
                
                self.numberDefectType = 0;
                self.typeDefectLabel.text = @"Не вибрано";
                self.typeDefectLabel.textColor = TEXT_NO_ACTIVE;
            }
        }
}

#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    self.addDefectImage.backgroundColor = [UIColor clearColor];
    DLog(@"assets %@",assets);
    if(assets.count == 1)
    {
        self.addDefectTextLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)assets.count];
    }
    else
    {
        self.addDefectTextLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)assets.count];
    }
    
    self.addPhotoImageView.hidden = YES;
    __weak typeof(self) weakSelf = self;
    
    self.arrayImage = [NSMutableArray array];
    
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            
            if (idx == 0) {
                weakSelf.addDefectImage.image = img;
            }
            
            [self.arrayImage addObject:img];
            
            if (idx == [assets count] - 1) {
                *stop = YES;
            }

            //*stop = YES;
        }];
    }
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedStringFromTable(@"Максимальна кiлькiсть", @"UzysAssetsPickerController", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - ResizeImage
- (UIImage*) resizeImage:(UIImage*) img {
    
    //NSLog(@"-----------------------------------------------");
    
    CGFloat imgHeight = img.size.height;
    CGFloat imgWidth = img.size.width;
    /*
    NSLog(@"Hight = %f, Width = %f", imgHeight, imgWidth);
    
    NSData *imageToUpload1 = UIImageJPEGRepresentation(img, 1);
    NSLog (@"Load 1,0 DATA: %d byte %d kbyte", imageToUpload1.length, imageToUpload1.length / SIDE_IMAGE);
    NSData *imageToUpload2 = UIImageJPEGRepresentation(img, 0.3);
    NSLog (@"Load 0,3 DATA: %d byte %d kbyte", imageToUpload2.length, imageToUpload2.length / SIDE_IMAGE);
    */
    CGFloat factor;
    
    if ((imgHeight > imgWidth) && (imgHeight > SIDE_IMAGE)) {
        factor = imgHeight / SIDE_IMAGE;
        
    }else if (imgWidth > SIDE_IMAGE) {
        factor = imgWidth / SIDE_IMAGE;
    }
    CGSize targetSize = CGSizeMake(imgWidth / factor, imgHeight / factor);
    UIGraphicsBeginImageContext(targetSize);
    CGRect rect = CGRectMake(0, 0, targetSize.width, targetSize.height);
    [img drawInRect:rect];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    imgHeight = img.size.height;
    imgWidth = img.size.width;
    /*
    NSLog(@"Hight = %f, Width = %f", imgHeight, imgWidth);
    
    imageToUpload1 = UIImageJPEGRepresentation(img, 1);
    NSLog (@"Load 1,0 DATA: %d byte %d kbyte", imageToUpload1.length, imageToUpload1.length / SIDE_IMAGE);
    imageToUpload2 = UIImageJPEGRepresentation(img, 0.3);
    NSLog (@"Load 0,3 DATA: %d byte %d kbyte", imageToUpload2.length, imageToUpload2.length / SIDE_IMAGE);
    */
    return img;
}

- (void) newArrayResizeImage {
    
    NSMutableArray* tmpArray = [NSMutableArray array];
    
    for (UIImage* img in self.arrayImage) {
        
        [tmpArray addObject:[self resizeImage:img]];
    }
    self.addDefect.arrayAddImage = tmpArray;
}

#pragma mark - UAAddMapViewControllerDelegate
- (void) backAddressVC:(UAAddMapViewController *)addMapVC address:(UAAdress *)address {
    
    self.addGeopositionImageView.hidden = YES;
    self.addDefect.adress = address;
    self.addAdressTextLabel.text = address.adressFormat;
    
}

@end
