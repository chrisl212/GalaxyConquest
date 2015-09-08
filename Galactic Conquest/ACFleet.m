//
//  ACFleet.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACFleet.h"

NSString *const ACFleetKeyOwner = @"fleet-owner";
NSString *const ACFleetKeyShips = @"fleet-ships";

@implementation ACFleet

- (id)initWithOwner:(ACPlayer *)owner
{
    if (self = [super init])
    {
        self.owner = owner;
        self.ships = @[].mutableCopy;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.owner forKey:ACFleetKeyOwner];
    [aCoder encodeObject:self.ships forKey:ACFleetKeyShips];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.owner = [aDecoder decodeObjectForKey:ACFleetKeyOwner];
        self.ships = [aDecoder decodeObjectForKey:ACFleetKeyShips];
    }
    return self;
}

@end
