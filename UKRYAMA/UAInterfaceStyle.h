//
//  UAInterfaceStyle.h
//  UKRYAMA
//
//  Created by San on 11.07.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Device

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


#pragma mark - Interface Color

#define TABLE_HEADER_BACKGROUND     [UIColor colorWithRed:218/255.f green:218/255.f blue:218/255.f alpha:1]
#define TEXT_NO_ACTIVE              [UIColor colorWithRed:106/255.f green:106/255.f blue:106/255.f alpha:1]
#define TEXT_ACTIVE                 [UIColor colorWithRed:204/255.f green:102/255.f blue:0/255.f alpha:1]
#define ACTIVE_BACKGROUND           [UIColor colorWithRed:255/255.f green:153/255.f blue:51/255.f alpha:1]

#define TEXT_COLOR_FIXED            [UIColor colorWithRed:82/255.f green:172/255.f blue:98/255.f alpha:0.3]
#define TEXT_COLOR_FRESH            [UIColor colorWithRed:208/255.f green:208/255.f blue:208/255.f alpha:0.5]
#define TEXT_COLOR_INPROGRESS       [UIColor colorWithRed:255/255.f green:153/255.f blue:51/255.f alpha:0.3]
#define TEXT_COLOR_ERROR            [UIColor colorWithRed:150/255.f green:60/255.f blue:60/255.f alpha:0.3]




@interface UAInterfaceStyle : NSObject

@end
