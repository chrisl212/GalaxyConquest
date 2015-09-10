//
//  ACShip.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACShip.h"

NSString *const ACShipKeyName = @"ship-name";
NSString *const ACShipKeyFuelCost = @"ship-fuel";
NSString *const ACShipKeyMineralsCost = @"ship-minerals";
NSString *const ACShipKeyHP = @"ship-hp";
NSString *const ACShipKeySceneName = @"ship-scene";

@implementation ACShip
{
    NSString *sceneFileName;
}

- (id)initWithFile:(NSString *)file
{
    if (self = [super init])
    {
        NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:file] options:kNilOptions error:nil];
        self.name = rootDictionary[@"name"];
        self.fuelCost = [rootDictionary[@"fuelCost"] integerValue];
        self.mineralsCost = [rootDictionary[@"mineralsCost"] integerValue];
        self.hp = [rootDictionary[@"hp"] integerValue];
        sceneFileName = rootDictionary[@"scene"];
    }
    return self;
}

- (NSString *)scenePath
{
    return [[NSBundle mainBundle] pathForResource:sceneFileName ofType:@"dae"];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACShipKeyName];
    [aCoder encodeInteger:self.fuelCost forKey:ACShipKeyFuelCost];
    [aCoder encodeInteger:self.mineralsCost forKey:ACShipKeyMineralsCost];
    [aCoder encodeInteger:self.hp forKey:ACShipKeyHP];
    [aCoder encodeObject:sceneFileName forKey:ACShipKeySceneName];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACShipKeyName];
        self.fuelCost = [aDecoder decodeIntegerForKey:ACShipKeyFuelCost];
        self.mineralsCost = [aDecoder decodeIntegerForKey:ACShipKeyMineralsCost];
        self.hp = [aDecoder decodeIntegerForKey:ACShipKeyHP];
        sceneFileName = [aDecoder decodeObjectForKey:ACShipKeySceneName];
    }
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ACShip *newShip = [[ACShip alloc] init];
    newShip.name = [self.name copy];
    newShip.fuelCost = self.fuelCost;
    newShip.mineralsCost = self.mineralsCost;
    newShip.hp = self.hp;
    newShip->sceneFileName = [sceneFileName copy];
    return newShip;
}

@end
