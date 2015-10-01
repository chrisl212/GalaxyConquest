//
//  ACShipNode.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, ACShipTurn)
{
    ACShipTurnStraight,
    ACShipTurnLeft,
    ACShipTurnRight
};

@class ACShip;

@interface ACShipNode : SKSpriteNode

@property (nonatomic) CGFloat thrust;

- (id)initWithShip:(ACShip *)ship size:(CGSize)size;
- (void)performTurn:(ACShipTurn)turn;

@end
