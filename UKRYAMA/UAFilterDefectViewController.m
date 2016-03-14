//
//  UAFilterDefectViewController.m
//  UKRYAMA
//
//  Created by San on 05.04.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "UAFilterDefectViewController.h"
#import "UAListDefectViewController.h"
#import "UAFilter.h"
#import "UAInterfaceStyle.h"

#import "UAUserDefaultSetting.h"

@interface UAFilterDefectViewController ()

@property (assign, nonatomic) NSInteger numberDefectState;
@property (assign, nonatomic) NSInteger numberDefectType;

@property (strong, nonatomic) NSArray* stateListArray;
@property (strong, nonatomic) NSDictionary* defectListDict;
@property (strong, nonatomic) NSArray* defectImageArray;
@property (strong, nonatomic) NSArray* defectStateArray;

@end

typedef enum {
    badroad = 1,        // Розбита дорога
    holeonroad,         // Яма на дорозі
    hatch,              // Люк
    holeinyard,         // Яма у дворі
    badrepair,          // Неякісний ремонт дороги
    nomarking,          // Відсутність розмітки
    snow,               // Сніг
    unfinished_repair,  // Незавершений ремонт дороги
    sidewalk            // Тротуар
}UAFilterDefect;

@implementation UAFilterDefectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self renameDefectName];
    [self loadMyFilterDefect];
    
    if (!self.filter) {
        
        self.filter = [[UAFilter alloc] init];
        self.numberDefectState = -1;
        self.numberDefectType = 0;
    }
    else
        [self filterIsTrue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initial Filter Function
- (void) renameDefectName {
    
    self.defectStateArray = @[@"Додано на сайт",
                              @"Розглядаеться",
                              @"Виправлений",
                              @"Назад"];
    
    self.stateListArray = @[@"fresh",
                            @"inprogress",
                            @"fixed"];
    
    
    self.defectImageArray  = @[@"badroad",
                               @"holeonroad",
                               @"hatch",
                               @"holeinyard",
                               @"badrepair",
                               @"nomarking",
                               @"snow",
                               @"unfinished-repair",
                               @"sidewalk"];
    
    self.defectListDict = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"Розбита дорога",               @"badroad",
                           @"Яма на дорозі",                @"holeonroad",
                           @"Люк",                          @"hatch",
                           @"Яма у дворі",                  @"holeinyard",
                           @"Неякісний ремонт дороги",      @"badrepair",
                           @"Відсутність розмітки",         @"nomarking",
                           @"Сніг",                         @"snow",
                           @"Незавершений ремонт дороги",   @"unfinished-repair",
                           @"Тротуар",                      @"sidewalk",
                           nil];
}

- (void) loadMyFilterDefect {
    
    BOOL filterON = [[UAUserDefaultSetting sharedManager] loadFilterON];
    if (filterON) {
        
        self.filter = [[UAFilter alloc] init];
        NSDictionary* dict = [[NSDictionary alloc] init];
        dict = [[UAUserDefaultSetting sharedManager] loadFilter];
        
        self.filter.filter_city     = [dict objectForKey:@"city"];
        self.filter.filter_status   = [dict objectForKey:@"state"];
        self.filter.filter_type     = [dict objectForKey:@"type"];
        self.filter.myDefect        = [dict objectForKey:@"myList"];
        
        if (self.filter.filter_city.length == 0) {
            self.filter.filter_city = nil;
        }
        if (self.filter.filter_status.length == 0) {
            self.filter.filter_status = nil;
            self.numberDefectState = -1;
        }
        if (self.filter.filter_type.length == 0) {
            self.filter.filter_type = nil;
            self.numberDefectType = 0;
        }
    }
}

