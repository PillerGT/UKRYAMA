//
//  UADefect.h
//  UKRYAMA
//
//  Created by San on 01.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TBXML.h"

@class UAUser, UAAdress;

@interface UADefect : NSObject

@property (strong, nonatomic) NSString* holeID;                 //номер дефекта
@property (strong, nonatomic) NSString* archive;                //находится ли яма в архиве (boolean)
@property (strong, nonatomic) UAUser*   user;                   //пользователь
@property (strong, nonatomic) NSString* latitude;               //широта дефекта
@property (strong, nonatomic) NSString* longitude;              //долгота дефекта
@property (strong, nonatomic) UAAdress* adress;                 //адрес ямы, желательно в формате xAL

@property (strong, nonatomic) NSString* stateCode;              //код статуса дефекта
@property (strong, nonatomic) NSString* stateCodeName;          //название статуса
@property (strong, nonatomic) NSString* typeCode;               //код типа дефекта
@property (strong, nonatomic) NSString* typeCodeName;           //название типа

@property (strong, nonatomic) NSString* datecreated;            //читабельный вид
@property (strong, nonatomic) NSString* datecreatedReadable;    //дата создания дефекта
@property (strong, nonatomic) NSString* datesent;               //читабельный вид
@property (strong, nonatomic) NSString* datesentReadable;       //дата отправки заявления в ГАИ
@property (strong, nonatomic) NSString* datestatus;             //читабельный вид
@property (strong, nonatomic) NSString* datestatusReadable;     //дата простановки текущего статуса

@property (strong, nonatomic) NSString* commentfresh;           //комментарий пользователя к дефекту
@property (strong, nonatomic) NSString* commentfixed;           //комментарий, который пользователь оставляет при отметке дефекта, как починенного
@property (strong, nonatomic) NSString* commentgibddre;         //комментарий, который пользователь оставляет при простановке статуса «пришёл ответ из ГАИ»
@property (strong, nonatomic) NSString* commentmessages;        //количество сообщений пользователей в карточке дефекта

@property (strong, nonatomic) NSDictionary*  pictureOriginal;   //картинки оригинального размера
@property (strong, nonatomic) NSDictionary*  pictureMedium;     //картинки среднего размера, которые показываются на сайте внутри карточки дефекта
@property (strong, nonatomic) NSDictionary*  pictureSmall;      //картинки маленького размера

//gibddrequests                                                 //запросы в ГАИ
@property (strong, nonatomic) NSString*  requestID;             //ID запроса
@property (strong, nonatomic) NSString*  gibddID;               //ID ГАИ
@property (strong, nonatomic) NSString*  date;                  //время отправки
@property (strong, nonatomic) NSString*  userID;                //id пользователя
@property (strong, nonatomic) NSString*  userName;              //имя пользователя

@property (strong, nonatomic) NSString*  answeID;               //Ответ из ГАИ
@property (strong, nonatomic) NSString*  ansverDate;            //его время

@property (strong, nonatomic) NSString*  fileID;                //Один из загруженых файлов
@property (strong, nonatomic) NSString*  type;                  //допустимые типы "image", "application/pdf" и "text/plain"

@property (strong, nonatomic) NSArray* arrayAddImage;           //Список картинок для загрузки на сервер
@property (weak, nonatomic)   UIImage* imageDefect;             //Фото дефекта



- (id)initWithServerResponse:(TBXMLElement*) oResponseData;

@end
