//
//  SUAppDelegate.m
//  SSUNS
//
//  Created by James on 2013-06-25.
//  Copyright (c) 2013 James. All rights reserved.
//

#import "SUAppDelegate.h"
#import <ECSlidingViewController.h>
#import <Crashlytics/Crashlytics.h>

#import "SUViewController.h"
#import "SUMenuView.h"

#import "SUTwitterViewController.h"
#import "SUMapViewController.h"
#import "SUCommitteeViewController.h"
#import "SUScheduleViewController.h"
@implementation SUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Crashlytics startWithAPIKey:@"6db80046a0ed213ddfcae907e190a1174b821652"];
 
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:24 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    SUMenuView* menuView = [[SUMenuView alloc]init];
    SUScheduleViewController* schView = [[SUScheduleViewController alloc]init];
    
    SUViewController *navController = [[SUViewController alloc] initWithRootViewController:schView andMenuViewController:menuView];
    
    ECSlidingViewController *slidingViewController = [[ECSlidingViewController alloc] init];
    slidingViewController.topViewController = navController;
    slidingViewController.underLeftViewController = menuView;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    self.window.rootViewController = slidingViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
