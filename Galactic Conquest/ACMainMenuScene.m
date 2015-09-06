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
    
    NSArray *buttonTitles = @[@"Start Game", @"Add-ons", @"Options"];
    NSArray *selectors = @[@"startGame", @"", @""];
    
    for (NSInteger i = 0; i < buttonTitles.count; i++)
    {
        CGFloat partHeight = self.size.height/(buttonTitles.count+1);
        
        ACButtonNode *button = [[ACButtonNode alloc] initWithTitle:buttonTitles[i]];
        button.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - (partHeight * (i + 1)));
        [button addTarget:self action:NSSelectorFromString(selectors[i])];
        [self addChild:button];
    }
}

- (void)startGame
{
    ACLoadGameScene *loadGameScene = [[ACLoadGameScene alloc] initWithSize:self.size];
    [self.view presentScene:loadGameScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
