//
//  UAListDefectViewController.m
//  UKRYAMA
//
//  Created by San on 02.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAListDefectViewController.h"
#import "UAListDefectViewCell.h"
#import "UAFilterDefectViewController.h"
#import "UAServerMeneger.h"
#import "UIImageView+AFNetworking.h"
#import "GoogleMaps/GoogleMaps.h"
#import "UAUserDefaultSetting.h"
#import "UAViewDefect.h"
#import "UADefect.h"
#import "UAAdress.h"
#import "UAFilter.h"

@interface UAListDefectViewController () <UAFilterDefectViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray* defectListArray;
@property (strong, nonatomic) UADefect* defect;
@property (strong, nonatomic) UAFilter* filterDefect;
@property (assign, nonatomic) BOOL loadListDefect;

@end

@implementation UAListDefectViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.defectListArray = [NSMutableArray array];
    
    
    
    //self.filterDefect.filterFinalRequest =
    
    [self finalRequest];
    
    self.loadListDefect = YES;
    
    [self getLoadDefectList];
    /*
    dispatch_queue_t queue = dispatch_queue_create("com.ukryama.load.list", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        [self getLoadDefectList];
    });
    */
}

- (void) viewDidAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) finalRequest {
    
    if ([[UAUserDefaultSetting sharedManager] loadFilterON]) {
        
        NSDictionary* filterDict = [[UAUserDefaultSetting sharedManager] loadFilter];
        NSString* filterFinalRequest = nil;
        
        if ([[filterDict objectForKey:@"myList"] isEqualToString:@"1"]) {
            NSDictionary* dict = [[UAUserDefaultSetting sharedManager] loadUserSetting];
            NSString* login         = [dict objectForKey:@"login"];
            NSString* passwordhash  = [dict objectForKey:@"passwordhash"];
            NSString* tempStr = [NSString stringWithFormat:@"/my/?login=%@&passwordhash=%@", login, passwordhash];
            
            filterFinalRequest = tempStr;
        }else
            filterFinalRequest = @"/?";
        
        if ([[filterDict objectForKey:@"city"] length] > 0) {
            //self.filter.filter_city = self.adressTextField.text;
            //NSString* nameCityCode = [filterDict objectForKey:@"city"];
            NSString* cityRequest = [@"filter_city=" stringByAppendingString:[filterDict objectForKey:@"city"]];
            filterFinalRequest = [filterFinalRequest stringByAppendingString:cityRequest];
        };
        
        if ([[filterDict objectForKey:@"state"] length] > 0) {
            //self.filter.filter_status = [self.stateListArray objectAtIndex:self.numberDefectState];
            NSString* stateRequest = [@"&filter_status=" stringByAppendingString:[filterDict objectForKey:@"state"]];
            filterFinalRequest = [filterFinalRequest stringByAppendingString:stateRequest];
        };
        
        if ([[filterDict objectForKey:@"type"] length] > 0) {
            //self.filter.filter_type = [self.defectImageArray objectAtIndex:self.numberDefectType - 1];
            NSString* typeRequest = [@"&filter_type=" stringByAppendingString:[filterDict objectForKey:@"type"]];
            filterFinalRequest = [filterFinalRequest stringByAppendingString:typeRequest];
        };
        
        filterFinalRequest = [filterFinalRequest stringByReplacingOccurrencesOfString:@"/?&" withString:@"/?"];
        
        if (filterFinalRequest.length == 4) {
            filterFinalRequest = [filterFinalRequest substringToIndex:3];
        }
        
        self.filterDefect = [[UAFilter alloc] init];
        self.filterDefect.filterFinalRequest = filterFinalRequest;
    }
}

