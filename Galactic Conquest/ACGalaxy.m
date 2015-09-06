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

@implementation ACGalaxy

NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}

- (id)initWithName:(NSString *)name image:(UIImage *)textureImage
{
    if (self = [super init])
    {
        self.name = name;
        self.textureImage = textureImage;
        
        NSMutableArray *stars = @[].mutableCopy;
        for (int i = 0; i < 7; i++)
        {
            [stars addObject:[[ACStar alloc] initWithName:[self randomStringWithLength:7] parentGalaxy:self]];
        }
        self.stars = [NSArray arrayWithArray:stars];
    }
    return self;
}

- (id)initWithFile:(NSString *)filePath
{
    if (self = [super init])
    {
        NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:kNilOptions error:nil];
        self.name = rootDictionary[@"name"];
        self.textureImage = [UIImage imageNamed:rootDictionary[@"textureImage"]];
        
        NSMutableArray *starsArray = [NSMutableArray array];
        for (NSDictionary *starDictionary in rootDictionary[@"stars"])
        {
            ACStar *star = [[ACStar alloc] initWithName:starDictionary[@"name"] parentGalaxy:self];
            
            NSMutableArray *planetsArray = [NSMutableArray array];
            for (NSDictionary *planetDictionary in starDictionary[@"planets"])
            {
                ACPlanet *planet = [[ACPlanet alloc] initWithName:planetDictionary[@"name"] parentStar:star textureImage:[UIImage imageNamed:planetDictionary[@"textureImage"]] orbitalDistance:[planetDictionary[@"orbitalDistance"] doubleValue]];
                [planetsArray addObject:planet];
            }
            star.planets = [NSArray arrayWithArray:planetsArray];
            [starsArray addObject:star];
        }
        self.stars = [NSArray arrayWithArray:starsArray];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACGalaxyKeyName];
    [aCoder encodeObject:self.stars forKey:ACGalaxyKeyStars];
    [aCoder encodeObject:self.textureImage forKey:ACGalaxyKeyTextureImage];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACGalaxyKeyName];
        self.stars = [aDecoder decodeObjectForKey:ACGalaxyKeyStars];
        self.textureImage = [aDecoder decodeObjectForKey:ACGalaxyKeyTextureImage];
    }
    return self;
}

@end
