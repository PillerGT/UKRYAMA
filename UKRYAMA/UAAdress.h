//
//  UAAdress.h
//  UKRYAMA
//
//  Created by San on 03.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UAAdress : NSObject

@property (strong, nonatomic) NSDictionary* street_number;                  //номер дома
@property (strong, nonatomic) NSDictionary* route;                          //улица
@property (strong, nonatomic) NSDictionary* locality;                       //город
@property (strong, nonatomic) NSDictionary* administrative_area;            //область
@property (strong, nonatomic) NSDictionary* country;                        //страна

@property (strong, nonatomic) NSString* adressFormat;                       //отформатированная строка адреса
@property (strong, nonatomic) NSString* adressFormatxAL;                    //отформатированная строка адреса в xAL

@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;


- (id)initWithServerResponse:(NSDictionary*) oResponseData;

@end
