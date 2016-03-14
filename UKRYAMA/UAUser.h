//
//  UAUser.h
//  UKRYAMA
//
//  Created by San on 01.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UAUser : NSObject

@property (strong, nonatomic) NSString* requesttime;
@property (strong, nonatomic) NSString* replytime;
@property (strong, nonatomic) NSString* userID;
@property (strong, nonatomic) NSString* usernameFull;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* secondname;
@property (strong, nonatomic) NSString* lastname;
@property (strong, nonatomic) NSString* passwordhash;
@property (strong, nonatomic) NSString* login;

- (id)initWithServerResponse:(NSData*) oResponseData;

@end

