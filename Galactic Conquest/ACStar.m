//
//  ACStar.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACStar.h"
#import "ACPlanet.h"

NSString *const ACStarKeyName = @"star-name";
NSString *const ACStarKeyPlanets = @"star-planets";
NSString *const ACStarKeyParentGalaxy = @"star-parentGalaxy";
NSString *const ACStarKeyOrbitalDistance = @"star-orbitalDistance";
NSString *const ACStarKeyOrbitalAngle = @"star-orbitalAngle";

@implementation ACStar

- (id)initWithName:(NSString *)name parentGalaxy:(ACGalaxy *)parent
{
    if (self = [super init])
    {
        self.parentGalaxy = parent;
        self.name = name;
        self.planets = @[];
    }
    return self;
}

- (id)initWithFile:(NSString *)path parentGalaxy:(ACGalaxy *)parent
{
    if (self = [super init])
    {
        NSDictionary *starDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
        
        self.name = starDictionary[@"name"];
        self.parentGalaxy = parent;
        self.orbitalDistance = [starDictionary[@"orbitalDistance"] doubleValue];
        self.orbitalAngle = [starDictionary[@"orbitalAngle"] doubleValue];
        
        NSMutableArray *planetsArray = [NSMutableArray array];
        for (NSDictionary *planetDictionary in starDictionary[@"planets"])
        {
            ACPlanet *planet = [[ACPlanet alloc] initWithName:planetDictionary[@"name"] parentStar:self textureImage:[UIImage imageNamed:planetDictionary[@"textureImage"]] orbitalDistance:[planetDictionary[@"orbitalDistance"] doubleValue]];
            planet.mineralValue = [planetDictionary[@"mineralValue"] integerValue];
            planet.fuelValue = [planetDictionary[@"fuelValue"] integerValue];
            planet.inhabited = [planetDictionary[@"inhabited"] boolValue];
            planet.type = planetDictionary[@"type"];
            planet.atmosphere = [planetDictionary[@"atmosphere"] boolValue];
            [planetsArray addObject:planet];
        }
        self.planets = [NSArray arrayWithArray:planetsArray];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACStarKeyName];
    [aCoder encodeObject:self.planets forKey:ACStarKeyPlanets];
    [aCoder encodeObject:self.parentGalaxy forKey:ACStarKeyParentGalaxy];
    [aCoder encodeDouble:self.orbitalDistance forKey:ACStarKeyOrbitalDistance];
    [aCoder encodeDouble:self.orbitalAngle forKey:ACStarKeyOrbitalAngle];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACStarKeyName];
        self.planets = [aDecoder decodeObjectForKey:ACStarKeyPlanets];
        self.parentGalaxy = [aDecoder decodeObjectForKey:ACStarKeyParentGalaxy];
        self.orbitalDistance = [aDecoder decodeDoubleForKey:ACStarKeyOrbitalDistance];
        self.orbitalAngle = [aDecoder decodeDoubleForKey:ACStarKeyOrbitalAngle];
    }
    return self;
}

@end
