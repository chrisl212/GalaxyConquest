//
//  ACGalaxyScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SceneKit/SceneKit.h>
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
#import "ACPlanet.h"
#import "AppDelegate.h"
#import "ACPauseMenuScene.h"
#import "ACFleet.h"
#import "ACSpaceBattleScene.h"

CGFloat angleFromTwoPoints(CGPoint a, CGPoint b)
{
    return atan2(a.y-b.y, a.x-b.x);
}

CGFloat distanceBetweenPoints(CGPoint a, CGPoint b)
{
    CGFloat width = a.x-b.x;
    CGFloat height = a.y-b.y;
    return sqrt(pow(width, 2) + pow(height, 2));
}

CGPoint convertPointInRect(CGPoint a, CGRect r) //converts from SK to UIKit
{
    return CGPointMake(a.x, r.size.height - a.y);
}

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
@property (strong, nonatomic) ACButtonNode *nextTurnButtonNode;
@property (strong, nonatomic) ACInfoNode *playerInfoNode;
@property (strong, nonatomic) NSMutableArray *starMapNodes;
@property (strong, nonatomic) NSMutableArray *fleetInfoNodes;

@end

@implementation ACGalaxyScene
{
    CGFloat lastScale;
    CGPoint lastPoint;
}

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

- (void)zoom:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        lastScale = 1.0;
        lastPoint = [sender locationInView:self.view];
        lastPoint = convertPointInRect(lastPoint, self.frame);
    }
    
    // Scale
    CGFloat scale = 1.0 - (lastScale - sender.scale);
    [self.galaxyNode setScale:scale];
    lastScale = sender.scale;
    
    // Translate
    CGPoint point = [sender locationInView:self.view];
    point = convertPointInRect(point, self.frame);
   // [self.galaxyNode setPosition:CGPointMake(point.x - lastPoint.x, point.y - lastPoint.y)];
    lastPoint = [sender locationInView:self.view];
    lastPoint = convertPointInRect(lastPoint, self.frame);
}

