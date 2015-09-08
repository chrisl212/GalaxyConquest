//
//  ACPlayer.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlayer.h"
#import "ACPlanet.h"

NSString *const ACPlayerKeyName = @"player-name";
NSString *const ACPlayerKeyColor = @"player-color";
NSString *const ACPlayerKeyImage = @"player-image";
NSString *const ACPlayerKeyPlanets = @"player-planets";
NSString *const ACPlayerKeyMoney = @"player-money";
NSString *const ACPlayerKeyMinerals = @"player-minerals";
NSString *const ACPlayerKeyFuel = @"player-fuel";
NSString *const ACPlayerKeyPlayer1 = @"player-isPlayer1";

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
    _planets = planets;
    for (ACPlanet *p in self.planets)
    {
        self.minerals += p.mineralValue;
        self.fuel += p.fuelValue;
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACPlayerKeyName];    
    [aCoder encodeObject:UIImagePNGRepresentation(self.image) forKey:ACPlayerKeyImage];
    [aCoder encodeObject:self.color forKey:ACPlayerKeyColor];
    [aCoder encodeObject:self.planets forKey:ACPlayerKeyPlanets];
    [aCoder encodeInteger:self.money forKey:ACPlayerKeyMoney];
    [aCoder encodeInteger:self.minerals forKey:ACPlayerKeyMinerals];
    [aCoder encodeInteger:self.fuel forKey:ACPlayerKeyFuel];
    [aCoder encodeBool:self.player1 forKey:ACPlayerKeyPlayer1];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACPlayerKeyName];
        self.image = [UIImage imageWithData:[aDecoder decodeObjectForKey:ACPlayerKeyImage]];
        self.color = [aDecoder decodeObjectForKey:ACPlayerKeyColor];
        self.planets = [aDecoder decodeObjectForKey:ACPlayerKeyPlanets];
        self.money = [aDecoder decodeIntegerForKey:ACPlayerKeyMoney];
        self.minerals = [aDecoder decodeIntegerForKey:ACPlayerKeyMinerals];
        self.fuel = [aDecoder decodeIntegerForKey:ACPlayerKeyFuel];
        self.player1 = [aDecoder decodeBoolForKey:ACPlayerKeyPlayer1];
    }
    return self;
}

@end
