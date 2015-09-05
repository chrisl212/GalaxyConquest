//
//  ACMainMenuScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACMainMenuScene.h"
#import "ACButtonNode.h"
#import "ACLoadGameScene.h"

@implementation ACMainMenuScene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.backgroundColor = [SKColor blackColor];
    
    ACButtonNode *startGameButton = [[ACButtonNode alloc] initWithTitle:@"Start Game"];
    startGameButton.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [startGameButton addTarget:self action:@selector(startGame)];
    [self addChild:startGameButton];
}

- (void)startGame
{
    ACLoadGameScene *loadGameScene = [[ACLoadGameScene alloc] initWithSize:self.size];
    [self.view presentScene:loadGameScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
