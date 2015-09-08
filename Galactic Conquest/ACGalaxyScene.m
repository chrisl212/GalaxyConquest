//
//  ACGalaxyScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACGalaxyScene.h"
#import "ACGalaxyNode.h"
#import "ACButtonNode.h"
#import "ACStar.h"
#import "ACGalaxy.h"
#import "ACMainMenuScene.h"
#import "ACStarMapNode.h"
#import "ACStarSystemScene.h"
#import "ACInfoNode.h"
#import "ACPlayer.h"
#import "ACGame.h"
#import "AppDelegate.h"

inline CGPoint findB(double Ax, double Ay, double Cx, double Cy, double L, int clockwise)
{
    double r = sqrt(pow(Ax - Cx, 2) + pow(Ay - Cy, 2));
    double angle = atan2(Ay - Cy, Ax - Cx);
    if (clockwise)
    {
        angle = angle - L / r;
    }
    else
    {
        angle = angle + L / r;
    }
    double Bx = Cx + r * cos(angle);
    double By = Cy + r * sin(angle);
    return CGPointMake(Bx, By);
}

@interface ACGalaxyScene ()

@property (strong, nonatomic) ACGalaxyNode *galaxyNode;

@end

@implementation ACGalaxyScene

- (NSString *)localSavesPath
{
    NSString *localSavesPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"Saves"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:localSavesPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:localSavesPath withIntermediateDirectories:YES attributes:nil error:nil];
    return localSavesPath;
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (id)initWithGalaxy:(ACGalaxy *)galaxy size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SKSpriteNode *backgroundNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"stars.jpg"] color:nil size:self.size];
        [self insertChild:backgroundNode atIndex:0];
        backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        self.galaxy = galaxy;
        self.backgroundColor = [UIColor blackColor];
        
        self.galaxyNode = [[ACGalaxyNode alloc] initWithGalaxy:self.galaxy];
        
        CGFloat oldHeight = self.galaxyNode.size.height;
        CGFloat scaleFactor = size.height/oldHeight;
        
        CGFloat newHeight = oldHeight * scaleFactor;
        CGFloat newWidth = self.galaxyNode.size.width * scaleFactor;
        
        self.galaxyNode.size = CGSizeMake(newWidth, newHeight);
        self.galaxyNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:self.galaxyNode];
        
        ACButtonNode *menuButton = [[ACButtonNode alloc] initWithTitle:@"Menu" font:[UIFont systemFontOfSize:14.0]];
        menuButton.position = CGPointMake(menuButton.frame.size.width/2.0, self.frame.size.height - menuButton.frame.size.height/2.0);
        [menuButton addTarget:self action:@selector(pauseMenu)];
        [self addChild:menuButton];
        
        ACButtonNode *saveButton = [[ACButtonNode alloc] initWithTitle:@"Save" font:[UIFont systemFontOfSize:14.0]];
        saveButton.position = CGPointMake(saveButton.size.width/2.0, saveButton.size.height/2.0);
        [saveButton addTarget:[self appDelegate].currentGame action:@selector(saveGame)];
        [self addChild:saveButton];
        
        for (ACStar *star in self.galaxy.stars)
        {
            ACStarMapNode *starMapNode = [[ACStarMapNode alloc] initWithStar:star];
            
            CGFloat radius = (self.frame.size.height/2.0) * star.orbitalDistance;
            CGFloat midX = CGRectGetMidX(self.frame);
            CGFloat topY = CGRectGetMidY(self.frame) + radius;
            
            CGPoint galaxyCenter = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            CGFloat arcLength = (star.orbitalAngle * (M_PI/180.0)) * radius;
            
            starMapNode.position = findB(midX, topY, galaxyCenter.x, galaxyCenter.y, arcLength, 1);
            [starMapNode addTarget:self action:@selector(starSelected:)];
            
            ACInfoNode *infoNode = [[ACInfoNode alloc] initWithStrings:@[star.name, [NSString stringWithFormat:@"%lu planets", (unsigned long)star.planets.count]] size:CGSizeMake(80.0, 40.0)];
            infoNode.position = starMapNode.position;
            
            [self addChild:infoNode];
            [self addChild:starMapNode];
        }
        ACPlayer *currentPlayer = [self appDelegate].currentGame.currentPlayer;
        NSArray *playerInfoStrings = @[currentPlayer.name, [NSString stringWithFormat:@"Money:%ldk", currentPlayer.money], [NSString stringWithFormat:@"Minerals:%ldk", currentPlayer.minerals], [NSString stringWithFormat:@"Fuel:%ldk", currentPlayer.fuel]];
        ACInfoNode *playerInfoNode = [[ACInfoNode alloc] initWithStrings:playerInfoStrings size:CGSizeMake(200.0, 200.0)];
        playerInfoNode.position = CGPointMake(self.size.width - playerInfoNode.size.width, playerInfoNode.size.height);
        [self addChild:playerInfoNode];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
}

- (void)update:(NSTimeInterval)currentTime
{
   // [self.galaxyNode runAction:[SKAction rotateByAngle:-0.0005 duration:0.0]];
}

- (void)pauseMenu
{
    ACMainMenuScene *mainMenuScene = [[ACMainMenuScene alloc] initWithSize:self.size];
    [self.view presentScene:mainMenuScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)starSelected:(ACStarMapNode *)starMapNode
{
    ACStarSystemScene *starSystemScene = [[ACStarSystemScene alloc] initWithStar:starMapNode.star size:self.size];
    [self.view presentScene:starSystemScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
