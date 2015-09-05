//
//  ACLoadGameScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACLoadGameScene.h"
#import "ACMainMenuScene.h"
#import "ACGame.h"
#import "ACGalaxyScene.h"
#import "ACButtonNode.h"

@interface ACLoadGameScene ()

@property (strong, nonatomic) UITextField *gameNameTextField;

@end

@implementation ACLoadGameScene

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
    self.backgroundColor = [UIColor blackColor];
    
    ACButtonNode *createGameButton = [[ACButtonNode alloc] initWithTitle:@"Start"];
    createGameButton.position = CGPointMake(self.frame.size.width - createGameButton.frame.size.width/2.0, createGameButton.frame.size.height/2.0);
    [createGameButton addTarget:self action:@selector(createGame)];
    [self addChild:createGameButton];
    
    ACButtonNode *loadGameButton = [[ACButtonNode alloc] initWithTitle:@"Load..."];
    loadGameButton.position = CGPointMake(loadGameButton.frame.size.width/2.0, loadGameButton.frame.size.height/2.0);
    [self addChild:loadGameButton];
    
    self.gameNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 20.0)];
    self.gameNameTextField.center = self.view.center;
    self.gameNameTextField.text = @"Game name";
    self.gameNameTextField.textColor = [UIColor whiteColor];
    self.gameNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [view addSubview:self.gameNameTextField];
    
    ACButtonNode *backButton = [[ACButtonNode alloc] initWithTitle:@"Back" font:[UIFont systemFontOfSize:16.0]];
    [backButton addTarget:self action:@selector(goBack)];
    backButton.position = CGPointMake(backButton.frame.size.width/2.0, self.frame.size.height - backButton.frame.size.height/2.0);
    [self addChild:backButton];
}

- (void)createGame
{
    ACGame *game = [[ACGame alloc] initWithName:self.gameNameTextField.text];
    ACGalaxyScene *galaxyScene = [[ACGalaxyScene alloc] initWithGalaxy:game.galaxy size:self.size];
    [self.view presentScene:galaxyScene transition:[SKTransition fadeWithDuration:0.5]];
    
    [self.gameNameTextField removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCurrentGame" object:game];
}

- (void)goBack
{
    ACMainMenuScene *mainMenuScene = [[ACMainMenuScene alloc] initWithSize:self.size];
    [self.view presentScene:mainMenuScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
