//
//  ACPlanetScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlanetScene.h"
#import "ACButtonNode.h"
#import "ACPlanetNode.h"
#import "ACPlanet.h"
#import "ACStar.h"
#import "ACPlayer.h"
#import "ACMainMenuScene.h"
#import "ACGame.h"
#import "AppDelegate.h"
#import "ACStarSystemScene.h"
#import "ACPauseMenuScene.h"

@implementation ACPlanetScene

- (ACPlayer *)currentPlayer
{
    return [(AppDelegate *)[UIApplication sharedApplication].delegate currentGame].currentPlayer;
}

- (id)initWithPlanet:(ACPlanet *)planet size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.planet = planet;
        self.backgroundColor = [SKColor blackColor];
        
        CGFloat planetHeight = self.size.height - 40.0;
        CGFloat planetWidth = planetHeight;
        CGFloat x = planetWidth/2.0;
        CGFloat y = CGRectGetMidY(self.frame);
        
        ACPlanetNode *planetNode = [[ACPlanetNode alloc] initWithPlanet:planet size:CGSizeMake(planetWidth, planetHeight) lightAngle:120.0];
        planetNode.position = CGPointMake(x, y);
        [self addChild:planetNode];
        
        ACButtonNode *menuButton = [[ACButtonNode alloc] initWithTitle:@"Menu" font:[UIFont systemFontOfSize:14.0]];
        menuButton.position = CGPointMake(menuButton.frame.size.width/2.0, self.frame.size.height - menuButton.frame.size.height/2.0);
        [menuButton addTarget:self action:@selector(pauseMenu)];
        [self addChild:menuButton];
        
        ACButtonNode *starButton = [[ACButtonNode alloc] initWithTitle:planet.parentStar.name font:[UIFont systemFontOfSize:14.0]];
        starButton.position = CGPointMake(self.frame.size.width - starButton.frame.size.width/2.0, self.frame.size.height - starButton.frame.size.height/2.0);
        [starButton addTarget:self action:@selector(displayStar)];
        [self addChild:starButton];
        
        NSArray *planetInfoStrings = @[planet.name, [NSString stringWithFormat:@"Mineral value: %ld", planet.mineralValue], [NSString stringWithFormat:@"Fuel value: %ld", planet.fuelValue], [NSString stringWithFormat:@"Owner: %@", planet.owner.name], [NSString stringWithFormat:@"Fleets: %ld", planet.fleets.count]];

        UIFont *font = [UIFont systemFontOfSize:22.0];
        for (NSInteger i = 0; i < planetInfoStrings.count; i++)
        {
            SKLabelNode *labelNode = [[SKLabelNode alloc] initWithFontNamed:font.fontName];
            labelNode.fontSize = font.pointSize;
            labelNode.text = planetInfoStrings[i];
            labelNode.fontColor = [UIColor whiteColor];
            labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            labelNode.position = CGPointMake(size.width/2.0, (size.height - starButton.size.height) - (((size.height - starButton.size.height)/(planetInfoStrings.count + 1)) * (i + 1)));
            [self addChild:labelNode];
        }
        
        if (self.planet.owner.isPlayer1)
        {
            ACButtonNode *buildFleetButton = [[ACButtonNode alloc] initWithTitle:@"Build..." font:[UIFont systemFontOfSize:14.0]];
            buildFleetButton.position = CGPointMake(buildFleetButton.size.width/2.0, buildFleetButton.size.height/2.0);
            [self addChild:buildFleetButton];
        }
    }
    return self;
}

- (void)pauseMenu
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 2.0);
    [self.view drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ACPauseMenuScene *pauseMenuScene = [[ACPauseMenuScene alloc] initWithPreviousScene:self snapshot:viewImage];
    [self.view presentScene:pauseMenuScene];
}

- (void)displayStar
{
    ACStarSystemScene *starSystemScene = [[ACStarSystemScene alloc] initWithStar:self.planet.parentStar size:self.size];
    [self.view presentScene:starSystemScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
