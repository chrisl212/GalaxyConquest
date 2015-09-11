//
//  ACMainMenuScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SceneKit/SceneKit.h>
#import "ACMainMenuScene.h"
#import "ACButtonNode.h"
#import "ACPlanet.h"
#import "ACLoadGameScene.h"
#import "ACPlanetNode.h"
#import "ACShip.h"
#import "ACShipNode.h"

@implementation ACMainMenuScene

- (SCNNode *)cameraNode
{
    SCNCamera *camera = [SCNCamera camera];
    camera.xFov = 0;
    camera.yFov = 0;
    camera.zNear = 0.0;
    camera.zFar = 10.0;
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = camera;
    cameraNode.position = SCNVector3Make(0, 0, 5);
    return cameraNode;
}

- (SCNScene *)planetScene
{
    SCNScene *scnScene = [SCNScene scene];
    
    SCNNode *planetNode = [[SCNNode alloc] init];
    planetNode.geometry = [SCNSphere sphereWithRadius:3.0];
    planetNode.geometry.firstMaterial.diffuse.contents = [UIImage imageNamed:[NSString stringWithFormat:@"gas-2.png"]];//, (int)arc4random_uniform(3) + 1]];
    [scnScene.rootNode addChildNode:planetNode];
    
    SCNNode *atmosphereNode = [SCNNode nodeWithGeometry:[SCNSphere sphereWithRadius:3.1]];
    atmosphereNode.opacity = 0.3;
    atmosphereNode.geometry.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
    [scnScene.rootNode addChildNode:atmosphereNode];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    rotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    rotationAnimation.duration = 150; // One revolution in ten seconds.
    rotationAnimation.repeatCount = FLT_MAX; // Repeat the animation forever.
    [planetNode addAnimation:rotationAnimation forKey:nil]; // Attach the animation to the node to start it.
    
    SCNLight *light = [SCNLight light];
    light.type = SCNLightTypeSpot;
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = light;
    lightNode.position = SCNVector3Make(1.0, 1.0, 8.0);
    [scnScene.rootNode addChildNode:lightNode];
    
    return scnScene;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    //self.backgroundColor = [SKColor blackColor];
    SKSpriteNode *backgroundNode = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"stars.jpg"] color:nil size:self.size];
    [self insertChild:backgroundNode atIndex:0];
    backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    SK3DNode *planetNode = [[SK3DNode alloc] initWithViewportSize:CGSizeMake(self.size.width, self.size.height)];
    planetNode.position = CGPointMake(CGRectGetMidX(self.frame) - self.size.width/4.0, CGRectGetMidY(self.frame) /*- self.size.height/4.0*/);

    
    planetNode.scnScene = [self planetScene];
    SCNNode *cameraNode = [self cameraNode];
    [planetNode.scnScene.rootNode addChildNode:cameraNode];
    planetNode.pointOfView = cameraNode;
    
    id s1 = [planetNode valueForKey:@"_scnRenderer"];
    NSLog(@"%@", s1);
    
    [self addChild:planetNode];
    
    NSArray *buttonTitles = @[@"Start Game", @"Add-ons", @"Options"];
    NSArray *selectors = @[@"startGame", @"openAddOnsMenu", @""];
    
    for (NSInteger i = 0; i < buttonTitles.count; i++)
    {
        CGFloat partHeight = self.size.height/(buttonTitles.count+1);
        
        ACButtonNode *button = [[ACButtonNode alloc] initWithTitle:buttonTitles[i]];
        button.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - (partHeight * (i + 1)));
        [button addTarget:self action:NSSelectorFromString(selectors[i])];
        [self addChild:button];
    }
}

- (void)openAddOnsMenu
{
    ACShip *transport = [[ACShip alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"Transport" ofType:@"ship"]];
    ACShipNode *transportNode = [[ACShipNode alloc] initWithShip:transport size:CGSizeMake(200.0, 200.0)];
    transportNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:transportNode];
    transportNode.thrust = 0.75;
}

- (void)startGame
{
    ACLoadGameScene *loadGameScene = [[ACLoadGameScene alloc] initWithSize:self.size];
    [self.view presentScene:loadGameScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)update:(NSTimeInterval)currentTime
{

}

@end
