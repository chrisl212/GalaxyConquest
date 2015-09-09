//
//  ACGame.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACGame.h"
#import "ACGalaxy.h"
#import "ACStar.h"
#import "ACPlanet.h"

NSString *const ACGameKeyGalaxy = @"game-galaxy";
NSString *const ACGameKeyPlayers = @"game-players";
NSString *const ACGameKeyName = @"game-name";
NSString *const ACGameKeyCurrentPlayer = @"game-currentPlayer";

@implementation ACGame

- (NSString *)localSavesPath
{
    NSString *localSavesPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Saves"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localSavesPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:localSavesPath withIntermediateDirectories:YES attributes:nil error:nil];
    return localSavesPath;
}

- (id)initWithName:(NSString *)name players:(NSArray *)players
{
    if (self = [super init])
    {
        self.name = name;
        self.galaxy = [[ACGalaxy alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"MilkyWay" ofType:@"galaxy"]];
        self.players = players;
        for (ACPlayer *player in self.players)
        {
            player.delegate = self;
            do
            {
                NSUInteger randomStarNumber = arc4random_uniform((uint32_t)self.galaxy.stars.count);
                ACStar *star = self.galaxy.stars[randomStarNumber];
                NSUInteger randomPlanetNumber = arc4random_uniform((uint32_t)star.planets.count);
                ACPlanet *planet = star.planets[randomPlanetNumber];
                if ([planet.owner.name isEqualToString:@"None"])
                {
                    planet.owner = player;
                    player.planets = @[planet];
                    break;
                }
            } while (1);
        }
        self.currentPlayer = self.players[0];
    }
    return self;
}

- (void)saveGame
{
    [self saveToPath:[[self localSavesPath] stringByAppendingPathComponent:self.name]];
}

- (void)saveToPath:(NSString *)path
{
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

- (void)startGame
{
    [self.currentPlayer beginTurn];
    if ([self.delegate respondsToSelector:@selector(gameDidStart:)])
        [self.delegate gameDidStart:self];
}

- (void)playerDidFinishTurn:(ACPlayer *)player
{
    NSInteger currentIndex = [self.players indexOfObject:self.currentPlayer];
    NSInteger nextIndex = ((currentIndex + 1) == self.players.count) ? 0 : currentIndex + 1;
    self.currentPlayer = self.players[nextIndex];
    if ([self.delegate respondsToSelector:@selector(game:turnDidChangeToPlayer:)])
        [self.delegate game:self turnDidChangeToPlayer:self.currentPlayer];
    [self.currentPlayer incrementResources];
    [self.currentPlayer beginTurn];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.galaxy forKey:ACGameKeyGalaxy];
    [aCoder encodeObject:self.players forKey:ACGameKeyPlayers];
    [aCoder encodeObject:self.name forKey:ACGameKeyName];
    [aCoder encodeObject:self.currentPlayer forKey:ACGameKeyCurrentPlayer];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.galaxy = [aDecoder decodeObjectForKey:ACGameKeyGalaxy];
        self.players = [aDecoder decodeObjectForKey:ACGameKeyPlayers];
        self.name = [aDecoder decodeObjectForKey:ACGameKeyName];
        self.currentPlayer = [aDecoder decodeObjectForKey:ACGameKeyCurrentPlayer];
    }
    return self;
}

@end
