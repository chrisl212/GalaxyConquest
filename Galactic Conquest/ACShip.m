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
NSString *const ACShipKeyImageFileName = @"ship-imageFile";
NSString *const ACShipKeySceneFileName = @"ship-sceneFile";
NSString *const ACShipKeyEnginePositions = @"ship-enginePositions";

@implementation ACShip

- (id)initWithFile:(NSString *)file
{
    if (self = [super init])
    {
        NSDictionary *rootDictionary = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:file] options:kNilOptions error:nil];
        self.name = rootDictionary[@"name"];
        self.fuelCost = [rootDictionary[@"fuelCost"] integerValue];
        self.mineralsCost = [rootDictionary[@"mineralsCost"] integerValue];
        self.hp = [rootDictionary[@"hp"] integerValue];
        self.imageFileName = rootDictionary[@"image"];
        self.sceneFileName = rootDictionary[@"scene"];
        
        NSArray *enginesArray = rootDictionary[@"enginePositions"];
        self.enginePositions = calloc(sizeof(CGPoint), enginesArray.count);
        
        NSInteger counter = 0;
        for (NSArray *pointArray in enginesArray)
        {
            self.enginePositions[counter] = CGPointMake([pointArray[0] doubleValue], [pointArray[1] doubleValue]);
            
            counter++;
        }
    }
    return self;
}

- (NSString *)scenePath
{
    return [[NSBundle mainBundle] pathForResource:self.sceneFileName ofType:@"dae"];
}

- (NSString *)imageFilePath
{
    return [[NSBundle mainBundle] pathForResource:self.imageFileName.stringByDeletingPathExtension ofType:self.imageFileName.pathExtension];
}

- (NSString *)sceneFilePath
{
    return [[NSBundle mainBundle] pathForResource:self.sceneFileName.stringByDeletingPathExtension ofType:self.sceneFileName.pathExtension];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACShipKeyName];
    [aCoder encodeInteger:self.fuelCost forKey:ACShipKeyFuelCost];
    [aCoder encodeInteger:self.mineralsCost forKey:ACShipKeyMineralsCost];
    [aCoder encodeInteger:self.hp forKey:ACShipKeyHP];
    [aCoder encodeObject:self.imageFileName forKey:ACShipKeyImageFileName];
    [aCoder encodeObject:self.sceneFileName forKey:ACShipKeySceneFileName];
    //TODO:implement [aCoder encodeBytes:self.enginePositions length:<#(NSUInteger)#> forKey:<#(NSString *)#>]
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACShipKeyName];
        self.fuelCost = [aDecoder decodeIntegerForKey:ACShipKeyFuelCost];
        self.mineralsCost = [aDecoder decodeIntegerForKey:ACShipKeyMineralsCost];
        self.hp = [aDecoder decodeIntegerForKey:ACShipKeyHP];
        self.imageFileName = [aDecoder decodeObjectForKey:ACShipKeyImageFileName];
        self.sceneFileName = [aDecoder decodeObjectForKey:ACShipKeySceneFileName];
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
    newShip.imageFileName = [self.imageFileName copy];
    newShip.sceneFileName = [self.sceneFileName copy];
    return newShip;
}

@end
