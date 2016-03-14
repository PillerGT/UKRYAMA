//
//  UAServerMeneger.m
//  newtest.ukryama
//
//  Created by San on 31.03.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAServerMeneger.h"
#import "AFNetworking.h"
#import <Foundation/Foundation.h>
#import "TBXML.h"
//#import "AFHTTPRequestOperationManager.h"
//#import "AFXMLRequestOperation.h"
#import "UAUser.h"
#import "UADefect.h"
#import "UAAdress.h"

#import "UAUserDefaultSetting.h"


@interface UAServerMeneger () 

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperatorManager;

@end



@implementation UAServerMeneger

+ (UAServerMeneger*) sharedMeneger {
    
    static UAServerMeneger* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UAServerMeneger alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSURL* url = [NSURL URLWithString:UKRYAMA];
        self.requestOperatorManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

#pragma mark - Autorize method

- (void) getUserAuthorize:(NSString*) login
           passwordString:(NSString*) password
                onSuccess: (void(^)(UAUser* user)) success
                onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {

    NSString* url = [NSString stringWithFormat:@"%@/xml/authorize?login=%@&password=%@", UKRYAMA, login, password];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSLog(@"%@",[NSByteCountFormatter stringFromByteCount:oResponseData.length countStyle:NSByteCountFormatterCountStyleFile]);
    
    if (([responseCode statusCode] != 200) || (oResponseData.length <= 380)) {
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        if (failure) {
            failure(error, responseCode.statusCode);
        }
        //return nil;
    }else
        
        //NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
        //NSLog(@"XML = %@",result);
        
        if (oResponseData.length > 380) {
            UAUser* user = [[UAUser alloc] initWithServerResponse:oResponseData];
            
            if (success) {
                success(user);
            }
        }
}

//Запрос CheckAuth
- (void) getUserCheckAuth:(NSString*) login
           passwordString:(NSString*) passwordhash
                onSuccess: (void(^)(BOOL result)) success
                onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* url = [NSString stringWithFormat:@"%@/xml/checkauth?login=%@&passwordhash=%@", UKRYAMA, login, passwordhash];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSLog(@"%@",[NSByteCountFormatter stringFromByteCount:oResponseData.length countStyle:NSByteCountFormatterCountStyleFile]);
    
    if (([responseCode statusCode] != 200) || (oResponseData.length <= 230)) {
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        if (failure) {
            failure(error, responseCode.statusCode);
        }

    }else
        
        //NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
        //NSLog(@"XML = %@",result);
        
        if (oResponseData.length > 230) {
            
            TBXML *sourceXML                = [[TBXML alloc] initWithXMLData:oResponseData error:nil];
            TBXMLElement *rootElement       = sourceXML.rootXMLElement;
            TBXMLElement *checkauthresult   = [TBXML childElementNamed:@"checkauthresult"   parentElement:rootElement];
            //NSString* checkOK               = [TBXML textForElement:checkauthresult];
            NSString* checkResult           = [TBXML valueOfAttributeNamed:@"result" forElement:checkauthresult];
            
            if ([checkResult isEqual: @"1"]) {
                if (success) {
                    success(YES);
                }
            }else
                if (success) {
                    success(NO);
                }
        }
}

//Запрос exit
- (void) getUserExit:(NSString*) login
           onSuccess: (void(^)(BOOL result)) success
           onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* url = [NSString stringWithFormat:@"%@/xml/exit?login=%@", UKRYAMA, login];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSLog(@"%@",[NSByteCountFormatter stringFromByteCount:oResponseData.length countStyle:NSByteCountFormatterCountStyleFile]);
    
    if (([responseCode statusCode] != 200) || (oResponseData.length <= 220)) {
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        if (failure) {
            failure(error, responseCode.statusCode);
        }

    }else
        
        //NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
        //NSLog(@"XML = %@",result);
        
        if (oResponseData.length > 220) {
            
            TBXML *sourceXML                = [[TBXML alloc] initWithXMLData:oResponseData error:nil];
            TBXMLElement *rootElement       = sourceXML.rootXMLElement;
            TBXMLElement *checkauthresult   = [TBXML childElementNamed:@"callresult"   parentElement:rootElement];
            //NSString* checkOK               = [TBXML textForElement:checkauthresult];
            NSString* checkResult           = [TBXML valueOfAttributeNamed:@"result" forElement:checkauthresult];
            
            if ([checkResult isEqual: @"1"]) {
                if (success) {
                    success(YES);
                }
            }else
                if (success) {
                    success(NO);
                }
        }
}

