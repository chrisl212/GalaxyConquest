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

@class ACGalaxy;

@interface ACGame : NSObject <NSCoding>

@property (strong, nonatomic) ACGalaxy *galaxy;
@property (strong, nonatomic) NSArray *players;
@property (strong, nonatomic) NSString *name;

- (id)initWithName:(NSString *)name;

@end
