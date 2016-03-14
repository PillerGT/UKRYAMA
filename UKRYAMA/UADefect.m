//
//  UADefect.m
//  UKRYAMA
//
//  Created by San on 01.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UADefect.h"
#import "UAUser.h"
#import "TBXML.h"
#import "GoogleMaps/GoogleMaps.h"
#import "UAAdress.h"

@implementation UADefect


- (id)initWithServerResponse:(TBXMLElement*) hole
{
    self = [super init];
    if (self) {
        
        // Parsing XML
        
        TBXMLElement *holeID            = [TBXML childElementNamed:@"id"            parentElement:hole];

        TBXMLElement *username          = [TBXML childElementNamed:@"username"      parentElement:hole];
        TBXMLElement *name              = [TBXML childElementNamed:@"name"          parentElement:username];
        TBXMLElement *secondname        = [TBXML childElementNamed:@"secondname"    parentElement:username];
        TBXMLElement *lastname          = [TBXML childElementNamed:@"lastname"      parentElement:username];
        
        TBXMLElement *latitude          = [TBXML childElementNamed:@"latitude"      parentElement:hole];
        TBXMLElement *longitude         = [TBXML childElementNamed:@"longitude"     parentElement:hole];
        
        TBXMLElement *state             = [TBXML childElementNamed:@"state"         parentElement:hole];
        TBXMLElement *type              = [TBXML childElementNamed:@"type"          parentElement:hole];
        
        TBXMLElement *datecreated       = [TBXML childElementNamed:@"datecreated"   parentElement:hole];
        TBXMLElement *datestatus        = [TBXML childElementNamed:@"datestatus"    parentElement:hole];
        
        TBXMLElement *commentfresh      = [TBXML childElementNamed:@"commentfresh"  parentElement:hole];
        TBXMLElement *commentfixed      = [TBXML childElementNamed:@"commentfixed"  parentElement:hole];
        TBXMLElement *commentgibddre    = [TBXML childElementNamed:@"commentgibddre"parentElement:hole];
        
        TBXMLElement *pictures          = [TBXML childElementNamed:@"pictures"      parentElement:hole];
        
        TBXMLElement *original          = [TBXML childElementNamed:@"original"      parentElement:pictures];
        TBXMLElement *medium            = [TBXML childElementNamed:@"medium"        parentElement:pictures];
        TBXMLElement *small             = [TBXML childElementNamed:@"small"         parentElement:pictures];
        
        //TBXMLElement *gibddrequests = [TBXML childElementNamed:@"gibddrequests" parentElement:hole];
        
        //User info data
        
        self.holeID             = [TBXML textForElement:holeID];
        
        self.user = [[UAUser alloc] init];
        
        self.user.usernameFull  = [TBXML textForElement:username];
        self.user.name          = [TBXML textForElement:name];
        self.user.secondname    = [TBXML textForElement:secondname];
        self.user.lastname      = [TBXML textForElement:lastname];
        
        self.latitude           = [TBXML textForElement:latitude];
        self.longitude          = [TBXML textForElement:longitude];
        
        self.adress = [self adressSearchLatitude:self.latitude longitude:self.longitude];
        
        self.stateCode          = [TBXML valueOfAttributeNamed:@"code" forElement:state];
        self.stateCodeName      = [TBXML textForElement:state];
        self.typeCode           = [TBXML valueOfAttributeNamed:@"code" forElement:type];
        self.typeCodeName       = [TBXML textForElement:type];
        
        self.datecreated        = [TBXML textForElement:datecreated];
        self.datecreatedReadable= [TBXML valueOfAttributeNamed:@"readable" forElement:datecreated];
        self.datestatus         = [TBXML textForElement:datestatus];
        self.datestatusReadable = [TBXML valueOfAttributeNamed:@"readable" forElement:datestatus];
        
        self.commentfresh       = [TBXML textForElement:commentfresh];
        self.commentfixed       = [TBXML textForElement:commentfixed];
        self.commentgibddre     = [TBXML textForElement:commentgibddre];
        
        NSInteger messages = 0;
        if (self.commentfresh.length > 0) {
            messages++;
        }
        if (self.commentfixed.length > 0) {
            messages++;
        }
        self.commentmessages = [NSString stringWithFormat:@"%d", messages];
        
        self.pictureOriginal    = [self xmlParsePicture:original];
        self.pictureMedium      = [self xmlParsePicture:medium];
        self.pictureSmall       = [self xmlParsePicture:small];
        
    }
    return self;
}


//Parsing picture
- (NSDictionary*) xmlParsePicture:(TBXMLElement*) quality {
    
    NSMutableDictionary* picQuality  = [[NSMutableDictionary alloc] init];
    
    TBXMLElement *fresh     = [TBXML childElementNamed:@"fresh"     parentElement:quality];
    TBXMLElement *fixed     = [TBXML childElementNamed:@"fixed"     parentElement:quality];
    
    [picQuality setObject:[self xmlFreshOrFixedPicture:fresh] forKey:@"fresh"];
    [picQuality setObject:[self xmlFreshOrFixedPicture:fixed] forKey:@"fixed"];
    
    return picQuality;
}

- (NSDictionary*) xmlFreshOrFixedPicture:(TBXMLElement*) statusPic {
    
    NSMutableDictionary* picStatus  = [[NSMutableDictionary alloc] init];
    
    TBXMLElement* picSCR    = [TBXML childElementNamed:@"src"       parentElement:statusPic];
    
    while (picSCR) {
        
        NSString* picID     = [TBXML valueOfAttributeNamed:@"id"    forElement:picSCR];
        NSString* picPath   = [TBXML textForElement:picSCR];
        
        [picStatus setObject:picPath forKey:picID];
        
        picSCR = [TBXML nextSiblingNamed:@"src" searchFromElement:picSCR];
    }
    
    return picStatus;
    
}


- (UAAdress*) adressSearchLatitude:(NSString*) latitude longitude:(NSString*) longitude{
    
    NSString* url = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true_or_false&language=uk",latitude,longitude];
    //NSLog(@"REQUEST = %@", url);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //[request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSLog(@"%d byte", oResponseData.length);
    
    if(([responseCode statusCode] != 200) || (oResponseData.length <= 5000)){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        UAAdress* adress = [[UAAdress alloc] init];
        adress.adressFormat = @"Не вдалось отримати адресу вулицi";
        return adress;
    }
    
     //NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
     //NSLog(@"JSON = %@",result);
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:oResponseData options:0 error:&localError];
    
    if (localError != nil) {
        //*error = localError;
        //return nil;
    }
    
    NSDictionary *results = [parsedObject valueForKey:@"results"];
    
    return [[UAAdress alloc] initWithServerResponse:results];
    
}

/*
- (UAAdress*) adressSearchLatitude2:(NSString*) latitude longitude:(NSString*) longitude{
    
    [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(latitude, longitude)
                                   completionHandler:^(GMSReverseGeocodeResponse* response, NSError* error) {
                                       
                                       NSLog(@"reverse geocoding results:");
                                       //NSLog( @"%@" , response.firstResult.addressLine1 ) ;
                                       //NSLog( @"%@" , response.firstResult.addressLine2 ) ;
                                       GMSAddress* addressObj = [response firstResult];
                                       NSLog(@"lines=%@", addressObj.lines);
                                       
                                       
                                       self.adress = [NSString stringWithFormat:@"%@ %@", addressObj.lines.firstObject, addressObj.lines.lastObject];
                                       NSLog(@"lines=%@", self.adress);
                                       
                                       
                                   }];
    
}
 */

@end

