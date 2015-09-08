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
#import "ACPlayer.h"
#import "ACButtonNode.h"
#import "AppDelegate.h"
#import <GameKit/GameKit.h>

@interface ACLoadGameScene ()

@property (strong, nonatomic) UITextField *gameNameTextField;
@property (strong, nonatomic) UITextField *numberOfPlayersTextField;

@end

@implementation ACLoadGameScene

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)createUIInView:(SKView *)view
{
    self.gameNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 20.0)];
    self.gameNameTextField.center = CGPointMake(CGRectGetMidX(view.frame) + self.gameNameTextField.frame.size.width/2.0, CGRectGetMidY(view.frame) - view.frame.size.height/4.0);
    self.gameNameTextField.text = @"Game name";
    self.gameNameTextField.textColor = [UIColor whiteColor];
    self.gameNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.gameNameTextField addTarget:self.gameNameTextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.gameNameTextField.textAlignment = NSTextAlignmentLeft;
    [view addSubview:self.gameNameTextField];
    
    UILabel *gameNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 20.0)];
    gameNameLabel.text = @"Name:";
    gameNameLabel.center = CGPointMake(CGRectGetMidX(view.frame) - gameNameLabel.frame.size.width/2.0, self.gameNameTextField.center.y);
    gameNameLabel.textColor = [UIColor whiteColor];
    gameNameLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:gameNameLabel];
    
    self.numberOfPlayersTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 20.0)];
    self.numberOfPlayersTextField.center = CGPointMake(CGRectGetMidX(view.frame) + self.numberOfPlayersTextField.frame.size.width/2.0, CGRectGetMidY(view.frame));
    self.numberOfPlayersTextField.text = @"4";
    self.numberOfPlayersTextField.textColor = [UIColor whiteColor];
    self.numberOfPlayersTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numberOfPlayersTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.numberOfPlayersTextField addTarget:self.gameNameTextField action:@selector(resignFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.numberOfPlayersTextField.textAlignment = NSTextAlignmentLeft;
    [view addSubview:self.numberOfPlayersTextField];
    
    UILabel *numberOfPlayersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 20.0)];
    numberOfPlayersLabel.text = @"Number of Players:";
    numberOfPlayersLabel.center = CGPointMake(CGRectGetMidX(view.frame) - numberOfPlayersLabel.frame.size.width/2.0, self.numberOfPlayersTextField.center.y);
    numberOfPlayersLabel.textColor = [UIColor whiteColor];
    numberOfPlayersLabel.textAlignment = NSTextAlignmentRight;
    [view addSubview:numberOfPlayersLabel];
}

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
    [loadGameButton addTarget:self action:@selector(openLoadViewController)];
    [self addChild:loadGameButton];
    
    ACButtonNode *backButton = [[ACButtonNode alloc] initWithTitle:@"Back" font:[UIFont systemFontOfSize:16.0]];
    [backButton addTarget:self action:@selector(goBack)];
    backButton.position = CGPointMake(backButton.frame.size.width/2.0, self.frame.size.height - backButton.frame.size.height/2.0);
    [self addChild:backButton];
    
    [self createUIInView:view];
}

- (void)removeViews
{
    for (UIView *view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
}

- (void)createGame
{
    NSInteger numberOfPlayers = [self.numberOfPlayersTextField.text integerValue];
    NSString *name = ([[GKLocalPlayer localPlayer] isAuthenticated]) ? [[GKLocalPlayer localPlayer] alias] : [[UIDevice currentDevice] name];
    ACPlayer *localPlayer = [[ACPlayer alloc] initWithName:name];
    localPlayer.player1 = YES;
    localPlayer.color = [UIColor blueColor];
    NSMutableArray *playersArray = @[localPlayer].mutableCopy;
    for (NSInteger i = 1; i < numberOfPlayers; i++)
    {
        NSString *playerName = [NSString stringWithFormat:@"Player%ld", i];
        [playersArray addObject:[[ACPlayer alloc] initWithName:playerName]];
    }
    
    ACGame *game = [[ACGame alloc] initWithName:self.gameNameTextField.text players:[NSArray arrayWithArray:playersArray]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCurrentGame" object:game];

    ACGalaxyScene *galaxyScene = [[ACGalaxyScene alloc] initWithGalaxy:game.galaxy size:self.size];
    [self.view presentScene:galaxyScene transition:[SKTransition fadeWithDuration:0.5]];
    
    [self removeViews];
}

- (void)goBack
{
    ACMainMenuScene *mainMenuScene = [[ACMainMenuScene alloc] initWithSize:self.size];
    [self.view presentScene:mainMenuScene transition:[SKTransition fadeWithDuration:0.5]];
    
    [self removeViews];
}

- (void)openLoadViewController
{
    ACLoadGameViewController *loadViewController = [[ACLoadGameViewController alloc] initWithDelegate:self];
    [[[self appDelegate].window rootViewController] presentViewController:loadViewController animated:YES completion:nil];
}

- (void)gameWasSelected:(ACGame *)game
{
    [[[self appDelegate].window rootViewController] dismissViewControllerAnimated:YES completion:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCurrentGame" object:game];
    
    ACGalaxyScene *galaxyScene = [[ACGalaxyScene alloc] initWithGalaxy:game.galaxy size:self.size];
    [self.view presentScene:galaxyScene transition:[SKTransition fadeWithDuration:0.5]];
    
    [self removeViews];
}

@end
