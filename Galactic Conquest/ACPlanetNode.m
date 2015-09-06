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

@implementation ACPlanetNode

- (id)initWithPlanet:(ACPlanet *)planet size:(CGSize)size
{
    if (self = [super initWithViewportSize:size])
    {
        self.planet = planet;
        self.userInteractionEnabled = YES;
        
        self.scnScene = [[SCNScene alloc] init];
        SCNNode *planetNode = [[SCNNode alloc] init];
        planetNode.geometry = [SCNSphere sphereWithRadius:2.0];
        planetNode.geometry.firstMaterial.diffuse.contents = planet.textureImage;
        [self.scnScene.rootNode addChildNode:planetNode];
        
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
        
        self.pointOfView = cameraNode;
        self.autoenablesDefaultLighting = YES;
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