- (void) postUserDetailInfo:(NSString*) userID
                  onSuccess: (void(^)(NSString* exit)) success
                  onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* userID2 = @"1";
    
    NSString* url = [NSString stringWithFormat:@"%@/xml/profile/%@/", UKRYAMA, userID2];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    //NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    //NSLog(@"XML = %@",result);
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        if (failure) {
            failure(error, responseCode.statusCode);
        }else
            NSLog(@"%@", oResponseData);
    }
}

#pragma mark - Adress


#pragma  mark - Defects

//Список дефектов   /?filter_type=holeonroad&filter_status=fixed
- (void) getDefectsList:(NSString*) limit
                 offset:(NSString*) offset
                 filter:(NSString*) filterDefect
              onSuccess: (void(^)(NSArray* defectListArray)) success
              onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {
    
    dispatch_queue_t queue = dispatch_queue_create("com.ukryama.load.list2", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        NSString* paramLimitOffset = [NSString stringWithFormat:@"offset=%@&limit=%@", offset, limit];
        NSString* url;
        
        if (filterDefect) {
            url = [NSString stringWithFormat:@"%@/xml%@&%@", UKRYAMA, filterDefect, paramLimitOffset];
        }else
            url = [NSString stringWithFormat:@"%@/xml/?%@" , UKRYAMA, paramLimitOffset];;
        
        NSLog(@"%@", url);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:[NSURL URLWithString:url]];
        
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
        
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        NSLog (@"Load DATA: %d byte %d kbyte", oResponseData.length, oResponseData.length / 1024);
        
        // NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
        // NSLog(@"XML = %@",result);
        
        if(([responseCode statusCode] != 200) || (oResponseData.length <= 270)){
            NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
            
            if (failure) {
                failure(error, responseCode.statusCode);
            }
        }else
            
            if ((oResponseData.length > 270) && ([responseCode statusCode] == 200)) {
                
                NSMutableArray* tempListArray = [NSMutableArray array];
                
                TBXML *sourceXML = [[TBXML alloc] initWithXMLData:oResponseData error:nil];
                TBXMLElement *rootElement = sourceXML.rootXMLElement;
                
                TBXMLElement *defectslist   = [TBXML childElementNamed:@"defectslist"   parentElement:rootElement];
                TBXMLElement *hole          = [TBXML childElementNamed:@"hole"          parentElement:defectslist];
                
                while (hole) {NSLog (@"%d", [tempListArray count] + 1);
                    UADefect* defect = [[UADefect alloc] initWithServerResponse:hole];
                    hole = [TBXML nextSiblingNamed:@"hole" searchFromElement:hole];
                    [tempListArray addObject:defect];
                }
                
                if (success) {
                    success(tempListArray);
                }
            }
    });
}

- (void) postUserDefectsList:(NSString*) login
              passwordString:(NSString*) passwordhash
                   onSuccess: (void(^)(NSString* exit)) success
                   onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* url = [NSString stringWithFormat:@"%@/xml/my?login=%@&passwordhash=%@", UKRYAMA, login, passwordhash];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"XML = %@",result);
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        if (failure) {
            failure(error, responseCode.statusCode);
        }
    }
    
}

