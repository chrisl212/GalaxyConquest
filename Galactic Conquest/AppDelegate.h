//
//  AppDelegate.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/3/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACGame;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ACGame *currentGame;

@end

