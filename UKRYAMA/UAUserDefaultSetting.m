//
//  UAUserDefaultSetting.m
//  UKRYAMA
//
//  Created by San on 03.07.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAUserDefaultSetting.h"

static NSString* kSave              = @"save";
static NSString* kUserLogin         = @"login";
//static NSString* kUserPassword      = @"password";
static NSString* kUserPasswordhash  = @"passwordhash";

static NSString* kUserID            = @"userID";
static NSString* kUserNameFull      = @"userNameFull";

static NSString* kFilterON          = @"filter";
static NSString* kCity              = @"city";
static NSString* kState             = @"state";
static NSString* kType              = @"type";
static NSString* kMyList            = @"myList";

@interface UAUserDefaultSetting()

@property (strong, nonatomic) NSUserDefaults* userDef;

@end

@implementation UAUserDefaultSetting

+ (UAUserDefaultSetting*) sharedManager {
    
    static UAUserDefaultSetting* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UAUserDefaultSetting alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.userDef = [[NSUserDefaults alloc] init];
    }
    return self;
}

#pragma mark - UserSettings
- (void) saveUserSetting:(BOOL)save
                   login:(NSString*)login
            passwordhash:(NSString*)passwordhash; {
    
    [self.userDef setValue:[NSString stringWithFormat:@"%hhd", save] forKey:kSave];
    
    [self.userDef setValue:login        forKey:kUserLogin];
 //   [self.userDef setValue:password     forKey:kUserPassword];
    [self.userDef setValue:passwordhash forKey:kUserPasswordhash];
    
    [self.userDef synchronize];
}

- (NSDictionary*) loadUserSetting {
    
    NSMutableDictionary* tempDict = [NSMutableDictionary dictionary];
    
    if ([self.userDef objectForKey:kUserPasswordhash]) {
        
        [tempDict setObject:[self.userDef objectForKey:kSave]                forKey:kSave];
        [tempDict setObject:[self.userDef objectForKey:kUserLogin]           forKey:kUserLogin];
        //    [tempDict setObject:[self.userDef objectForKey:kUserPassword]        forKey:kUserPassword];
        [tempDict setObject:[self.userDef objectForKey:kUserPasswordhash]    forKey:kUserPasswordhash];
        
    }else
        
        [tempDict setObject:@""    forKey:kUserPasswordhash];
    
    return tempDict;
}

#pragma mark - UserInfo
//Сохранение данных юзера
- (void) saveUserInfoID:(NSString*)userID userNameFull:(NSString*) userName{
    
    [self.userDef setValue:userID       forKey:kUserID];
    [self.userDef setValue:userName     forKey:kUserNameFull];
    [self.userDef synchronize];
}

- (NSDictionary*) loadUserInfo{
    
    NSMutableDictionary* temDict = [NSMutableDictionary dictionary];
    [temDict setObject:[self.userDef objectForKey:kUserID]       forKey:kUserID];
    [temDict setObject:[self.userDef objectForKey:kUserNameFull] forKey:kUserNameFull];
    return temDict;
}

#pragma mark - FilterSettings
- (void) saveFilterON:(BOOL)filter {
    
    [self.userDef setValue:[NSString stringWithFormat:@"%hhd", filter ]   forKey:kFilterON];
    [self.userDef synchronize];
}

- (BOOL) loadFilterON  {
    
    BOOL status;
    status = [[self.userDef objectForKey:kFilterON] boolValue];
    return status;
}

- (void) saveMyList:(BOOL) myList
               city:(NSString *) city
              state:(NSString *) state
               type:(NSString *) type {
    
    [self.userDef setValue:city     forKey:kCity];
    [self.userDef setValue:state    forKey:kState];
    [self.userDef setValue:type     forKey:kType];
    [self.userDef setValue:[NSString stringWithFormat:@"%hhd", myList ]   forKey:kMyList];
    [self.userDef synchronize];
}

- (NSDictionary*) loadFilter {
    
    NSMutableDictionary* tempDict = [NSMutableDictionary dictionary];
    
    [tempDict setObject:[self.userDef objectForKey:kCity]       forKey:kCity];
    [tempDict setObject:[self.userDef objectForKey:kState]      forKey:kState];
    [tempDict setObject:[self.userDef objectForKey:kType]       forKey:kType];
    [tempDict setObject:[self.userDef objectForKey:kMyList]     forKey:kMyList];
    
    return tempDict;
}


@end
