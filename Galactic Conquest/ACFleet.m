//
//  ACFleet.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACFleet.h"
#import "AppDelegate.h"
#import "ACStar.h"
#import "ACPlanet.h"
#import "ACGame.h"
#import "ACGalaxy.h"

NSString *const ACFleetKeyOwner = @"fleet-owner";
NSString *const ACFleetKeyShips = @"fleet-ships";
NSString *const ACFleetKeyName = @"fleet-name";
NSString *const ACFleetKeyLocation = @"fleet-location";
NSString *const ACFleetKeyDestination = @"fleet-destination";
NSString *const ACFleetKeyTurnsRemaining = @"fleet-turnsRemaining";

@implementation ACFleet

- (ACGame *)currentGame
{
    return ((AppDelegate *)[UIApplication sharedApplication].delegate).currentGame;
}

- (id)initWithOwner:(ACPlayer *)owner
{
    if (self = [super init])
    {
        self.owner = owner;
        self.ships = @[].mutableCopy;
        self.name = @"";
        self.turnsRemaining = 0;
    }
    return self;
}

- (void)moveToPlanet:(ACPlanet *)planet
{
    self.destination = planet;
    self.turnsRemaining = [[self currentGame].galaxy turnNumberFromDistance:[self.location.parentStar.parentGalaxy distanceFromStar:self.location.parentStar toStar:planet.parentStar]];
    [[self currentGame].movingFleets addObject:self];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.owner forKey:ACFleetKeyOwner];
    [aCoder encodeObject:self.ships forKey:ACFleetKeyShips];
    [aCoder encodeObject:self.name forKey:ACFleetKeyName];
    [aCoder encodeObject:self.location forKey:ACFleetKeyLocation];
    [aCoder encodeObject:self.destination forKey:ACFleetKeyDestination];
    [aCoder encodeInteger:self.turnsRemaining forKey:ACFleetKeyTurnsRemaining];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.owner = [aDecoder decodeObjectForKey:ACFleetKeyOwner];
        self.ships = [aDecoder decodeObjectForKey:ACFleetKeyShips];
        self.name = [aDecoder decodeObjectForKey:self.name];
        self.location = [aDecoder decodeObjectForKey:ACFleetKeyLocation];
        self.destination = [aDecoder decodeObjectForKey:ACFleetKeyDestination];
        self.turnsRemaining = [aDecoder decodeIntegerForKey:ACFleetKeyTurnsRemaining];
    }
    return self;
}

@end
