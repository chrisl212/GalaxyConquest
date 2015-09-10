//
//  ACPlayer.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ACPlayerKeyName;
extern NSString *const ACPlayerKeyColor;
extern NSString *const ACPlayerKeyImage;
extern NSString *const ACPlayerKeyPlanets;
extern NSString *const ACPlayerKeyMoney;
extern NSString *const ACPlayerKeyMinerals;
extern NSString *const ACPlayerKeyFuel;
extern NSString *const ACPlayerKeyPlayer1;
extern NSString *const ACPlayerKeyDelegate;

@protocol ACPlayerDelegate;

@interface ACPlayer : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIColor *color;
//@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSArray *planets;
@property (nonatomic) NSInteger money;
@property (nonatomic) NSInteger minerals;
@property (nonatomic) NSInteger fuel;
@property (nonatomic, getter=isPlayer1) BOOL player1;
@property (weak, nonatomic) id<ACPlayerDelegate> delegate;

- (id)initWithName:(NSString *)name;
- (void)incrementResources;
- (void)beginTurn;
- (NSString *)imageFilePath;

@end

@protocol ACPlayerDelegate <NSObject>

- (void)playerDidFinishTurn:(ACPlayer *)player;

@end