- (void) postUserDefectsAuthorize:(NSString*) login
                   passwordString:(NSString*) passwordhash
                     numberDefect:(NSString*) number
                        onSuccess: (void(^)(NSString* exit)) success
                        onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString* url = [NSString stringWithFormat:@"%@/xml/my/%@?login=%@&passwordhash=%@", UKRYAMA, number, login, passwordhash];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSString* result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSLog(@"XML = %@",result);
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url, [responseCode statusCode]);
        
        if (failure) {
            failure(error, responseCode.statusCode);
        }
    }
}
/*
//Работа с дефектами. Добавление дефекта
- (void) postUserDefectsAuthorize:(UADefect*) defect
                        onSuccess: (void(^)(NSString* exit)) success
                        onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {
    
    //self.requestOperatorManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    //[self.requestOperationManager.requestSerializer setAuthorizationHeaderFieldWithUsername:self.userPhone
    //                                                                               password:@""];
    
    //NSData *imageToUpload= UIImageJPEGRepresentation(userShot.photo, 0.5);
    
    //NSData *imageToUpload2 = UIImagePNGRepresentation(userShot.photo);
    
    //NSArray* array = [userShot.socialNetwork componentsSeparatedByString:@", "];
    
    [self.requestOperatorManager POST:@"add"
                            parameters:nil
             constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                 
                 [formData appendPartWithFormData:[defect.user.login                dataUsingEncoding:NSUTF8StringEncoding]   name:@"login"];
                 [formData appendPartWithFormData:[defect.user.passwordhash         dataUsingEncoding:NSUTF8StringEncoding]   name:@"passwordhash"];
                 [formData appendPartWithFormData:[defect.adress.adressFormat       dataUsingEncoding:NSUTF8StringEncoding]   name:@"address"];
                 [formData appendPartWithFormData:[defect.latitude                  dataUsingEncoding:NSUTF8StringEncoding]   name:@"latitude"];
                 [formData appendPartWithFormData:[defect.longitude                 dataUsingEncoding:NSUTF8StringEncoding]   name:@"longitude"];
                 [formData appendPartWithFormData:[defect.commentfresh              dataUsingEncoding:NSUTF8StringEncoding]   name:@"comment"];
                 [formData appendPartWithFormData:[defect.typeCode                  dataUsingEncoding:NSUTF8StringEncoding]   name:@"type"];
                 
                 for (UIImage* tmpImg in defect.arrayAddImage) {
                     
                     NSData *imageToUpload= UIImageJPEGRepresentation(tmpImg, 0.5);
                     NSString* imageName = [NSString stringWithFormat:@"ios_image_%d.jpg", [defect.arrayAddImage indexOfObject:tmpImg] + 1];
                     
                     [formData appendPartWithFileData:imageToUpload
                                                 name:@"file[]"
                                             fileName:imageName
                                             mimeType:@"image/jpg"];
                 }
 */
//Holes[upploadedPictures][]
//<label for="Holes_upploadedPictures">Потрібно завантажити фотографії</label>
//<input class="mf" id="Holes_upploadedPictures" type="file" value="" name="Holes[upploadedPictures][]"
                 /*
                 [formData appendPartWithFileData:imageToUpload
                                             name:@"image"
                                         fileName:@"ios_image.jpg"
                                         mimeType:@"image/jpg"];
                 */
                 //[formData appendPartWithFormData:imageToUpload
                 //                            name:@"image"];