- (void) filterIsTrue {
    
    if ((self.filter.filter_city) && (self.filter.filter_city.length > 0)) {
        
        self.adressTextField.text = self.filter.filter_city;
    }
    
    if ((self.filter.filter_status) && (self.filter.filter_status.length > 0)) {
        
        [self.statusDefectSegment removeAllSegments];
        
        NSInteger index = [self.stateListArray indexOfObject:self.filter.filter_status];
        self.numberDefectState = index;
        NSString* title = [self.defectStateArray objectAtIndex:index];
        NSString* exit  = [self.defectStateArray lastObject];
        
        [self.statusDefectSegment insertSegmentWithTitle:title atIndex:0 animated:YES];
        [self.statusDefectSegment insertSegmentWithTitle:exit atIndex:1 animated:YES];
        self.statusDefectSegment.selectedSegmentIndex = 0;
    }else
        self.numberDefectState = -1;
    
    if ((self.filter.filter_type) && (self.filter.filter_type.length > 0)) {
        
        self.numberDefectType = ([self.defectImageArray indexOfObject:self.filter.filter_type]) + 1;
        
        for (UIButton* button in self.typeDefectButton) {
            if (button.tag == self.numberDefectType) {
                
                NSString* defectType = [self.defectImageArray objectAtIndex:(self.numberDefectType - 1)];
                NSString* imageName = [defectType stringByAppendingString:@"-active.png"];
                UIImage* image = [UIImage imageNamed:imageName];
                [button setImage:image forState:UIControlStateNormal];
                
                self.numberDefectType = self.numberDefectType;
                self.typeDefectLabel.text = [self.defectListDict objectForKey:defectType];
            }
        }
    }
    
    if (self.filter.myDefect) {
        [self.myDefectSwitch setOn:YES animated:NO];
    }
}

#pragma mark - Filter element

- (IBAction)actionDefectAdress:(id)sender {
    
    
    
}

