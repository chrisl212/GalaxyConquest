//
//  ACGalaxyScene.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class ACGalaxy;

@interface ACGalaxyScene : SKScene

@property (strong, nonatomic) ACGalaxy *galaxy;

- (id)initWithGalaxy:(ACGalaxy *)galaxy size:(CGSize)size;

@end
