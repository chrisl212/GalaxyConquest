//
//  ACPlanetNode.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlanetNode.h"
#import "ACPlanet.h"
#import <SceneKit/SceneKit.h>

NSInteger quadrantFromDegrees(double deg)
{
    if (deg >= 0 && deg <= 90)
        return 1;
    else if (deg <= 180)
        return 4;
    else if (deg <= 270)
        return 3;
    else
        return 2;
}

SCNVector3 vectorFromQuadrant(NSInteger q)
{
    switch (q)
    {
        case 1:
            return SCNVector3Make(-1.0, -1.0, 8.0);
            
        case 2:
            return SCNVector3Make(1.0, -1.0, 8.0);
            
        case 3:
            return SCNVector3Make(1.0, 1.0, 8.0);
            
        case 4:
            return SCNVector3Make(-1.0, 1.0, 8.0);
            
        default:
            return SCNVector3Make(1.0, 1.0, 8.0);
    }
}

@implementation ACPlanetNode

- (id)initWithPlanet:(ACPlanet *)planet size:(CGSize)size lightAngle:(CGFloat)degrees
{
    if (self = [super initWithViewportSize:size])
    {
        self.planet = planet;
        self.userInteractionEnabled = YES;

        self.scnScene = [SCNScene scene];

        SCNNode *planetNode = [[SCNNode alloc] init];
        planetNode.geometry = [SCNSphere sphereWithRadius:2.0];
        planetNode.geometry.firstMaterial.diffuse.contents = planet.textureImage;
        [self.scnScene.rootNode addChildNode:planetNode];
        
        if (planet.atmosphere)
        {
            SCNNode *atmosphereNode = [SCNNode nodeWithGeometry:[SCNSphere sphereWithRadius:2.1]];
            atmosphereNode.opacity = 0.3;
            atmosphereNode.geometry.firstMaterial.diffuse.contents = [UIColor colorWithRed:0.7 green:0.7 blue:1.0 alpha:1.0];
            [self.scnScene.rootNode addChildNode:atmosphereNode];
        }
        
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"rotation"];
        rotationAnimation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI * 2)];
        rotationAnimation.duration = 50; // One revolution in ten seconds.
        rotationAnimation.repeatCount = FLT_MAX; // Repeat the animation forever.
        [planetNode addAnimation:rotationAnimation forKey:nil]; // Attach the animation to the node to start it.
        
        SCNCamera *camera = [SCNCamera camera];
        camera.xFov = 0;
        camera.yFov = 0;
        camera.zNear = 0.0;
        camera.zFar = 10.0;
        SCNNode *cameraNode = [SCNNode node];
        cameraNode.camera = camera;
        cameraNode.position = SCNVector3Make(0, 0, 5);
        [self.scnScene.rootNode addChildNode:cameraNode];
        
        SCNLight *light = [SCNLight light];
        light.type = SCNLightTypeSpot;
        SCNNode *lightNode = [SCNNode node];
        lightNode.light = light;
        lightNode.position = vectorFromQuadrant(quadrantFromDegrees(degrees));
        [self.scnScene.rootNode addChildNode:lightNode];
        
        self.pointOfView = cameraNode;
        //self.autoenablesDefaultLighting = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if ([self.delegate respondsToSelector:@selector(planetNodeWasSelected:)])
        [self.delegate planetNodeWasSelected:self];
}

@end
