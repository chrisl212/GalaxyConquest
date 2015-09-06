//
//  ACStarSystemScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACStarSystemScene.h"
#import "ACStarNode.h"
#import "ACButtonNode.h"
#import "ACMainMenuScene.h"
#import "ACStar.h"
#import "ACGalaxyScene.h"
#import "ACGalaxy.h"
#import "ACPlanet.h"
#import "ACPlanetScene.h"
#import "ACInfoNode.h"

#define PLANET_WIDTH 50.0
#define PLANET_HEIGHT 50.0

CGPoint findB(double Ax, double Ay, double Cx, double Cy, double L, int clockwise)
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

@interface ACStarSystemScene ()

@property (strong, nonatomic) ACStarNode *starNode;

@end

@implementation ACStarSystemScene

- (id)initWithStar:(ACStar *)star size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.star = star;
        self.backgroundColor = [SKColor blackColor];
        
        ACButtonNode *menuButton = [[ACButtonNode alloc] initWithTitle:@"Menu" font:[UIFont systemFontOfSize:14.0]];
        menuButton.position = CGPointMake(menuButton.frame.size.width/2.0, self.frame.size.height - menuButton.frame.size.height/2.0);
        [menuButton addTarget:self action:@selector(pauseMenu)];
        [self addChild:menuButton];
        
        ACButtonNode *galaxyButton = [[ACButtonNode alloc] initWithTitle:star.parentGalaxy.name font:[UIFont systemFontOfSize:14.0]];
        galaxyButton.position = CGPointMake(self.frame.size.width - galaxyButton.frame.size.width/2.0, self.frame.size.height - galaxyButton.frame.size.height/2.0);
        [galaxyButton addTarget:self action:@selector(displayGalaxy)];
        [self addChild:galaxyButton];
        
        self.starNode = [[ACStarNode alloc] initWithStar:self.star];
        self.starNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.starNode];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    for (ACPlanet *planet in self.star.planets)
    {
        UIGraphicsBeginImageContext(self.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.6].CGColor);
        CGContextSetLineWidth(context, 3.0);
        
        CGFloat radius = ((self.size.height - PLANET_HEIGHT/2.0)/2.0) * planet.orbitalDistance;
        
        CGContextAddArc(context, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), radius, 30.0, 0.0, 1);
        CGContextStrokePath(context);
        
        UIImage *orbitImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        SKSpriteNode *orbitNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:orbitImage]];
        orbitNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self insertChild:orbitNode atIndex:0];
    }
    for (ACPlanet *planet in self.star.planets)
    {
        ACPlanetNode *planetNode = [[ACPlanetNode alloc] initWithPlanet:planet size:CGSizeMake(PLANET_WIDTH, PLANET_HEIGHT)];
        planetNode.delegate = self;
        NSInteger randomPosition = arc4random_uniform(10) + 1;
        
        CGFloat radius = ((self.size.height - PLANET_HEIGHT/2.0)/2.0) * planet.orbitalDistance;
        
        CGFloat topX = CGRectGetMidX(self.frame);
        CGFloat topY = CGRectGetMidY(self.frame) + radius;
        
        CGFloat orbitalDiameter = radius * 2.0;
        CGFloat orbitalCircumference = M_PI * orbitalDiameter;
        CGFloat oneTenthCircumference = orbitalCircumference/10.0;
        
        CGFloat positionCircumference = oneTenthCircumference * randomPosition;
        
        planetNode.position = findB(topX, topY, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), positionCircumference, 1);
        
        ACInfoNode *infoNode = [[ACInfoNode alloc] initWithStrings:@[planet.name] size:CGSizeMake(80.0, 20.0)];
        infoNode.anchorPoint = CGPointMake(0.0, 1.0);
        infoNode.position = planetNode.position;
        
        [self addChild:planetNode];
        [self addChild:infoNode];
    }
}

- (void)pauseMenu
{
    ACMainMenuScene *mainMenuScene = [[ACMainMenuScene alloc] initWithSize:self.size];
    [self.view presentScene:mainMenuScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)displayGalaxy
{
    ACGalaxyScene *galaxyScene = [[ACGalaxyScene alloc] initWithGalaxy:self.star.parentGalaxy size:self.size];
    [self.view presentScene:galaxyScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)update:(NSTimeInterval)currentTime
{

}

#pragma mark - Planet Node Delegate

- (void)planetNodeWasSelected:(ACPlanetNode *)node
{
    ACPlanetScene *planetScene = [[ACPlanetScene alloc] initWithPlanet:node.planet size:self.size];
    [self.view presentScene:planetScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
