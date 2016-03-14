//
//  UAServerMeneger.h
//  UKRYAMA
//
//  Created by San on 31.03.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UADefect, UAUser;

@interface UAServerMeneger : NSObject <NSXMLParserDelegate>

#define UKRYAMA                 @"http://ukryama.com"
#define UPLOAD_IMAGE_QUALITY    0.3f
#define SIDE_IMAGE              1024

+ (UAServerMeneger*) sharedMeneger;

//Авторизация
- (void) getUserAuthorize:(NSString*) login
           passwordString:(NSString*) password
                onSuccess: (void(^)(UAUser* user)) success
                onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure;

//Запрос CheckAuth
- (void) getUserCheckAuth:(NSString*) login
           passwordString:(NSString*) passwordhash
                onSuccess: (void(^)(BOOL result)) success
                onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure;

//Запрос exit
- (void) getUserExit:(NSString*) login
           onSuccess: (void(^)(BOOL result)) success
           onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure;


//Not work request
//Профиль пользователя
- (void) postUserDetailInfo:(NSString*) userID
                  onSuccess: (void(^)(NSString* exit)) success
                  onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure;

//Список дефектов  /?filter_type=holeonroad&filter_status=fixed
- (void) getDefectsList:(NSString*) limit
                 offset:(NSString*) offset
                 filter:(NSString*) filterDefect
              onSuccess: (void(^)(NSArray* defectListArray)) success
              onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure;

//Список дефектов, выложенных на сайт пользователем
- (void) postUserDefectsList:(NSString*) login
              passwordString:(NSString*) passwordhash
                   onSuccess: (void(^)(NSString* exit)) success
                   onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure;

//Просмотр карточки дефекта с правами пользователя
- (void) postUserDefectsAuthorize:(NSString*) login
                   passwordString:(NSString*) passwordhash
                     numberDefect:(NSString*) number
                        onSuccess: (void(^)(NSString* exit)) success
                        onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure;

//Работа с дефектами. Добавление дефекта
- (void) postUserDefectsAuthorize:(UADefect*) defect
                        onSuccess: (void(^)(NSString* exit)) success
                        onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure;

/*
 login: <логин пользователя>
	passwordhash: <хэш пароля>
	address: <адрес ямы, желательно в формате xAL>
	latitude: <широта дефекта>
	longitude: <долгота дефекта>
	comment: <комментарий пользователя к дефекту>
	type: <тип дефекта>
 */




//Запрос GetFileUploadLimits

//Изменение дефекта

//Вызов GetUpdateMethods
//Метод обновления дефекта update
//Метод обновления дефекта set_inprogress
//Метод обновления дефекта revoke
//Метод обновления дефекта set_replied
//Метод обновления дефекта set_fixed
//Метод обновления дефекта to_prosecutor
//Метод обновления дефекта revoke_p
//Удаление дефекта
//Геокодирование

//Получение с сервера PDF
//Формирование и получение с сервера жалобы в ГАИ
//Формирование и получение с сервера заявления в прокуратуру
@end
