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
#import "ACPlayer.h"
#import "ACInfoNode.h"
#import "AppDelegate.h"
#import "ACPauseMenuScene.h"

#define PLANET_WIDTH 50.0
#define PLANET_HEIGHT 50.0

double angle(double Ax, double Ay, double Cx, double Cy)
{
    return atan2(Ay - Cy, Ax - Cx); //TODO: fix - only returns up to 180
}

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
@property (strong, nonatomic) ACButtonNode *nextTurnButtonNode;
@property (strong, nonatomic) ACInfoNode *playerInfoNode;

@end

@implementation ACStarSystemScene

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (id)initWithStar:(ACStar *)star size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SKSpriteNode *backgroundNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"stars.jpg"] color:nil size:self.size];
        [self insertChild:backgroundNode atIndex:0];
        backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
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
        
        ACPlayer *currentPlayer = [self appDelegate].currentGame.currentPlayer;
        NSArray *playerInfoStrings = @[currentPlayer.name, [NSString stringWithFormat:@"Money:%ldk", currentPlayer.money], [NSString stringWithFormat:@"Minerals:%ldk", currentPlayer.minerals], [NSString stringWithFormat:@"Fuel:%ldk", currentPlayer.fuel]];
        self.playerInfoNode = [[ACInfoNode alloc] initWithStrings:playerInfoStrings size:CGSizeMake(200.0, 200.0)];
        self.playerInfoNode.position = CGPointMake(self.size.width - self.playerInfoNode.size.width, self.playerInfoNode.size.height);
        [self addChild:self.playerInfoNode];
        
        self.nextTurnButtonNode = [[ACButtonNode alloc] initWithTitle:@"Next Turn" font:[UIFont systemFontOfSize:14.0]];
        self.nextTurnButtonNode.position = CGPointMake(self.playerInfoNode.position.x + self.playerInfoNode.size.width/2.0, self.playerInfoNode.position.y + self.nextTurnButtonNode.size.height/2.0);
        self.nextTurnButtonNode.touchHandler = ^(ACButtonNode *button)
        {
            if ([currentPlayer.delegate respondsToSelector:@selector(playerDidFinishTurn:)])
                [currentPlayer.delegate playerDidFinishTurn:currentPlayer];
        };
        [self addChild:self.nextTurnButtonNode];
        
        [currentPlayer addObserver:self forKeyPath:@"minerals" options:kNilOptions context:NULL];
        [currentPlayer addObserver:self forKeyPath:@"fuel" options:kNilOptions context:NULL];
        [currentPlayer addObserver:self forKeyPath:@"money" options:kNilOptions context:NULL];
        
        ACGame *currentGame = [self appDelegate].currentGame;
        currentGame.delegate = self;
        
        for (ACPlanet *planet in self.star.planets)
        {
            UIGraphicsBeginImageContextWithOptions(self.size, NO, 2.0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor);
            CGContextSetLineWidth(context, 1.5);
            CGContextSetAllowsAntialiasing(context, YES);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetLineJoin(context, kCGLineJoinRound);
            CGContextSetShouldAntialias(context, YES);
            CGContextSetMiterLimit(context, 2.0);
            
            CGFloat radius = ((self.size.height - PLANET_HEIGHT)/2.0) * planet.orbitalDistance;
            
            CGContextAddArc(context, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), radius, 30.0, 0.0, 1);
            CGContextStrokePath(context);
            
            UIImage *orbitImage = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            SKSpriteNode *orbitNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImage:orbitImage]];
            orbitNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            [self insertChild:orbitNode atIndex:0];
        }
        NSInteger counter = 0;
        for (ACPlanet *planet in self.star.planets)
        {
            NSInteger randomPosition = counter; //not random anymore
            counter++;
            
            CGFloat radius = ((self.size.height - PLANET_HEIGHT)/2.0) * planet.orbitalDistance;
            
            CGFloat topX = CGRectGetMidX(self.frame);
            CGFloat topY = CGRectGetMidY(self.frame) + radius;
            
            CGFloat orbitalDiameter = radius * 2.0;
            CGFloat orbitalCircumference = M_PI * orbitalDiameter;
            CGFloat oneTenthCircumference = orbitalCircumference/self.star.planets.count;//no longer one tenth
            
            CGFloat positionCircumference = oneTenthCircumference * randomPosition;
            
            CGPoint position = findB(topX, topY, CGRectGetMidX(self.frame), CGRectGetMidY(self.frame), positionCircumference, 1);
            CGFloat ang = (angle(topX, topY, position.x, position.y) * (180.0/M_PI));
            
            ACPlanetNode *planetNode = [[ACPlanetNode alloc] initWithPlanet:planet size:CGSizeMake(PLANET_WIDTH, PLANET_HEIGHT) lightAngle:ang];
            planetNode.delegate = self;
            
            planetNode.position = position;
            
            ACInfoNode *infoNode = [[ACInfoNode alloc] initWithStrings:@[planet.name, [NSString stringWithFormat:@"Owner: %@", planet.owner.name]] size:CGSizeMake(80.0, 40.0)];
            infoNode.position = planetNode.position;
            infoNode.color = planet.owner.color;
            
            [self addChild:planetNode];
            [self addChild:infoNode];
        }
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];

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

- (void)displayGalaxy
{
    ACGalaxyScene *galaxyScene = [[ACGalaxyScene alloc] initWithGalaxy:self.star.parentGalaxy size:self.size];
    [self.view presentScene:galaxyScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)update:(NSTimeInterval)currentTime
{

}

- (void)game:(ACGame *)game turnDidChangeToPlayer:(ACPlayer *)player
{
    if (!player.isPlayer1)
        self.nextTurnButtonNode.title = @"Loading...", self.nextTurnButtonNode.userInteractionEnabled = NO;
    else
        self.nextTurnButtonNode.title = @"Next Turn", self.nextTurnButtonNode.userInteractionEnabled = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self.playerInfoNode removeFromParent];
    
    ACPlayer *currentPlayer = [self appDelegate].currentGame.currentPlayer;
    NSArray *playerInfoStrings = @[currentPlayer.name, [NSString stringWithFormat:@"Money:%ldk", currentPlayer.money], [NSString stringWithFormat:@"Minerals:%ldk", currentPlayer.minerals], [NSString stringWithFormat:@"Fuel:%ldk", currentPlayer.fuel]];
    self.playerInfoNode = [[ACInfoNode alloc] initWithStrings:playerInfoStrings size:CGSizeMake(200.0, 200.0)];
    self.playerInfoNode.position = CGPointMake(self.size.width - self.playerInfoNode.size.width, self.playerInfoNode.size.height);
    [self addChild:self.playerInfoNode];
}

#pragma mark - Planet Node Delegate

- (void)planetNodeWasSelected:(ACPlanetNode *)node
{
    ACPlanetScene *planetScene = [[ACPlanetScene alloc] initWithPlanet:node.planet size:self.size];
    [self.view presentScene:planetScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
