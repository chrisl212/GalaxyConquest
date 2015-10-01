//
//  ACFleet.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACPlayer, ACPlanet;

extern NSString *const ACFleetKeyOwner;
extern NSString *const ACFleetKeyShips;
extern NSString *const ACFleetKeyName;
extern NSString *const ACFleetKeyLocation;
extern NSString *const ACFleetKeyDestination;
extern NSString *const ACFleetKeyTurnsRemaining;
extern NSString *const ACFleetKeyTotalTurns;

@interface ACFleet : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) ACPlayer *owner;
@property (strong, nonatomic) NSMutableArray *ships;
@property (strong, nonatomic) ACPlanet *location;
@property (strong, nonatomic) ACPlanet *destination;
@property (nonatomic) NSInteger turnsRemaining;
@property (nonatomic) NSInteger totalTurns;

- (id)initWithOwner:(ACPlayer *)owner;
- (void)moveToPlanet:(ACPlanet *)planet;
- (BOOL)canMoveToPlanet:(ACPlanet *)planet;
- (BOOL)isMoving;

+ (double)fuelCostForTurns:(NSInteger)turns;

@end
