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
#import "ACMainMenuScene.h"
#import "ACStarSystemScene.h"

@implementation ACPlanetScene

- (id)initWithPlanet:(ACPlanet *)planet size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.planet = planet;
        
        CGFloat planetHeight = self.size.height - 40.0;
        CGFloat planetWidth = planetHeight;
        CGFloat x = planetWidth/2.0;
        CGFloat y = CGRectGetMidY(self.frame);
        
        ACPlanetNode *planetNode = [[ACPlanetNode alloc] initWithPlanet:planet size:CGSizeMake(planetWidth, planetHeight)];
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
    }
    return self;
}

- (void)pauseMenu
{
    ACMainMenuScene *mainMenuScene = [[ACMainMenuScene alloc] initWithSize:self.size];
    [self.view presentScene:mainMenuScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)displayStar
{
    ACStarSystemScene *starSystemScene = [[ACStarSystemScene alloc] initWithStar:self.planet.parentStar size:self.size];
    [self.view presentScene:starSystemScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
