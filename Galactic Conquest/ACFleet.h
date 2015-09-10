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

@interface ACFleet : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) ACPlayer *owner;
@property (strong, nonatomic) NSMutableArray *ships;
@property (strong, nonatomic) ACPlanet *location;
@property (strong, nonatomic) ACPlanet *destination;
@property (nonatomic) NSInteger turnsRemaining;

- (id)initWithOwner:(ACPlayer *)owner;
- (void)moveToPlanet:(ACPlanet *)planet;

@end
