//
//  UAListDefectViewCell.h
//  UKRYAMA
//
//  Created by San on 02.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UAListDefectViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *defectImage;
@property (weak, nonatomic) IBOutlet UILabel *defectDate;
@property (weak, nonatomic) IBOutlet UILabel *defectAdress;

@property (weak, nonatomic) IBOutlet UIImageView *defectStatusImage;
@property (weak, nonatomic) IBOutlet UILabel *defectStatusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *defectMessageImage;
@property (weak, nonatomic) IBOutlet UILabel *defectMessageLabel;

@property (weak, nonatomic) IBOutlet UIImageView *defectTypeImage;


@end
