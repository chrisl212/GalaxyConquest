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

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACStarKeyName];
    [aCoder encodeObject:self.planets forKey:ACStarKeyPlanets];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACStarKeyName];
        self.planets = [aDecoder decodeObjectForKey:ACStarKeyPlanets];
    }
    return self;
}

@end
