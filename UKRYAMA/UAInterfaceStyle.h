//
//  UAInterfaceStyle.h
//  UKRYAMA
//
//  Created by San on 11.07.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Interface Color

#define TABLE_HEADER_BACKGROUND     [UIColor colorWithRed:218/255.f green:218/255.f blue:218/255.f alpha:1]
#define TEXT_NO_ACTIVE              [UIColor colorWithRed:106/255.f green:106/255.f blue:106/255.f alpha:1]
#define TEXT_ACTIVE                 [UIColor colorWithRed:204/255.f green:102/255.f blue:0/255.f alpha:1]
#define ACTIVE_BACKGROUND           [UIColor colorWithRed:255/255.f green:153/255.f blue:51/255.f alpha:1]

#define TEXT_COLOR_FIXED            [UIColor colorWithRed:82/255.f green:172/255.f blue:98/255.f alpha:0.3]
#define TEXT_COLOR_FRESH            [UIColor colorWithRed:208/255.f green:208/255.f blue:208/255.f alpha:0.5]
#define TEXT_COLOR_INPROGRESS       [UIColor colorWithRed:255/255.f green:153/255.f blue:51/255.f alpha:0.3]
#define TEXT_COLOR_ERROR            [UIColor colorWithRed:150/255.f green:60/255.f blue:60/255.f alpha:0.3]


#pragma mark - Code KEY

static NSString* kOrderTypeOrder        = @"order";
static NSString* kOrderTypePreorder     = @"preorder";
static NSString* kOrderTypeReservation  = @"reservation";

@interface UAInterfaceStyle : NSObject

@end
