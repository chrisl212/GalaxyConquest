//
//  ACPauseMenuScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/8/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPauseMenuScene.h"
#import "ACButtonNode.h"
#import "AppDelegate.h"
#import "ACMainMenuScene.h"
#import "ACGame.h"

@implementation ACPauseMenuScene

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (instancetype)initWithPreviousScene:(SKScene *)scene snapshot:(UIImage *)snap
{
    if (self = [super initWithSize:scene.size])
    {
        SKSpriteNode *backgroundNode = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:snap]];
        backgroundNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:backgroundNode];
        backgroundNode.color = [UIColor blackColor];
        backgroundNode.colorBlendFactor = 0.75;
        
        self.previousScene = scene;
        self.backgroundColor = [UIColor blackColor];
        
        NSArray *buttonDictionaries = @[@{@"title" : @"Resume", @"selector" : @"resume"}, @{@"title" : @"Save", @"selector" : @"saveGame"}, @{@"title" : @"Quit Game", @"selector" : @"openMainMenu"}];
        
        NSInteger screenPartitions = buttonDictionaries.count + 1;
        CGFloat partitionHeight = self.frame.size.height/screenPartitions;
        
        CGFloat x = CGRectGetMidX(self.frame);
        CGFloat y = CGRectGetMaxY(self.frame);
        for (NSDictionary *dictionary in buttonDictionaries)
        {
            y -= partitionHeight;
            ACButtonNode *buttonNode = [[ACButtonNode alloc] initWithTitle:dictionary[@"title"] font:[UIFont systemFontOfSize:14.0]];
            buttonNode.position = CGPointMake(x, y);
            [buttonNode addTarget:self action:NSSelectorFromString(dictionary[@"selector"])];
            [self addChild:buttonNode];
        }
    }
    return self;
}

- (void)resume
{
    [self.view presentScene:self.previousScene];
}

- (void)saveGame
{
    [[self appDelegate].currentGame saveGame];
}

- (void)openMainMenu
{
    ACMainMenuScene *mainMenuScene = [[ACMainMenuScene alloc] initWithSize:self.size];
    [self.view presentScene:mainMenuScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
