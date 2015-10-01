//
//  ACAIPlayer.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/8/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACAIPlayer.h"
#import "ACShip.h"
#import "ACFleet.h"
#import "ACPlanet.h"

@implementation ACAIPlayer

extern NSString *letters;

- (NSString *)randomStringWithLength:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint32_t)[letters length])]];
    }
    
    return randomString;
}

- (void)buildShips
{
    ACShip *ship = [[ACShip alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"Fighter" ofType:@"ship"]];
    NSInteger numberOfShips = 0;
    numberOfShips = floor(self.minerals/ship.mineralsCost);
    if ((numberOfShips > floor(self.fuel/ship.fuelCost)))
        numberOfShips = floor(self.fuel/ship.fuelCost);
    for (ACPlanet *planet in self.planets)
    {
        if (numberOfShips == 0)
            break;
        if (!planet.fleets)
            planet.fleets = @[];
        ACFleet *fleet = [[ACFleet alloc] initWithOwner:self];
        fleet.ships = @[].mutableCopy;
        for (NSInteger i = 0; i < numberOfShips; i++)
        {
            [fleet.ships addObject:[ship copy]];
        }
        [planet addFleet:fleet];
    }
}

- (void)invadePlanet
{
    
}

- (void)beginTurn
{
    NSLog(@"AI turn has started for player %@", self.name);
    dispatch_async(dispatch_queue_create("com.a-cstudios.ai", NULL), ^{
        [self buildShips];
        [self invadePlanet];
        
        [self.delegate playerDidFinishTurn:self];
    });
}

@end
