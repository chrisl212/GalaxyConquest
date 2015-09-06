//
//  ACStarMapNode.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/5/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class ACStar;

@interface ACStarMapNode : SKNode

@property (strong, nonatomic) SKEmitterNode *emitterNode;
@property (strong, nonatomic) ACStar *star;

- (void)addTarget:(id)target action:(SEL)action;
- (id)initWithStar:(ACStar *)star;

@end
