//
//  UAFilter.h
//  UKRYAMA
//
//  Created by San on 06.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UAFilter : NSObject

@property (strong, nonatomic) NSString* myDefect;               //  Мои дефекты

@property (strong, nonatomic) NSString* filter_city;            //	Фильтр по названию города (или по его началу)
@property (strong, nonatomic) NSString* filter_status;          //  Фильтр по статусам дефектов.
@property (strong, nonatomic) NSString* filter_type;            //  Фильтр по типу дефектов.
@property (strong, nonatomic) NSString* limit;                  //  Количество возвращаемых дефектов.
@property (strong, nonatomic) NSString* offset;                 //  Количество дефектов между первым по порядку и первым возвращённым в выборке.
@property (strong, nonatomic) NSString* page;                   //  Переопределяет параметры limit и offset. То есть нумерация страниц начинается с ноля.
@property (strong, nonatomic) NSString* archive;                //  Показывать ямы из архива
@property (strong, nonatomic) NSString* polygons;               //  Вывести ямы по определенной территории.

@property (strong, nonatomic) NSString* filterFinalRequest;     //  Финальный собраный запрос для фильтрации

@end
