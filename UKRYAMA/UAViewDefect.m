//
//  UAViewDefect.m
//  UKRYAMA
//
//  Created by San on 14.10.15.
//  Copyright © 2015 San. All rights reserved.
//

#import "UAViewDefect.h"
#import "UIImageView+AFNetworking.h"
#import "UAServerMeneger.h"
#import "UAInterfaceStyle.h"

@interface UAViewDefect ()

@property (strong, nonatomic) NSArray* pictureArray;
@property (assign, nonatomic) BOOL fixedBOOL;
@property (strong, nonatomic) NSDictionary* defectListDict;

@end

@implementation UAViewDefect
{
    UIView* backraundImageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self showDefect];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) showDefect {
    
    if ([self.defectView.stateCode isEqualToString:@"fixed"]) {
        self.fixedBOOL = YES;
    }else
        self.fixedBOOL = NO;
    
    [self.defectImage setUserInteractionEnabled:YES];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listImageLeft:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.defectImage addGestureRecognizer:swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listImageRight:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.defectImage addGestureRecognizer:swipeGestureRight];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listImageDown:)];
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureDown];
    
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listImageUp:)];
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeGestureUp];
    /*
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPhotoController:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.defectImage addGestureRecognizer:tapGesture];
    */
    
    [self newObjectLayer:self.defectViewType.layer];
    [self newObjectLayer:self.defectViewStatus.layer];
    [self newObjectLayer:self.defectViewDateFresh.layer];
    [self newObjectLayer:self.defectViewDateFixed.layer];
    
    self.defectMenu.topItem.title = [NSString stringWithFormat:@"Дефект №%@", self.defectView.holeID];
    self.defectAdress.text = self.defectView.adress.adressFormat;
    self.defectType.text = [self.defectListDict objectForKey:self.defectView.typeCode];
    self.defectStatus.text = self.defectView.stateCodeName;
    self.defectComment.text = self.defectView.commentfresh;
    self.defectDateFresh.text = [NSString stringWithFormat:@"Створено: %@", self.defectView.datecreatedReadable];
    self.defectDateFixed.text = [NSString stringWithFormat:@"Усунуто: %@", self.defectView.datestatusReadable];
    
    NSString* defectType = [NSString stringWithFormat:@"%@-active.png", self.defectView.typeCode];
    self.defectIconImageView.image = [UIImage imageNamed:defectType];
    
    
    self.defectDateFixed.hidden = YES;
    
    NSDictionary* dictStatusPic = [self.defectView.pictureMedium objectForKey:@"fresh"];
    self.pictureArray = [dictStatusPic allValues];
    NSString* picture = [NSString stringWithFormat:@"%@%@", UKRYAMA, [self.pictureArray firstObject]];
    
    [self loadImage:self.defectImage fromString:picture];
    
    self.defectImagePage.numberOfPages = [self.pictureArray count];
    
    //self.defectType.textColor = TEXT_ACTIVE;
    if ([self.defectView.stateCode isEqualToString:@"fixed"]) {
        self.defectHeaderView.backgroundColor = TEXT_COLOR_FIXED;
    }else if ([self.defectView.stateCode isEqualToString:@"fresh"]) {
        self.defectHeaderView.backgroundColor = TEXT_COLOR_FRESH;
    }else
        self.defectHeaderView.backgroundColor = TEXT_COLOR_INPROGRESS;

}

#pragma mark - CALayerBorder