- (id)initWithGalaxy:(ACGalaxy *)galaxy size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        SKSpriteNode *backgroundNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"stars.jpg"] color:nil size:self.size];
        [self insertChild:backgroundNode atIndex:0];
        backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        self.starMapNodes = @[].mutableCopy;
        self.galaxy = galaxy;
        self.backgroundColor = [UIColor blackColor];
        
        /*
        SCNParticleSystem *galaxyEmitter = [SCNParticleSystem particleSystemNamed:@"ACGalaxy" inDirectory:nil];
        
        SK3DNode *no = [[SK3DNode alloc] initWithViewportSize:self.size];
        SCNCamera *camera = [SCNCamera camera];
        SCNNode *cameran = [SCNNode node];
        cameran.camera = camera;
        cameran.position = SCNVector3Make(0.0, 0.0, 8.0);
        no.scnScene = [[SCNScene alloc] init];
        no.autoenablesDefaultLighting = YES;
        no.pointOfView = cameran;
        no.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:no];
        SCNNode *centerNode = [SCNNode node];
        centerNode.position = SCNVector3Make(0.0, 0.0, 0.0);
        [centerNode addParticleSystem:galaxyEmitter];
        [no.scnScene.rootNode addChildNode:centerNode]; */
        
        self.galaxyNode = [[ACGalaxyNode alloc] initWithGalaxy:self.galaxy];
        
        CGFloat oldHeight = self.galaxyNode.size.height;
        CGFloat scaleFactor = size.height/oldHeight;
        
        //CGFloat newHeight = oldHeight * scaleFactor;
        //CGFloat newWidth = self.galaxyNode.size.width * scaleFactor;
        
        //self.galaxyNode.size = CGSizeMake(newWidth, newHeight);
        self.galaxyNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:self.galaxyNode];
        
        ACButtonNode *menuButton = [[ACButtonNode alloc] initWithTitle:@"Menu" font:[UIFont systemFontOfSize:14.0]];
        menuButton.position = CGPointMake(menuButton.frame.size.width/2.0, self.frame.size.height - menuButton.frame.size.height/2.0);
        [menuButton addTarget:self action:@selector(pauseMenu)];
        [self addChild:menuButton];

        for (ACStar *star in self.galaxy.stars)
        {
            ACStarMapNode *starMapNode = [[ACStarMapNode alloc] initWithStar:star];
            
            CGFloat radius = (self.galaxyNode.size.height/2.0) * star.orbitalDistance;
            CGFloat midX = CGRectGetMidX(self.galaxyNode.frame);
            CGFloat topY = CGRectGetMidY(self.galaxyNode.frame) + radius;
            
            CGPoint galaxyCenter = CGPointMake(CGRectGetMidX(self.galaxyNode.frame), CGRectGetMidY(self.galaxyNode.frame));
            CGFloat arcLength = (star.orbitalAngle * (M_PI/180.0)) * radius;
            
            starMapNode.position = findB(midX, topY, galaxyCenter.x, galaxyCenter.y, arcLength, 1);
            [starMapNode addTarget:self action:@selector(starSelected:)];
            
            ACInfoNode *infoNode = [[ACInfoNode alloc] initWithStrings:@[star.name, [NSString stringWithFormat:@"%lu planets", (unsigned long)star.planets.count]] size:CGSizeMake(80.0, 40.0)];
            infoNode.position = starMapNode.position;
            
            [self addChild:infoNode];
            [self addChild:starMapNode];
            [self.starMapNodes addObject:starMapNode];
        }
        
        ACPlayer *currentPlayer = [self appDelegate].currentGame.currentPlayer;
        NSArray *playerInfoStrings = @[currentPlayer.name, [NSString stringWithFormat:@"Money:%ldk", currentPlayer.money], [NSString stringWithFormat:@"Minerals:%ldk", currentPlayer.minerals], [NSString stringWithFormat:@"Fuel:%ldk", currentPlayer.fuel]];
        self.playerInfoNode = [[ACInfoNode alloc] initWithStrings:playerInfoStrings size:CGSizeMake(200.0, 200.0)];
        self.playerInfoNode.position = CGPointMake(self.size.width - self.playerInfoNode.size.width, self.playerInfoNode.size.height);
        [self addChild:self.playerInfoNode];
        
        [currentPlayer addObserver:self forKeyPath:@"minerals" options:kNilOptions context:NULL];
        [currentPlayer addObserver:self forKeyPath:@"fuel" options:kNilOptions context:NULL];
        [currentPlayer addObserver:self forKeyPath:@"money" options:kNilOptions context:NULL];
        
        self.nextTurnButtonNode = [[ACButtonNode alloc] initWithTitle:@"Next Turn" font:[UIFont systemFontOfSize:14.0]];
        self.nextTurnButtonNode.position = CGPointMake(self.playerInfoNode.position.x + self.playerInfoNode.size.width/2.0, self.playerInfoNode.position.y + self.nextTurnButtonNode.size.height/2.0);
        self.nextTurnButtonNode.touchHandler = ^(ACButtonNode *button)
        {
            if ([currentPlayer.delegate respondsToSelector:@selector(playerDidFinishTurn:)])
                [currentPlayer.delegate playerDidFinishTurn:currentPlayer];
        };
        [self addChild:self.nextTurnButtonNode];
        
        ACGame *currentGame = [self appDelegate].currentGame;
        currentGame.delegate = self;
        
        self.fleetInfoNodes = @[].mutableCopy;
        [self updateUIAfterTurn];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    UIPinchGestureRecognizer *gestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoom:)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)update:(NSTimeInterval)currentTime
{
   // [self.galaxyNode runAction:[SKAction rotateByAngle:-0.0005 duration:0.0]];
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

- (void)starSelected:(ACStarMapNode *)starMapNode
{
    ACStarSystemScene *starSystemScene = [[ACStarSystemScene alloc] initWithStar:starMapNode.star size:self.size];
    [self.view presentScene:starSystemScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)game:(ACGame *)game turnDidChangeToPlayer:(ACPlayer *)player
{
    if (!player.isPlayer1)
        self.nextTurnButtonNode.title = @"Loading...", self.nextTurnButtonNode.userInteractionEnabled = NO;
    else
        self.nextTurnButtonNode.title = @"Next Turn", self.nextTurnButtonNode.userInteractionEnabled = YES, [self updateUIAfterTurn];
}

- (void)fleet:(ACFleet *)fleet didInvadePlanet:(ACPlanet *)planet
{
    ACSpaceBattleScene *spaceBattleScene = [[ACSpaceBattleScene alloc] initWithInvadingFleet:fleet size:self.size];
    [self.view presentScene:spaceBattleScene];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
}

- (void)updateUIAfterTurn
{
    [self.playerInfoNode removeFromParent];

    ACGame *currentGame = [self appDelegate].currentGame;
    
    ACPlayer *currentPlayer = currentGame.currentPlayer;
    NSArray *playerInfoStrings = @[currentPlayer.name, [NSString stringWithFormat:@"Money:%ldk", currentPlayer.money], [NSString stringWithFormat:@"Minerals:%ldk", currentPlayer.minerals], [NSString stringWithFormat:@"Fuel:%ldk", currentPlayer.fuel]];
    self.playerInfoNode = [[ACInfoNode alloc] initWithStrings:playerInfoStrings size:CGSizeMake(200.0, 200.0)];
    self.playerInfoNode.position = CGPointMake(self.size.width - self.playerInfoNode.size.width, self.playerInfoNode.size.height);
    [self addChild:self.playerInfoNode];
    
    
    for (SKNode *node in self.fleetInfoNodes)
    {
        [node removeFromParent];
    }
    for (ACFleet *fleet in currentGame.movingFleets)
    {
        if ([fleet.location.parentStar isEqual:fleet.destination.parentStar])
            continue;
        
        CGPoint originLocation, destinationLocation;
        for (ACStarMapNode *mapNode in self.starMapNodes)
        {
            if ([mapNode.star isEqual:fleet.location.parentStar])
                originLocation = convertPointInRect(mapNode.position, self.frame);
            else if ([mapNode.star isEqual:fleet.destination.parentStar])
                destinationLocation = convertPointInRect(mapNode.position, self.frame);
        }
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 2.0);
        CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
        
        CGPoint points[2] = {originLocation, destinationLocation};
        CGContextAddLines(context, points, 2);
        
        CGContextStrokePath(context);
        UIImage *textureImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        SKSpriteNode *pathNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:textureImage]];
        pathNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self insertChild:pathNode atIndex:0];
        
        originLocation = convertPointInRect(originLocation, self.frame);
        destinationLocation = convertPointInRect(destinationLocation, self.frame);
        
        SKSpriteNode *fleetSpriteNode = [SKSpriteNode spriteNodeWithColor:[UIColor grayColor] size:CGSizeMake(8.0, 8.0)];
        CGFloat distance = distanceBetweenPoints(originLocation, destinationLocation)/fleet.totalTurns*fleet.turnsRemaining;
        CGFloat angle = angleFromTwoPoints(originLocation, destinationLocation);
        
        CGFloat x = destinationLocation.x+(distance * cos(angle));//(originLocation.x+destinationLocation.x)/2.0;
        CGFloat y = destinationLocation.y+(distance * sin(angle));//(originLocation.y+destinationLocation.y)/2.0;
        fleetSpriteNode.position = CGPointMake(x, y);
        [self addChild:fleetSpriteNode];
        
        NSArray *infoStrings = @[fleet.name, [NSString stringWithFormat:@"%ld turns", fleet.turnsRemaining]];
        ACInfoNode *infoNode = [[ACInfoNode alloc] initWithStrings:infoStrings size:CGSizeMake(200.0, 200.0)];
        infoNode.position = fleetSpriteNode.position;
        [self addChild:infoNode];
        
        [self.fleetInfoNodes addObject:infoNode];
        [self.fleetInfoNodes addObject:pathNode];
        [self.fleetInfoNodes addObject:fleetSpriteNode];
    }
}

@end