- (void) getLoadDefectList {
    
    NSInteger limit = 10;

    if (self.loadListDefect) {
        
        //[self.loadActivityIndicator initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [self.loadActivityIndicator startAnimating];
        [self.loadActivityIndicator setColor:[UIColor redColor]];
        [self.loadActivityIndicator setHidesWhenStopped:YES];
    
    [[UAServerMeneger sharedMeneger] getDefectsList:[NSString stringWithFormat:@"%d", limit ]
                                             offset:[NSString stringWithFormat:@"%d", [self.defectListArray count] ]
                                             filter:self.filterDefect.filterFinalRequest
                                          onSuccess:^(NSArray *defectListArray) {
                                              
                                              //self.defectListArray = defectListArray;
                                              
                                              dispatch_queue_t queue = dispatch_queue_create("com.ukryama.load.list", DISPATCH_QUEUE_SERIAL);
                                              dispatch_async(queue, ^{
                                                  
                                              
                                              
                                              UADefect* tmpDefect = [self.defectListArray lastObject];
                                              int lastNumber = [tmpDefect.holeID intValue];
                                              
                                              NSMutableArray* tmpArray = [NSMutableArray array];
                                              [tmpArray addObjectsFromArray: defectListArray ];
                                              for (UADefect* defect in defectListArray) {
                                                  if (([defect.holeID intValue] >= lastNumber) && (lastNumber != 0)) {
                                                      [tmpArray removeObject:defect];
                                                  }
                                              }
                                              
                                              //defectListArray = tmpArray;
                                              
                                              [self.defectListArray addObjectsFromArray:tmpArray];
                                              NSMutableArray* newPaths = [NSMutableArray array];
                                              
                                              for (int i = (int)[self.defectListArray count] - (int)[tmpArray count]; i < [self.defectListArray count]; i++) {
                                                  [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
                                              }
                                              /*
                                              [self.tableView beginUpdates];
                                              [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationTop];
                                              [self.tableView endUpdates];*/
                                                  
                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                      if ([self.defectListArray count] <= limit) {
                                                          [self.tableView setContentOffset: CGPointMake(0,
                                                                                                        - self.navigationController.navigationBar.frame.origin.y
                                                                                                        - self.navigationController.navigationBar.frame.size.height)];
                                                      }
                                                      [self.tableView reloadData];
                                                      [self.loadActivityIndicator stopAnimating];
                                                  });
                                              //[self.tableView reloadData];
                                                  
                                                  if ([tmpArray count] < limit) {
                                                      self.loadListDefect = NO;
                                                  }else
                                                      self.loadListDefect = YES;
                                                  
                                                  });
                                              
                                              //[self.loadActivityIndicator stopAnimating];
                                              
                                              
                                              
                                          }
                                          onFailure:^(NSError *error, NSInteger statusCode) {
                                              
                                              //[self.loadActivityIndicator stopAnimating];
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [self.tableView setContentOffset: CGPointMake(0,
                                                                                                - self.navigationController.navigationBar.frame.origin.y
                                                                                                - self.navigationController.navigationBar.frame.size.height)];
                                                  [self.tableView reloadData];
                                                  [self.loadActivityIndicator stopAnimating];
                                                  
                                                  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Помилка!"
                                                                                                      message:@"Стався збiй. Мережа iнтернет вiдсутня або сервер не вiдповiдаэ! Спробуйте пiзнiше."
                                                                                                     delegate:self
                                                                                            cancelButtonTitle:@"Добре"
                                                                                            otherButtonTitles:nil];
                                                  [alertView show];
                                              });
                                              
                                          }];
    }
}

#pragma mark - UAFilterDefectViewControllerDelegate

- (void) filterVC:(UAFilterDefectViewController*)vc filter:(UAFilter*) filter {
    
    self.filterDefect = filter;
    self.loadListDefect = YES;
    
    [self.defectListArray removeAllObjects];
    [self getLoadDefectList];    
}

