//
//  ACPlanet.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlanet.h"
#import "ACPlayer.h"

NSString *const ACPlanetKeyName = @"planet-name";
NSString *const ACPlanetKeyParentStar = @"planet-parentStar";
NSString *const ACPlanetKeyTextureImage = @"planet-texture";
NSString *const ACPlanetKeyOrbitalDistance = @"planet-orbitalDistance";
NSString *const ACPlanetKeyOwner = @"planet-owner";
NSString *const ACPlanetKeyMineralValue = @"planet-mineralValue";
NSString *const ACPlanetKeyFuelValue = @"planet-fuelValue";
NSString *const ACPlanetKeyFleets = @"planet-fleets";
NSString *const ACPlanetKeyType = @"planet-type";
NSString *const ACPlanetKeyInhabited = @"planet-inhabited";
NSString *const ACPlanetKeyAtmosphere = @"planet-atmosphere";
NSString *const ACPlanetKeyBuildQueue = @"planet-buildQueue";

NSString *const ACPlanetTypeGas = @"planetType-gas";
NSString *const ACPlanetTypeRocky = @"planetType-rocky";

@implementation ACPlanet

- (id)initWithName:(NSString *)name parentStar:(ACStar *)parentStar textureImage:(UIImage *)textureImage orbitalDistance:(CGFloat)distance
{
    if (self = [super init])
    {
        self.name = name;
        self.parentStar = parentStar;
        self.textureImage = textureImage;
        self.orbitalDistance = distance;
        self.owner = [[ACPlayer alloc] initWithName:@"None"];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACPlanetKeyName];
    [aCoder encodeObject:self.parentStar forKey:ACPlanetKeyParentStar];
    [aCoder encodeObject:UIImagePNGRepresentation(self.textureImage) forKey:ACPlanetKeyTextureImage];
    [aCoder encodeDouble:self.orbitalDistance forKey:ACPlanetKeyOrbitalDistance];
    [aCoder encodeObject:self.owner forKey:ACPlanetKeyOwner];
    [aCoder encodeInteger:self.mineralValue forKey:ACPlanetKeyMineralValue];
    [aCoder encodeInteger:self.fuelValue forKey:ACPlanetKeyFuelValue];
    [aCoder encodeObject:self.fleets forKey:ACPlanetKeyFleets];
    [aCoder encodeBool:self.atmosphere forKey:ACPlanetKeyAtmosphere];
    [aCoder encodeObject:self.buildQueue forKey:ACPlanetKeyBuildQueue];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACPlanetKeyName];
        self.parentStar = [aDecoder decodeObjectForKey:ACPlanetKeyParentStar];
        self.textureImage = [UIImage imageWithData:[aDecoder decodeObjectForKey:ACPlanetKeyTextureImage]];
        self.orbitalDistance = [aDecoder decodeDoubleForKey:ACPlanetKeyOrbitalDistance];
        self.owner = [aDecoder decodeObjectForKey:ACPlanetKeyOwner];
        self.mineralValue = [aDecoder decodeIntegerForKey:ACPlanetKeyMineralValue];
        self.fuelValue = [aDecoder decodeIntegerForKey:ACPlanetKeyFuelValue];
        self.fleets = [aDecoder decodeObjectForKey:ACPlanetKeyFleets];
        self.atmosphere = [aDecoder decodeBoolForKey:ACPlanetKeyAtmosphere];
        self.buildQueue = [aDecoder decodeObjectForKey:ACPlanetKeyBuildQueue];
    }
    return self;
}

@end
