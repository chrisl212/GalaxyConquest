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
NSString *const ACPlanetKeyTextureImage = @"planet-texture";
NSString *const ACPlanetKeyOrbitalDistance = @"planet-orbitalDistance";

@implementation ACPlanet

- (id)initWithName:(NSString *)name parentStar:(ACStar *)parentStar textureImage:(UIImage *)textureImage orbitalDistance:(CGFloat)distance
{
    if (self = [super init])
    {
        self.name = name;
        self.parentStar = parentStar;
        self.textureImage = textureImage;
        self.orbitalDistance = distance;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACPlanetKeyName];
    [aCoder encodeObject:self.parentStar forKey:ACPlanetKeyParentStar];
    [aCoder encodeObject:self.textureImage forKey:ACPlanetKeyTextureImage];
    [aCoder encodeDouble:self.orbitalDistance forKey:ACPlanetKeyOrbitalDistance];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACPlanetKeyName];
        self.parentStar = [aDecoder decodeObjectForKey:ACPlanetKeyParentStar];
        self.textureImage = [aDecoder decodeObjectForKey:ACPlanetKeyTextureImage];
        self.orbitalDistance = [aDecoder decodeDoubleForKey:ACPlanetKeyOrbitalDistance];
    }
    return self;
}

@end
