//
//  AppDelegate.m
//  iMegaKit
//
//  Created by Konstantin Pikhterev on 16.07.17.
//  Copyright © 2017 MegaKit. All rights reserved.
//

#import "AppDelegate.h"

#import "IMKCoreDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

//PK 296 - Переносим управление CoreData в синглтон

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
   
    [[IMKCoreDataManager sharedManager] saveContext];
}


@end