#pragma mark - Support function
- (void) loadImage:(UIImageView*) imageView fromString:(NSString*) stringPath{
    
    CALayer *imageLayer = imageView.layer;
    [imageLayer setCornerRadius:10];
    [imageLayer setBorderWidth:1];
    [imageLayer setBorderColor:[[UIColor grayColor] CGColor]];
    [imageLayer setMasksToBounds:YES];
    
    //NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:picture]];
    
    NSURL* url = [NSURL URLWithString:stringPath];
    NSURLRequest* request  =  [ NSURLRequest  requestWithURL: url
                                                 cachePolicy: NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval: 432000];
    
    __weak UIImageView *weakImageView = imageView;
    weakImageView.image = nil;
    
    [weakImageView setImageWithURLRequest:request
                            placeholderImage:nil
                                     success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                         
                                         weakImageView.image = image;
                                         //weakImageView.frame = CGRectMake(8, 8, 140, 110);
                                         
                                         [UIView transitionWithView:weakImageView
                                                           duration:0.3f
                                                            options:UIViewAnimationOptionTransitionCrossDissolve
                                                         animations:^{
                                                             weakImageView.image = image;
                                                         } completion:NULL];
                                         
                                     }
                                     failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                         
                                     }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.defectListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* identifier = @"DefectCell";
    
    UAListDefectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UAListDefectViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UADefect* defect = [self.defectListArray objectAtIndex:indexPath.row];
    
    cell.defectDate.text = defect.datecreatedReadable;
    cell.defectAdress.text = defect.adress.adressFormat;
    cell.defectStatusLabel.text = defect.stateCodeName;
    cell.defectMessageLabel.text = defect.commentmessages;
    
    NSString* stateCode = [NSString stringWithFormat:@"%@Dots", defect.stateCode];
    cell.defectStatusImage.image = [UIImage imageNamed:stateCode];
    
    NSString* defectType = [NSString stringWithFormat:@"%@.png", defect.typeCode];
    cell.defectTypeImage.image = [UIImage imageNamed:defectType];
    
    NSString* message = nil;
    if ([defect.commentmessages intValue] == 0) {
        message = [NSString stringWithFormat:@"Message00"];
    }else
        message = [NSString stringWithFormat:@"Message11"];
    cell.defectMessageImage.image = [UIImage imageNamed:message];
    
    NSDictionary* dictStatusPic = [defect.pictureSmall objectForKey:@"fresh"];
    NSArray* pictureArray = [dictStatusPic allValues];
    NSString* picture = [NSString stringWithFormat:@"%@%@", UKRYAMA, [pictureArray firstObject]];
    
    if (indexPath.row == [self.defectListArray count] - 3) {
        [self getLoadDefectList];
    }
    
    [self loadImage:cell.defectImage fromString:picture];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UAViewDefect* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UAViewDefect"];
    vc.defectView = [self.defectListArray objectAtIndex:indexPath.row];
    [self presentViewController:vc animated:YES completion:nil];
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}

/*
- (NSString*) adressForCoordinate:(NSString*) latitude  longitude:(NSString*) longitude{
    
    __block NSString* adressString;

    [self adressForCoordinate2:latitude
                     longitude:longitude
                       success:^(NSString *adressString2) {
                           self.adressString = adressString2;
                       }
                       failure:^(NSError *error) {
                           
                       }];*/
    /*
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue])
                                   completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
                                       NSLog(@"reverse geocoding results:");
                                       //NSLog( @"%@" , response.firstResult.addressLine1 ) ;
                                       //NSLog( @"%@" , response.firstResult.addressLine2 ) ;
                                       GMSAddress* addressObj = [response firstResult];
                                       //NSLog(@"lines=%@", addressObj.lines);
                                       
                                       
                                       self.adressString = [NSString stringWithFormat:@"%@ %@", addressObj.lines.firstObject, addressObj.lines.lastObject];
                                       NSLog(@"lines=%@", self.adressString);
                                       

                                   }];
*/
/*
    return adressString;
}
*/
- (void)adressForCoordinate2:(NSString*) latitude
                   longitude:(NSString*) longitude
                     success:(void (^)(NSString* adressString2))success
                     failure:(void (^)(NSError *error))failure {
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue])
                                   completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {

                                       
        if (failure) {
            failure(error);
        }
            NSLog(@"reverse geocoding results:");
            //NSLog( @"%@" , response.firstResult.addressLine1 ) ;
            //NSLog( @"%@" , response.firstResult.addressLine2 ) ;
            GMSAddress* addressObj = [response firstResult];
            if(success)
                success([NSString stringWithFormat:@"%@ %@", addressObj.lines.firstObject, addressObj.lines.lastObject]);
        
    }];
}

#pragma mark - NavigationSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UAFilterDefectViewController* vc = [segue destinationViewController];
    vc.delegate = self;
    [vc setFilter:self.filterDefect];
    
}

@end
