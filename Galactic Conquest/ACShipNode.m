//
//  ACShipNode.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACShipNode.h"
#import "ACShip.h"
#import <SceneKit/SceneKit.h>

@implementation ACShipNode
{
    SKEmitterNode *emitterNode;
    SK3DNode *shipNode;
}

- (id)initWithShip:(ACShip *)ship size:(CGSize)size
{
    if (self = [super initWithColor:[UIColor clearColor] size:size])
    {
        emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"ACEngineEmitter" ofType:@"sks"]];
        emitterNode.position = CGPointMake(CGRectGetMaxX(self.frame)-10.0, CGRectGetMidY(self.frame));
        [emitterNode runAction:[SKAction rotateByAngle:(-90.0)*M_PI/180.0 duration:0.0]];
        emitterNode.particleScale = emitterNode.particleScale/(.005 * size.width);
        [self addChild:emitterNode];
        
        shipNode = [[SK3DNode alloc] initWithViewportSize:size];
        shipNode.scnScene = [SCNScene sceneNamed:ship.sceneFileName];
        shipNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [shipNode runAction:[SKAction rotateByAngle:90*M_PI/180.0 duration:0.0]];
        [self addChild:shipNode];
    }
    return self;
}

- (void)performTurn:(ACShipTurn)turn
{
    SCNNode *node = [shipNode.scnScene.rootNode childNodeWithName:@"ship" recursively:NO];
    
    /*
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation.z"];
    rotationAnimation.toValue = @(-M_PI/2.0);//[NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
    rotationAnimation.duration = 10.0; // One revolution in ten seconds.
    rotationAnimation.repeatCount = FLT_MAX; // Repeat the animation forever.
    [node addAnimation:rotationAnimation forKey:nil]; // Attach the animation to the node to start it.
    */
    //CATransform3D transform = CATransform3DMakeRotation(M_PI/2.0, 0, 1, 0);
    [SCNTransaction begin];
    [SCNTransaction setAnimationDuration:10.0];
    node.rotation = SCNVector4Make(0.0, 0.0, 1.0, M_PI/4.0);
    [SCNTransaction commit];

    switch (turn)
    {
        case ACShipTurnLeft:
            
            break;
            
        default:
            break;
    }
}

- (void)setThrust:(CGFloat)thrust
{
    _thrust = thrust;
    emitterNode.particleLifetime = thrust;
}

@end
