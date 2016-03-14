//
//  AppDelegate.m
//  UKRYAMA
//
//  Created by San on 31.03.15.
//  Copyright (c) 2015 San. All rights reserved.
//

#import "AppDelegate.h"
#import "GoogleMaps/GoogleMaps.h"

#import "UAFirstViewController.h"
#import "UAAddDefectViewController.h"
#import "UAUserDefaultSetting.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [GMSServices provideAPIKey:@"AIzaSyBrg0k3EYDG5xUT0XTq84HUEtfD24HpiuA"];
    
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0.5 * 1024 * 1024
                                                            diskCapacity:300 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    [self loadController];
    
    return YES;
}

- (void) loadController {
    
    NSDictionary* dict = [[UAUserDefaultSetting sharedManager] loadUserSetting];
    NSString* tempStr = [dict objectForKey:@"passwordhash"];
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if (tempStr.length == 0) {
    //    UAFirstViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UAFirstViewController"];
    //    [self presentViewController:vc animated:NO completion:nil];
        
        
        UAFirstViewController* firstVC = [storyboard instantiateViewControllerWithIdentifier:@"UAFirstViewController"];
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = firstVC;
        
    }else {
        
        UITabBarController* tabBarVC = [storyboard instantiateViewControllerWithIdentifier:@"UATabBar"];
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.window.rootViewController = tabBarVC;
    }
    
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
