//
//  AppDelegate.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/3/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "AppDelegate.h"
#import "ACGameViewController.h"
#import "ACGame.h"
#import <GameKit/GameKit.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    CGRect applicationFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:applicationFrame];
    self.window.rootViewController = [[ACGameViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCurrentGame:) name:@"changeCurrentGame" object:nil];
    
    [[GKLocalPlayer localPlayer] setAuthenticateHandler:^(UIViewController *vc, NSError *err)
     {
        if (vc)
            [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
         if (err)
             NSLog(@"%@", err);
     }];
    
    return YES;
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

- (void)changeCurrentGame:(NSNotification *)notif
{
    self.currentGame = (ACGame *)notif.object;
}

@end

@interface UIFont (SpaceFont)

@end

@implementation UIFont (SpaceFont)

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"Futura" size:fontSize];
}

@end