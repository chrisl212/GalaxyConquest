//
//  ACSpaceBattleScene.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class ACFleet, ACPlanet;

@interface ACSpaceBattleScene : SKScene

- (id)initWithInvadingFleet:(ACFleet *)fleet size:(CGSize)size;

@end
