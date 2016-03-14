//
//  UAUser.m
//  UKRYAMA
//
//  Created by San on 01.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAUser.h"
#import "TBXML.h"

@implementation UAUser



- (id)initWithServerResponse:(NSData*) oResponseData
{
    self = [super init];
    if (self) {
        
        // Parsing XML
        
        TBXML *sourceXML = [[TBXML alloc] initWithXMLData:oResponseData error:nil];
        TBXMLElement *rootElement = sourceXML.rootXMLElement;
        
        TBXMLElement *requesttime   = [TBXML childElementNamed:@"requesttime"   parentElement:rootElement];
        TBXMLElement *replytime     = [TBXML childElementNamed:@"replytime"     parentElement:rootElement];
        TBXMLElement *user          = [TBXML childElementNamed:@"user"          parentElement:rootElement];
        TBXMLElement *username      = [TBXML childElementNamed:@"username"      parentElement:user];
        TBXMLElement *name          = [TBXML childElementNamed:@"name"          parentElement:username];
        TBXMLElement *secondname    = [TBXML childElementNamed:@"secondname"    parentElement:username];
        TBXMLElement *lastname      = [TBXML childElementNamed:@"lastname"      parentElement:username];
        TBXMLElement *passwordhash  = [TBXML childElementNamed:@"passwordhash"  parentElement:user];
        
        //User info data
        
        self.requesttime    = [TBXML textForElement:requesttime];
        self.replytime      = [TBXML textForElement:replytime];
        self.userID         = [TBXML valueOfAttributeNamed:@"id" forElement:user];
        self.usernameFull   = [TBXML valueOfAttributeNamed:@"full" forElement:username];
        self.name           = [TBXML textForElement:name];
        self.secondname     = [TBXML textForElement:secondname];
        self.lastname       = [TBXML textForElement:lastname];
        self.passwordhash   = [TBXML textForElement:passwordhash];
        
    }
    return self;
}

@end

/*
 
 http://ukryama.com/xml/authorize?login=PillerKOA&password=Mat1Enko2012
 
 */


/*
 
 <ukryamareply>
 <requesttime>1427880788</requesttime>
 <requestmethod>GET</requestmethod>
 <replytime>1427880789</replytime>
 <user id="6531">
 <username full="Ковальов Олександр">
 <name>Ковальов</name>
 <secondname/>
 <lastname>Олександр</lastname>
 </username>
 <passwordhash>483e0c483bb54c80ffd3f81589df6eef</passwordhash>
 </user>
 </ukryamareply>
 
*/