//
//  ACStarSystemScene.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ACPlanetNode.h"

@class ACStar;

@interface ACStarSystemScene : SKScene <ACPlanetNodeDelegate>

@property (strong, nonatomic) ACStar *star;

- (id)initWithStar:(ACStar *)star size:(CGSize)size;

@end
