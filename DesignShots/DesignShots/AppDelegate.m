//
//  AppDelegate.m
//  DesignShots
//
//  Created by lizhenjie on 4/25/16.
//  Copyright © 2016 swplzj. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.window.backgroundColor = [UIColor whiteColor];
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    
    HIUINavigationController *rootNav = [[HIUINavigationController alloc] initWithRootViewController:homeVC];
    
    self.window.rootViewController = rootNav;
    
    [self configureApplication:application withOptions:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)configureApplication:(UIApplication *)application withOptions:(NSDictionary *)launchOptions
{
    // setup view appearance
    [self configureViewAppearance];
}

- (void)configureViewAppearance
{
    /** setup UINavigationBar */
//    [[UINavigationBar appearance] setBarTintColor:APP_COLOR_BLUE];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:APP_COLOR_BLUE size:CGSizeMake(SCREEN_WIDTH, 64)] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                                                           NSForegroundColorAttributeName: [UIColor whiteColor]}];
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