/*
             } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                                  NSLog(@"Success: %@", responseObject);
                 
                 NSString* idShot = [responseObject objectForKey:@"id"];
                 
                 if (success) {
                     success(idShot);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 NSLog(@"Error POST SHOT(shoots): %@", [error description]);
                 
             }];
    
    
    
}
*/
//Работа с дефектами. Добавление дефекта
- (void) postUserDefectsAuthorize:(UADefect*) defect
                        onSuccess: (void(^)(NSString* exit)) success
                        onFailure: (void(^)(NSError* error, NSInteger statusCode)) failure {
    
    NSString *urlString = [NSString stringWithFormat:@"%@/xml/add/", UKRYAMA];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSMutableData *body = [NSMutableData data];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    // Text LOGIN
    [body appendData:[[NSString stringWithFormat:   @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:   @"Content-Disposition: form-data; name=\"login\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[defect.user.login dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[                              @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // Text PASSWORDHASH
    [body appendData:[[NSString stringWithFormat:   @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:   @"Content-Disposition: form-data; name=\"passwordhash\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[defect.user.passwordhash dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[                              @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // Text ADDRESS
    [body appendData:[[NSString stringWithFormat:   @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:   @"Content-Disposition: form-data; name=\"address\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[defect.adress.adressFormatxAL dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[                              @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // Text LATITUDE
    [body appendData:[[NSString stringWithFormat:   @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:   @"Content-Disposition: form-data; name=\"latitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[defect.adress.latitude dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[                              @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // Text LONGITUDE
    [body appendData:[[NSString stringWithFormat:   @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:   @"Content-Disposition: form-data; name=\"longitude\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[defect.adress.longitude dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[                              @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // Text COMMENT
    [body appendData:[[NSString stringWithFormat:   @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:   @"Content-Disposition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[defect.commentfresh dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[                              @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    // Text TYPE
    [body appendData:[[NSString stringWithFormat:   @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:   @"Content-Disposition: form-data; name=\"type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[defect.typeCode dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[                              @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // FILES
    
    for (UIImage* tmpImg in defect.arrayAddImage) {
        
        NSData *imageToUpload= UIImageJPEGRepresentation(tmpImg, UPLOAD_IMAGE_QUALITY);
        //NSLog (@"Load DATA: %d byte %d kbyte", imageToUpload.length, imageToUpload.length / 1024);
        NSString* imageName = [NSString stringWithFormat:@"ios_image_%d.jpg", [defect.arrayAddImage indexOfObject:tmpImg] + 1];
        NSString* pathImage = [NSString stringWithFormat:@"Content-Disposition: attachment; name=\"file[]\"; filename=\"%@\"\r\n",imageName];
        
        [body appendData:[[NSString stringWithFormat:   @"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[                              pathImage dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[                              @"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageToUpload]];
        [body appendData:[                              @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];;
    }
    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog (@"Upload DATA: %d byte %d kbyte", body.length, body.length / 1024);
    
    // set request body
    [request setHTTPBody:body];
    
    //return and test
     NSHTTPURLResponse *responseCode = nil;
    NSError *error = [[NSError alloc] init];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", returnString);
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", urlString, [responseCode statusCode]);
        
        if (failure) {
            failure(error, responseCode.statusCode);
        }

    }else {
        
        TBXML *sourceXML = [[TBXML alloc] initWithXMLData:returnData error:nil];
        TBXMLElement *rootElement = sourceXML.rootXMLElement;
        TBXMLElement *defectslist   = [TBXML childElementNamed:@"callresult"   parentElement:rootElement];
        //NSString* statusDefect      = [TBXML textForElement:defectslist];
        //NSString* result            = [TBXML valueOfAttributeNamed:@"result" forElement:defectslist];
        NSString* idDefect          = [TBXML valueOfAttributeNamed:@"inserteddefectid" forElement:defectslist];
        
        if (success) {
            success(idDefect);
        }
    }
}

@end






















/*
 NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
 login, @"login",
 password, @"password",
 nil];
 */
 //NSURL* url = [NSURL URLWithString:@"http://newtest.ukryama.com/xml/"];
 /*
 NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://newtest.ukryama.com/xml/"]];
 AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request
 success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
 XMLParser.delegate = self;
 [XMLParser parse];
 } failure:nil];
 [operation start];
 */
/*
 [self.requestOperatorManager GET:@"xml"
 parameters:nil
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
 [XMLParser setShouldProcessNamespaces:YES];
 XMLParser.delegate = self;
 [XMLParser parse];
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", [error localizedDescription]);
 }];*/
/*
 AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 manager.responseSerializer = [AFHTTPResponseSerializer serializer];
 [manager GET:@"http://openapi.aibang.com/search?app_key=f41c8afccc586de03a99c86097e98ccb&city=%E5%8C%97%E4%BA%AC&q=%E9%A4%90%E9%A6%86" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
 GDataXMLDocument *doc = [[GDataXMLDocument alloc]initWithData:responseObject encoding:0 error:nil];
 NSLog(@"%@",doc.rootElement);
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error: %@", error);
 }];
 */
//[theConnection release];

/*
 [[HttpClientXML sharedClientWithBaseUrl:self.baseUrl] POST:@"/postXml/" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
 BSLog(@"Success");
 } failure:^(NSURLSessionDataTask *task, NSError *error) {
 BSLog(@"Error: %@",error.localizedDescription);
 }];
 */
/*
 [self.requestOperatorManager
 GET:@"xml/authorize"
 parameters:params
 success:^(AFHTTPRequestOperation *operation, id responseObject) {
 NSLog(@"LOG XML = %@", responseObject);
 }
 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 NSLog(@"Error = %@", [error localizedDescription]);
 }];
 */
/*
 static NSString * const BaseURLString = @"http://newtest.ukryama.com/";
 
 NSString *string = [NSString stringWithFormat:@"%@xml", BaseURLString];
 NSURL *url = [NSURL URLWithString:string];
 NSURLRequest *request = [NSURLRequest requestWithURL:url];
 
 AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
 
 // Make sure to set the responseSerializer correctly
 operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
 
 [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 
 NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
 [XMLParser setShouldProcessNamespaces:YES];
 
 NSData *oResponseData = (NSData *) responseObject;
 
 // Leave these commented for now (you first need to add the delegate methods)
 // XMLParser.delegate = self;
 //[XMLParser parse];
 
 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
 
 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Weather"
 message:[error localizedDescription]
 delegate:nil
 cancelButtonTitle:@"Ok"
 otherButtonTitles:nil];
 [alertView show];
 
 }];
 
 [operation start];
 */