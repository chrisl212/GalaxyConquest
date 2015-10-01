//
//  ACSpaceBattleScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACSpaceBattleScene.h"
#import "ACFleet.h"
#import "ACPlanet.h"
#import "ACPlayer.h"
#import "ACPlanetNode.h"
#import "ACStarNode.h"
#import "ACShip.h"
#import "ACShipNode.h"
#import <SceneKit/SceneKit.h>

@interface ACSpaceBattleScene ()

@property (strong, nonatomic) ACFleet *invadingFleet;
@property (strong, nonatomic) NSArray *defendingFleets;
@property (strong, nonatomic) ACPlayer *invader;
@property (strong, nonatomic) ACPlayer *defender;

@end

@implementation ACSpaceBattleScene

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
    planetNode.geometry = [SCNSphere sphereWithRadius:0.6];
    planetNode.geometry.firstMaterial.diffuse.contents = self.invadingFleet.location.textureImage;//, (int)arc4random_uniform(3) + 1]];
    [scnScene.rootNode addChildNode:planetNode];
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    rotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    rotationAnimation.duration = 250; // One revolution in ten seconds.
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

- (instancetype)initWithInvadingFleet:(ACFleet *)fleet size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.invadingFleet = fleet;
        self.invader = fleet.owner;
        self.defender = fleet.location.owner;
        
        NSMutableArray *defendingFleets = [NSMutableArray array];
        for (ACFleet *f in fleet.location.fleets)
        {
            if ([f.owner isEqual:self.defender])
                [defendingFleets addObject:f];
        }
        self.backgroundColor = [SKColor blackColor];
        
        SK3DNode *planetNode = [[ACPlanetNode alloc] initWithViewportSize:self.size];
        planetNode.position = CGPointMake(CGRectGetMidX(self.frame) - self.size.width/4.0, CGRectGetMidY(self.frame) /*- self.size.height/4.0*/);
        
        planetNode.scnScene = [self planetScene];
        SCNNode *cameraNode = [self cameraNode];
        [planetNode.scnScene.rootNode addChildNode:cameraNode];
        planetNode.pointOfView = cameraNode;
        
        id s1 = [planetNode valueForKey:@"_scnRenderer"];
        NSLog(@"%@", s1);
        [self addChild:planetNode];
        
        ACStarNode *starNode = [[ACStarNode alloc] initWithStar:fleet.location.parentStar];
        starNode.position = CGPointMake(CGRectGetMidX(self.frame)+size.width/4.0, CGRectGetMidY(self.frame) + size.height/4.0);
        [self addChild:starNode];
        
        ACShip *ship = [[ACShip alloc] initWithFile:[[NSBundle mainBundle] pathForResource:@"Transport" ofType:@"ship"]];
        for (int i = 0; i < 4; i++)
        {
            ACShipNode *shipNode = [[ACShipNode alloc] initWithShip:ship size:CGSizeMake(20.0, 20.0)];
            
            shipNode.position = CGPointMake(arc4random_uniform(size.width), arc4random_uniform(size.height));
            shipNode.thrust = 1.0/arc4random_uniform(10)+1;
            [self addChild:shipNode];
        }
    }
    return self;
}

@end
