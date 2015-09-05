//
//  ACGame.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACGame.h"
#import "ACGalaxy.h"

NSString *const ACGameKeyGalaxy = @"game-galaxy";
NSString *const ACGameKeyPlayers = @"game-players";
NSString *const ACGameKeyName = @"game-name";

@implementation ACGame

- (id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        self.name = name;
        self.galaxy = [[ACGalaxy alloc] initWithName:name image:[UIImage imageNamed:@"spiral-1.png"]];
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.galaxy forKey:ACGameKeyGalaxy];
    [aCoder encodeObject:self.players forKey:ACGameKeyPlayers];
    [aCoder encodeObject:self.name forKey:ACGameKeyName];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.galaxy = [aDecoder decodeObjectForKey:ACGameKeyGalaxy];
        self.players = [aDecoder decodeObjectForKey:ACGameKeyPlayers];
        self.name = [aDecoder decodeObjectForKey:ACGameKeyName];
    }
    return self;
}

@end
