//
//  UAUserDefaultSetting.h
//  UKRYAMA
//
//  Created by San on 03.07.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UAUserDefaultSetting : NSObject

+ (UAUserDefaultSetting*) sharedManager;

//Сохранение или загрузка данных пользователя
- (void) saveUserSetting:(BOOL)save login:(NSString*)login passwordhash:(NSString*)passwordhash;
- (NSDictionary*) loadUserSetting;

//Сохранение данных юзера
- (void) saveUserInfoID:(NSString*)userID userNameFull:(NSString*) userName;
- (NSDictionary*) loadUserInfo;

//Запоминать ли фильтра
- (void) saveFilterON:(BOOL)filter;
- (BOOL) loadFilterON;

//Сохраненные фильтра
- (void) saveMyList:(BOOL)myList city:(NSString *)city state:(NSString *)state type:(NSString *) type;
- (NSDictionary*) loadFilter;

@end
