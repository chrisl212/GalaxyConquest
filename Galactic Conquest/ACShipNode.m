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
}

- (id)initWithShip:(ACShip *)ship size:(CGSize)size
{
    if (self = [super initWithColor:[UIColor clearColor] size:size])
    {
        SK3DNode *shipNode = [[SK3DNode alloc] initWithViewportSize:size];
        shipNode.scnScene = [SCNScene sceneNamed:ship.sceneFileName];
        shipNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [shipNode runAction:[SKAction rotateByAngle:90*M_PI/180.0 duration:0.0]];
        [self addChild:shipNode];
        
        emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"ACEngineEmitter" ofType:@"sks"]];
        emitterNode.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMidY(self.frame));
        [emitterNode runAction:[SKAction rotateByAngle:(90.0)*M_PI/180.0 duration:0.0]];
        [self addChild:emitterNode];
    }
    return self;
}

- (void)setThrust:(CGFloat)thrust
{
    _thrust = thrust;
    emitterNode.particleLifetime = thrust;
}

@end
