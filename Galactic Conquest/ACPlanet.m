//
//  ACPlanet.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlanet.h"

NSString *const ACPlanetKeyName = @"planet-name";
NSString *const ACPlanetKeyParentStar = @"planet-parentStar";

@implementation ACPlanet

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACPlanetKeyName];
    [aCoder encodeObject:self.parentStar forKey:ACPlanetKeyParentStar];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACPlanetKeyName];
        self.parentStar = [aDecoder decodeObjectForKey:ACPlanetKeyParentStar];
    }
    return self;
}

@end
