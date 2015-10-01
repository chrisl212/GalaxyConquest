//
//  ACPlayer.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlayer.h"
#import "ACPlanet.h"
#import "ACFleet.h"

NSString *const ACPlayerKeyName = @"player-name";
NSString *const ACPlayerKeyColor = @"player-color";
NSString *const ACPlayerKeyImage = @"player-image";
NSString *const ACPlayerKeyPlanets = @"player-planets";
NSString *const ACPlayerKeyMoney = @"player-money";
NSString *const ACPlayerKeyMinerals = @"player-minerals";
NSString *const ACPlayerKeyFuel = @"player-fuel";
NSString *const ACPlayerKeyPlayer1 = @"player-isPlayer1";
NSString *const ACPlayerKeyDelegate = @"player-delegate";

@implementation ACPlayer

- (id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        self.name = name;
        self.color = [UIColor grayColor];
        self.money = 0;
        self.minerals = 0;
        self.fuel = 0;
        self.player1 = NO;
    }
    return self;
}

- (void)setPlanets:(NSArray *)planets
{
    NSArray *before = self.planets.copy;
    _planets = planets;
    for (ACPlanet *p in self.planets)
    {
        if (![before containsObject:p])
        {
            self.minerals += p.mineralValue;
            self.fuel += p.fuelValue;
        }
    }
}

- (void)beginTurn
{
    NSLog(@"Turn has begun for %@", self.name);
}

- (void)incrementResources
{
    for (ACPlanet *p in self.planets)
    {
        self.minerals += p.mineralValue;
        self.fuel += p.fuelValue;
    }
}

- (NSString *)imageFilePath
{
    return [[NSBundle mainBundle] pathForResource:self.image.stringByDeletingPathExtension ofType:self.image.pathExtension];
}

- (BOOL)playerCanAffordCost:(ACBuildCost)cost
{
    if (self.fuel < cost.fuelCost || self.minerals < cost.mineralsCost)
        return NO;
    return YES;
}

- (void)buildShips:(NSArray *)ships atPlanet:(ACPlanet *)planet forCost:(ACBuildCost)cost
{
    ACFleet *newFleet = [[ACFleet alloc] initWithOwner:self];
    [newFleet.ships addObjectsFromArray:ships];
    [planet addFleet:newFleet];

    self.fuel -= cost.fuelCost;
    self.minerals -= cost.mineralsCost;
    NSLog(@"Built %ld ships for %ld fuel and %ld minerals", ships.count, cost.fuelCost, cost.mineralsCost);
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACPlayerKeyName];    
    [aCoder encodeObject:self.image/*UIImagePNGRepresentation(self.image)*/ forKey:ACPlayerKeyImage];
    [aCoder encodeObject:self.color forKey:ACPlayerKeyColor];
    [aCoder encodeObject:self.planets forKey:ACPlayerKeyPlanets];
    [aCoder encodeInteger:self.money forKey:ACPlayerKeyMoney];
    [aCoder encodeInteger:self.minerals forKey:ACPlayerKeyMinerals];
    [aCoder encodeInteger:self.fuel forKey:ACPlayerKeyFuel];
    [aCoder encodeBool:self.player1 forKey:ACPlayerKeyPlayer1];
    [aCoder encodeObject:self.delegate forKey:ACPlayerKeyDelegate];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACPlayerKeyName];
        self.image = [aDecoder decodeObjectForKey:ACPlayerKeyImage];/*[UIImage imageWithData:[aDecoder decodeObjectForKey:ACPlayerKeyImage]]*/;
        self.color = [aDecoder decodeObjectForKey:ACPlayerKeyColor];
        self.planets = [aDecoder decodeObjectForKey:ACPlayerKeyPlanets];
        self.money = [aDecoder decodeIntegerForKey:ACPlayerKeyMoney];
        self.minerals = [aDecoder decodeIntegerForKey:ACPlayerKeyMinerals];
        self.fuel = [aDecoder decodeIntegerForKey:ACPlayerKeyFuel];
        self.player1 = [aDecoder decodeBoolForKey:ACPlayerKeyPlayer1];
        self.delegate = [aDecoder decodeObjectForKey:ACPlayerKeyDelegate];
    }
    return self;
}

@end
