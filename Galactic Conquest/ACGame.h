//
//  ACGame.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ACGameKeyGalaxy;
extern NSString *const ACGameKeyPlayers;
extern NSString *const ACGameKeyName;
extern NSString *const ACGameKeyCurrentPlayer;

@class ACGalaxy, ACPlayer;

@interface ACGame : NSObject <NSCoding>

@property (strong, nonatomic) ACGalaxy *galaxy;
@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) ACPlayer *currentPlayer;

- (id)initWithName:(NSString *)name players:(NSArray *)players;
- (void)saveGame;
- (void)saveToPath:(NSString *)path;

@end
