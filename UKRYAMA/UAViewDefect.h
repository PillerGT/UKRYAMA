//
//  UAViewDefect.h
//  UKRYAMA
//
//  Created by San on 14.10.15.
//  Copyright © 2015 San. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UADefect.h"
#import "UAAdress.h"

@interface UAViewDefect : UIViewController

@property (strong, nonatomic) UADefect* defectView;

@property (weak, nonatomic) IBOutlet UINavigationBar *defectMenu;
@property (weak, nonatomic) IBOutlet UILabel *defectAdress;
@property (weak, nonatomic) IBOutlet UILabel *defectType;
@property (weak, nonatomic) IBOutlet UILabel *defectStatus;
@property (weak, nonatomic) IBOutlet UIImageView *defectImage;
@property (weak, nonatomic) IBOutlet UILabel *defectDateFresh;
@property (weak, nonatomic) IBOutlet UILabel *defectDateFixed;
@property (weak, nonatomic) IBOutlet UIPageControl *defectImagePage;
@property (weak, nonatomic) IBOutlet UITextView *defectComment;
@property (weak, nonatomic) IBOutlet UIView *defectViewType;
@property (weak, nonatomic) IBOutlet UIView *defectViewStatus;
@property (weak, nonatomic) IBOutlet UIView *defectViewDateFresh;
@property (weak, nonatomic) IBOutlet UIView *defectViewDateFixed;

@property (weak, nonatomic) IBOutlet UIImageView *defectIconImageView;
@property (weak, nonatomic) IBOutlet UIView *defectHeaderView;



- (IBAction)actionBackButton:(id)sender;

@end
