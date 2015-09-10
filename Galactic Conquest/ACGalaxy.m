//
//  ACGalaxy.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACGalaxy.h"
#import "ACStar.h"
#import "ACPlanet.h"

NSString *const ACGalaxyKeyName = @"galaxy-name";
NSString *const ACGalaxyKeyStars = @"galaxy-stars";
NSString *const ACGalaxyKeyTextureImage = @"galaxy-texture";
NSString *const ACGalaxyKeyGalacticRadius = @"galaxy-galacticRadius";

@implementation ACGalaxy

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}

- (id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        self.name = name;
        self.textureImageName = @"spiral-1.png";
        
        NSMutableArray *stars = @[].mutableCopy;
        for (int i = 0; i < 7; i++)
        {
            [stars addObject:[[ACStar alloc] initWithName:[self randomStringWithLength:7] parentGalaxy:self]];
        }
        self.stars = [NSArray arrayWithArray:stars];
        self.galacticRadius = 100000;
    }
    return self;
}

- (id)initWithFile:(NSString *)filePath
{
    if (self = [super init])
    {
        NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:nil];
        self.name = rootDictionary[@"name"];
        self.textureImageName = rootDictionary[@"textureImage"];
        
        NSMutableArray *starsArray = [NSMutableArray array];
        for (NSDictionary *starDictionary in rootDictionary[@"stars"])
        {
            if ([starDictionary isKindOfClass:[NSDictionary class]])
            {
                ACStar *star = [[ACStar alloc] initWithName:starDictionary[@"name"] parentGalaxy:self];
                star.orbitalDistance = [starDictionary[@"orbitalDistance"] doubleValue];
                star.orbitalAngle = [starDictionary[@"orbitalAngle"] doubleValue];
                
                NSMutableArray *planetsArray = [NSMutableArray array];
                for (NSDictionary *planetDictionary in starDictionary[@"planets"])
                {
                    ACPlanet *planet = [[ACPlanet alloc] initWithName:planetDictionary[@"name"] parentStar:star textureImage:planetDictionary[@"textureImage"] orbitalDistance:[planetDictionary[@"orbitalDistance"] doubleValue]];
                    planet.mineralValue = [planetDictionary[@"mineralValue"] integerValue];
                    planet.fuelValue = [planetDictionary[@"fuelValue"] integerValue];
                    [planetsArray addObject:planet];
                }
                star.planets = [NSArray arrayWithArray:planetsArray];
                [starsArray addObject:star];
            }
            else
            {
                NSString *filePath = [[NSBundle mainBundle] pathForResource:(NSString *)starDictionary ofType:@"star"];
                ACStar *star = [[ACStar alloc] initWithFile:filePath parentGalaxy:self];
                [starsArray addObject:star];
            }
        }
        self.stars = [NSArray arrayWithArray:starsArray];
        self.galacticRadius = [rootDictionary[@"galacticRadius"] doubleValue];
    }
    return self;
}

- (NSString *)textureImageFilePath
{
    return [[NSBundle mainBundle] pathForResource:self.textureImageName.stringByDeletingPathExtension ofType:self.textureImageName.pathExtension];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACGalaxyKeyName];
    [aCoder encodeObject:self.stars forKey:ACGalaxyKeyStars];
    [aCoder encodeObject:self.textureImageName/*UIImagePNGRepresentation(self.textureImage)*/ forKey:ACGalaxyKeyTextureImage];
    [aCoder encodeDouble:self.galacticRadius forKey:ACGalaxyKeyGalacticRadius];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACGalaxyKeyName];
        self.stars = [aDecoder decodeObjectForKey:ACGalaxyKeyStars];
        self.textureImageName = /*[UIImage imageWithData:*/[aDecoder decodeObjectForKey:ACGalaxyKeyTextureImage];//];
        self.galacticRadius = [aDecoder decodeDoubleForKey:ACGalaxyKeyGalacticRadius];
    }
    return self;
}

@end

CGFloat degToRad(CGFloat deg)
{
    return deg*(M_PI/180.0);
}

CGFloat convertAngle(CGFloat ang)
{
    return 360.0-(ang-90.0);
}

CGFloat referenceAngle(CGFloat ang)
{
    if (ang <= 90)
        return ang;
    else if (ang <= 180)
        return 180.0-ang;
    else if (ang <= 270)
        return ang-180.0;
    else
        return 360.0-ang;
}

@implementation ACGalaxy (DistanceCalculations)

- (CGFloat)distanceFromStar:(ACStar *)s1 toStar:(ACStar *)s2
{
    CGFloat star1Angle = convertAngle(s1.orbitalAngle);
    CGFloat star1X = s1.orbitalDistance*cos(degToRad(referenceAngle(star1Angle)));
    if (star1Angle > 90 && star1Angle < 270)
        star1X *= -1;
    CGFloat star1Y = s1.orbitalDistance*sin(degToRad(referenceAngle(star1Angle)));
    if (star1Angle > 180)
        star1Y *= -1;
    CGPoint star1Location = CGPointMake(star1X, star1Y);
    
    CGFloat star2Angle = convertAngle(s2.orbitalAngle);
    CGFloat star2X = s2.orbitalDistance*cos(degToRad(referenceAngle(star2Angle)));
    if (star2Angle > 90 && star2Angle < 270)
        star2X *= -1;
    CGFloat star2Y = s2.orbitalDistance*sin(degToRad(referenceAngle(star2Angle)));
    if (star2Angle > 180)
        star2Y *= -1;
    CGPoint star2Location = CGPointMake(star2X, star2Y);
    
    CGFloat distanceWidth = star2Location.x - star1Location.x;
    CGFloat distanceHeight = star2Location.y - star1Location.y;
    
    return sqrt(pow(distanceHeight, 2) + pow(distanceWidth, 2)) * self.galacticRadius;
}

- (NSInteger)turnNumberFromDistance:(CGFloat)distance
{
    distance /= self.galacticRadius*2.0;
    if (distance < 0.3)
        return 3;
    else if (distance < 0.7)
        return 4;
    return 5;
}

@end
