//
//  UAAdress.m
//  UKRYAMA
//
//  Created by San on 03.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAAdress.h"

@implementation UAAdress

- (id)initWithServerResponse:(NSDictionary*) oResponseData
{
    self = [super init];
    if (self) {
        
        // Parsing XML
        
        
        NSArray *resultsArray = [oResponseData valueForKey:@"address_components"];
        NSArray* adressDic = [resultsArray objectAtIndex:0];
        
        for (NSDictionary* dict in adressDic) {
            
            //NSLog(@"dict %@", dict);
            NSMutableDictionary* tempDict = [NSMutableDictionary dictionary];
            
            [tempDict setValue:[dict valueForKey:@"long_name" ] forKey:@"long_name"];
            [tempDict setValue:[dict valueForKey:@"short_name"] forKey:@"short_name"];
            NSArray* typesKey = [dict valueForKey:@"types"];
            NSString* typString = [typesKey firstObject];
            
             //User info data
            
            if ([typString isEqual:@"street_number"])
                self.street_number = tempDict;
            else if ([typString isEqual:@"route"])
                    self.route = tempDict;
            else if ([typString isEqual:@"locality"])
                        self.locality = tempDict;
            else if ([typString isEqual:@"administrative_area_level_1"])
                            self.administrative_area = tempDict;
            else if ([typString isEqual:@"country"])
                                self.country = tempDict;

            
        }
        
        NSString* street_number         = [self.street_number        valueForKey:@"short_name"];
        NSString* route                 = [self.route                valueForKey:@"short_name"];
        NSString* locality              = [self.locality             valueForKey:@"short_name"];
        NSString* administrative_area   = [self.administrative_area  valueForKey:@"short_name"];
        
        NSString* adressString =[NSString stringWithFormat:@"%@, %@, %@, %@", administrative_area, locality, route, street_number];
        
        adressString = [adressString stringByReplacingOccurrencesOfString:@"(null), " withString:@""];
        adressString = [adressString stringByReplacingOccurrencesOfString:@", (null)" withString:@""];
        
        self.adressFormat = adressString;
        
        NSString* adressStringXAL =[NSString stringWithFormat:@"%@, місто %@, %@, %@", administrative_area, locality, route, street_number];
        
        adressStringXAL = [adressStringXAL stringByReplacingOccurrencesOfString:@"(null), " withString:@""];
        adressStringXAL = [adressStringXAL stringByReplacingOccurrencesOfString:@", (null)" withString:@""];
        
        self.adressFormatxAL = adressStringXAL;
    }
    
    return self;
}


@end
