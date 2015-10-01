//
//  ACGame.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ACPlayer.h"

extern NSString *const ACGameKeyGalaxy;
extern NSString *const ACGameKeyPlayers;
extern NSString *const ACGameKeyName;
extern NSString *const ACGameKeyCurrentPlayer;
extern NSString *const ACGameKeyMovingFleets;

@class ACGalaxy, ACFleet, ACPlanet;
@protocol ACGameDelegate;

@interface ACGame : NSObject <NSCoding, ACPlayerDelegate>

@property (strong, nonatomic) ACGalaxy *galaxy;
@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) ACPlayer *currentPlayer;
@property (strong, nonatomic) NSMutableArray *movingFleets;
@property (weak, nonatomic) id<ACGameDelegate> delegate; //doesn't need to be encoded because the delegate is re-established when the UI is recreated ... right?

- (id)initWithName:(NSString *)name players:(NSArray *)players;
- (void)startGame;
- (void)saveGame;
- (void)saveToPath:(NSString *)path;
- (ACPlayer *)player1;

@end

@protocol ACGameDelegate <NSObject>

@optional
- (void)gameDidStart:(ACGame *)game;
- (void)game:(ACGame *)game turnDidChangeToPlayer:(ACPlayer *)player;
- (void)fleet:(ACFleet *)player didInvadePlanet:(ACPlanet *)planet;

@end
