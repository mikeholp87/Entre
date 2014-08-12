//
//  AppDelegate.m
//  Entre
//
//  Created by Michael Holp on 7/11/14.
//  Copyright (c) 2014 Fovnders. All rights reserved.
//

#import "AppDelegate.h"
#import "EntreGeofence.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.tintColor = [UIColor colorWithRed:73/255.0 green:162/255.0 blue:142/255.0 alpha:1.0];
    
    //[[EntreGeofence geofence] init];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Incoming notification in running app");
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
