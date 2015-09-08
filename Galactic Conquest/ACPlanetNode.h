//
//  ACPlanetNode.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class ACPlanet;
@protocol ACPlanetNodeDelegate;

@interface ACPlanetNode : SK3DNode

@property (strong, nonatomic) ACPlanet *planet;
@property (weak, nonatomic) id<ACPlanetNodeDelegate> delegate;

- (id)initWithPlanet:(ACPlanet *)planet size:(CGSize)size lightAngle:(CGFloat)degrees;

@end

@protocol ACPlanetNodeDelegate <NSObject>

@optional
- (void)planetNodeWasSelected:(ACPlanetNode *)node;

@end