- (IBAction)actionDefectStateSegment:(id)sender {
  
    if (self.statusDefectSegment.numberOfSegments == 3)  {
        
        NSInteger index = [self.statusDefectSegment selectedSegmentIndex];
        self.numberDefectState = index;
        [self.statusDefectSegment removeAllSegments];
        
        NSString* title = [self.defectStateArray objectAtIndex:index];
        NSString* exit  = [self.defectStateArray lastObject];
        
        [self.statusDefectSegment insertSegmentWithTitle:title atIndex:0 animated:YES];
        [self.statusDefectSegment insertSegmentWithTitle:exit atIndex:1 animated:YES];
        self.statusDefectSegment.selectedSegmentIndex = 0;
    }
    else 
    {
        [self.statusDefectSegment setTitle:@"Додано" forSegmentAtIndex:0];
        [self.statusDefectSegment setTitle:@"Розгляд" forSegmentAtIndex:1];
        [self.statusDefectSegment insertSegmentWithTitle:@"Виправлено" atIndex:2 animated:YES];
        [self.statusDefectSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        self.numberDefectState = -1;
    }
}

- (IBAction)actionDefectButton:(UIButton *)sender {

    switch (sender.tag) {
        case badroad:               [self activeDefect:sender]; break;
        case holeonroad:            [self activeDefect:sender]; break;
        case hatch:                 [self activeDefect:sender]; break;
        case holeinyard:            [self activeDefect:sender]; break;
        case badrepair:             [self activeDefect:sender]; break;
        case nomarking:             [self activeDefect:sender]; break;
        case snow:                  [self activeDefect:sender]; break;
        case unfinished_repair:     [self activeDefect:sender]; break;
        case sidewalk:              [self activeDefect:sender]; break;
    }
    
}

- (IBAction)actionDefectMy:(id)sender {
    
    if (!self.filter.myDefect) {
        self.filter.myDefect = @"my";
    }else
        self.filter.myDefect = nil;
}

-(void) activeDefect:(UIButton*) sender {
    
    NSString* defectType = [self.defectImageArray objectAtIndex:(sender.tag - 1)];
    
    //делаем активной выбранную кнопку
    if (self.numberDefectType != sender.tag) {
        for (UIButton* button in self.typeDefectButton) {
            if (button.tag == sender.tag) {
                
                NSString* imageName = [defectType stringByAppendingString:@"-active.png"];
                UIImage* image = [UIImage imageNamed:imageName];
                [button setImage:image forState:UIControlStateNormal];
                
                self.numberDefectType = sender.tag;
                self.typeDefectLabel.text = [self.defectListDict objectForKey:defectType];
                self.typeDefectLabel.textColor = TEXT_ACTIVE;
            }
            //делаем неактивной все кнопки
            else
            {
                NSInteger index = button.tag;
                NSString* imageName = [self.defectImageArray objectAtIndex:index - 1];
                imageName = [imageName stringByAppendingString:@".png"];
                UIImage* image = [UIImage imageNamed:imageName];
                [button setImage:image forState:UIControlStateNormal];
            }
        }
        
    }//делаем неактивной выбранную кнопку
     else
        for (UIButton* button in self.typeDefectButton) {
            if ((button.tag == sender.tag) ) {
                
                NSString* imageName = [defectType stringByAppendingString:@".png"];
                UIImage* image = [UIImage imageNamed:imageName];
                [button setImage:image forState:UIControlStateNormal];
                
                self.numberDefectType = 0;
                self.typeDefectLabel.text = @"Не вибрано";
                self.typeDefectLabel.textColor = TEXT_NO_ACTIVE;
            }
        }
}

#pragma mark - Final request filter

- (IBAction)actionFilterRequestButton:(id)sender {
    
    NSString* filterFinalRequest = nil;
    
    if (self.filter.myDefect) {
        NSDictionary* dict = [[UAUserDefaultSetting sharedManager] loadUserSetting];
        NSString* login         = [dict objectForKey:@"login"];
        NSString* passwordhash  = [dict objectForKey:@"passwordhash"];
        NSString* tempStr = [NSString stringWithFormat:@"/?login=%@&passwordhash=%@", login, passwordhash];
        
        filterFinalRequest = [@"/my" stringByAppendingString:tempStr];
    }else
        filterFinalRequest = @"/?";
    
    if (self.adressTextField.text.length > 0) {
        self.filter.filter_city = self.adressTextField.text;
        NSString* nameCityCode = [self.adressTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString* cityRequest = [@"filter_city=" stringByAppendingString:nameCityCode];
        filterFinalRequest = [filterFinalRequest stringByAppendingString:cityRequest];
    }else self.filter.filter_city = @"";
    
    if (self.numberDefectState != -1) {
        self.filter.filter_status = [self.stateListArray objectAtIndex:self.numberDefectState];
        NSString* stateRequest = [@"&filter_status=" stringByAppendingString:self.filter.filter_status];
        filterFinalRequest = [filterFinalRequest stringByAppendingString:stateRequest];
    }else self.filter.filter_status = @"";
    
    if (self.numberDefectType != 0) {
        self.filter.filter_type = [self.defectImageArray objectAtIndex:self.numberDefectType - 1];
        NSString* typeRequest = [@"&filter_type=" stringByAppendingString:self.filter.filter_type];
        filterFinalRequest = [filterFinalRequest stringByAppendingString:typeRequest];
    }else self.filter.filter_type = @"";
    
    filterFinalRequest = [filterFinalRequest stringByReplacingOccurrencesOfString:@"/?&" withString:@"/?"];

    if (filterFinalRequest.length == 4) {
        filterFinalRequest = [filterFinalRequest substringToIndex:3];
    }
    
    self.filter.filterFinalRequest = filterFinalRequest;
    
    [[UAUserDefaultSetting sharedManager] saveMyList:self.myDefectSwitch.on
                                                city:self.filter.filter_city
                                               state:self.filter.filter_status
                                                type:self.filter.filter_type];

    
    NSDictionary* dict = [[NSDictionary alloc] init];
    dict = [[UAUserDefaultSetting sharedManager] loadFilter];
    
    NSLog(@"%@", dict);

    [self.delegate filterVC:self filter:self.filter];
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)actionResetFilterButton:(UIButton *)sender {
    
    //Текстовое поле
    self.adressTextField.text = nil;
    
    //Статус дефекта
    if (self.statusDefectSegment.numberOfSegments != 3){
        
        [self.statusDefectSegment setTitle:@"Додано" forSegmentAtIndex:0];
        [self.statusDefectSegment setTitle:@"Розгляд" forSegmentAtIndex:1];
        [self.statusDefectSegment insertSegmentWithTitle:@"Виправлено" atIndex:2 animated:YES];
        [self.statusDefectSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
        self.numberDefectState = -1;
    }
    
    //Выбраный дефект
    for (UIButton* button in self.typeDefectButton) {
        if (button.tag == self.numberDefectType) {
            
            NSInteger index = button.tag;
            NSString* imageName = [self.defectImageArray objectAtIndex:index - 1];
            imageName = [imageName stringByAppendingString:@".png"];
            UIImage* image = [UIImage imageNamed:imageName];
            [button setImage:image forState:UIControlStateNormal];
        }
    }
    self.numberDefectType = 0;
    self.typeDefectLabel.text = @"Не вибрано";
    
    //Показ моих дефектов
    [self.myDefectSwitch setOn:NO animated:YES];
    
    if (self.filter.myDefect) {
        self.filter.myDefect = nil;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


/*
#pragma mark - NavigationSegue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [self actionFilterRequestButton:nil];
    
    UAListDefectViewController* vc = [segue destinationViewController];
    [vc setFilterDefect:self.filter];
    
}
*/
@end