- (void) newObjectLayer:(CALayer*) objectLayer {
    
    CALayer *viewLayerDateFixed = objectLayer;
    [viewLayerDateFixed setCornerRadius:10];
    [viewLayerDateFixed setBorderWidth:1];
    [viewLayerDateFixed setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [viewLayerDateFixed setMasksToBounds:YES];
}

#pragma mark - UIGestureRecognizer

- (void) listImageLeft:(id) sender {
    NSLog(@"Left");
    if ((self.defectImagePage.currentPage < [self.pictureArray count] - 1) && ([self.pictureArray count] != 0)) {
        
        NSString* picture = [NSString stringWithFormat:@"%@%@", UKRYAMA, [self.pictureArray objectAtIndex:self.defectImagePage.currentPage + 1]];
        [self loadImage:self.defectImage fromString:picture];
        self.defectImagePage.currentPage ++;
        
        NSLog(@"%@", picture);
    }
}

- (void) listImageRight:(id) sender {
    NSLog(@"Right");
    if (self.defectImagePage.currentPage > 0) {
        
        NSString* picture = [NSString stringWithFormat:@"%@%@", UKRYAMA, [self.pictureArray objectAtIndex:self.defectImagePage.currentPage - 1]];
        [self loadImage:self.defectImage fromString:picture];
        self.defectImagePage.currentPage --;
        
        NSLog(@"%@", picture);
    }
}

- (void) listImageDown:(id) sender {
    NSLog(@"Down");
    if ((!self.fixedBOOL)&&([self.defectView.stateCode isEqualToString:@"fixed"])) {
        
        self.defectComment.text = self.defectView.commentfresh;
        
        self.defectDateFixed.hidden = YES;
        self.defectDateFresh.hidden = NO;
        
        NSDictionary* dictStatusPic = [self.defectView.pictureMedium objectForKey:@"fresh"];
        self.pictureArray = [dictStatusPic allValues];
        NSString* picture = [NSString stringWithFormat:@"%@%@", UKRYAMA, [self.pictureArray firstObject]];
        
        [self loadImage:self.defectImage fromString:picture];
        
        self.defectImagePage.numberOfPages = [self.pictureArray count];
        self.fixedBOOL = YES;
        
        NSLog(@"%@", picture);
    }
}

- (void) listImageUp:(id) sender {
    NSLog(@"Up");
    if ((self.fixedBOOL)&&([self.defectView.stateCode isEqualToString:@"fixed"])) {
        
        self.defectComment.text = self.defectView.commentfixed;
        
        self.defectDateFixed.hidden = NO;
        self.defectDateFresh.hidden = YES;
        
        NSDictionary* dictStatusPic = [self.defectView.pictureMedium objectForKey:@"fixed"];
        self.pictureArray = [dictStatusPic allValues];
        NSString* picture = [NSString stringWithFormat:@"%@%@", UKRYAMA, [self.pictureArray firstObject]];
        
        [self loadImage:self.defectImage fromString:picture];
        
        self.defectImagePage.numberOfPages = [self.pictureArray count];
        self.fixedBOOL = NO;
        
        NSLog(@"%@", picture);
    }
}

# pragma mark - Open photo big view
//открытие представления с увеличенной фотографией стикеров
- (IBAction)openPhotoController:(id)sender {
    
    NSLog(@"Tap");
    backraundImageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:backraundImageView];
    
    UIImageView* backgraundImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    //backgraundImage3.image = [UIImage imageNamed:@"nature_pic_1.jpg"];
    UIImageView* temp = [[UIImageView alloc] init];
    NSString* picture = [NSString stringWithFormat:@"%@%@", UKRYAMA, [self.pictureArray objectAtIndex:self.defectImagePage.currentPage]];
    [self loadImage:temp fromString:picture];
    backgraundImage3.image = temp.image;
    backgraundImage3.contentMode = UIViewContentModeScaleAspectFit;
    backgraundImage3.backgroundColor = [UIColor whiteColor];
    [backraundImageView addSubview:backgraundImage3];
    
    UIView * imageBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    imageBar.backgroundColor = [UIColor blackColor];
    [backraundImageView addSubview:imageBar];
    
    UIButton *buttonClose3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonClose3 setFrame:CGRectMake(0, 0, 80, 50)];
    [buttonClose3 setTitle:@"Закрити" forState:UIControlStateNormal];
    buttonClose3.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [buttonClose3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonClose3 setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [buttonClose3 addTarget:self action:@selector(closePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [backraundImageView addSubview:buttonClose3];
    
    UILabel* centerBarLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    //centerBarLable.text = @"1 из 3";
    centerBarLable.text = [NSString stringWithFormat:@"%d - %d", self.defectImagePage.currentPage + 1,[self.pictureArray count]];
    centerBarLable.font = [UIFont boldSystemFontOfSize:16.0];
    centerBarLable.textAlignment = NSTextAlignmentCenter;
    centerBarLable.textColor = [UIColor whiteColor];
    [backraundImageView addSubview:centerBarLable];
    
    UIButton *buttonSendImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonSendImage setFrame:CGRectMake(self.view.frame.size.width - 45, 10, 20, 30)];
    [buttonSendImage setImage:[UIImage imageNamed:@"upload_photo.png"] forState:UIControlStateNormal];
    //buttonSendImage.imageView.image = [UIImage imageNamed:@"close_3_3.png"];
    //[buttonSendImage setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonSendImage setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    //[buttonSendImage addTarget:self action:@selector(sendPhoto:) forControlEvents:UIControlEventTouchUpInside];
    [backraundImageView addSubview:buttonSendImage];
    /*
    UISwipeGestureRecognizer *tapGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listPhotoLeft:)];
    tapGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [backraundImageView addGestureRecognizer:tapGestureLeft];
    
    UISwipeGestureRecognizer *tapGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listPhotoRight:)];
    tapGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [backraundImageView addGestureRecognizer:tapGestureRight];
    */
}

//закрытие представления с большим изображением стикера
- (IBAction)closePhoto:(id)sender {
    [backraundImageView removeFromSuperview];
    
    [self updateViewConstraints];
    
}

#pragma mark - Support function

- (void) createArrayImage {
    
    NSDictionary* dictStatusPic = [self.defectView.pictureMedium objectForKey:@"fresh"];
    NSArray* pictureArray = [dictStatusPic allValues];
    
    for (NSString* picture in pictureArray) {
        NSString* image = [NSString stringWithFormat:@"%@%@", UKRYAMA, picture];
        UIImageView* imageView = [[UIImageView alloc] init];
        [self loadImage:imageView fromString:image];
    }
}

- (void) loadImage:(UIImageView*) imageView fromString:(NSString*) stringPath{
    
    //NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:picture]];
    
    NSURL* url = [NSURL URLWithString:stringPath];
    NSURLRequest* request  =  [ NSURLRequest  requestWithURL: url
                                                 cachePolicy: NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval: 432000];
    
    __weak UIImageView *weakImageView = imageView;
    weakImageView.image = nil;
    
    [weakImageView setImageWithURLRequest:request
                         placeholderImage:nil
                                  success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                      
                                      weakImageView.image = image;
                                      [self newObjectLayer:weakImageView.layer];
                                      
                                      [UIView transitionWithView:weakImageView
                                                        duration:0.3f
                                                         options:UIViewAnimationOptionTransitionCrossDissolve
                                                      animations:^{
                                                          weakImageView.image = image;
                                                      } completion:NULL];
                                      
                                  }
                                  failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                      
                                  }];
}

- (IBAction)actionBackButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
