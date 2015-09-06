//
//  ACPlanetScene.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class ACPlanet;

@interface ACPlanetScene : SKScene

@property (strong, nonatomic) ACPlanet *planet;

- (id)initWithPlanet:(ACPlanet *)planet size:(CGSize)size;

@end
