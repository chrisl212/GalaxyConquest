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
#import "ACAIPlayer.h"
#import "ACButtonNode.h"
#import "AppDelegate.h"
#import <GameKit/GameKit.h>

@interface ACLoadGameScene ()

@property (strong, nonatomic) UITextField *gameNameTextField;
@property (strong, nonatomic) UILabel *numberOfPlayersLabel;

@end

@implementation ACLoadGameScene

- (NSMutableArray *)colorsArray
{
    return @[[UIColor redColor], [UIColor greenColor], [UIColor orangeColor], [UIColor purpleColor], [UIColor cyanColor], [UIColor yellowColor], [UIColor brownColor]].mutableCopy;
}

- (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)createUIInView:(SKView *)view
{
    self.gameNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 20.0)];
    self.gameNameTextField.center = CGPointMake(CGRectGetMidX(view.frame) + self.gameNameTextField.frame.size.width/2.0, CGRectGetMidY(view.frame) - view.frame.size.height/5.0);
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
    
    self.numberOfPlayersLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 20.0)];
    self.numberOfPlayersLabel.text = @"Number of Players: 4";
    self.numberOfPlayersLabel.center = CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(self.frame));
    self.numberOfPlayersLabel.textColor = [UIColor whiteColor];
    self.numberOfPlayersLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:self.numberOfPlayersLabel];
    
    UIStepper *numberOfPlayersStepper = [[UIStepper alloc] init];
    numberOfPlayersStepper.minimumValue = 2.0;
    numberOfPlayersStepper.maximumValue = 8.0;
    numberOfPlayersStepper.value = 4.0;
    numberOfPlayersStepper.tintColor = [UIColor whiteColor];
    numberOfPlayersStepper.center = CGPointMake(self.numberOfPlayersLabel.center.x + (self.numberOfPlayersLabel.frame.size.width/2.0 + numberOfPlayersStepper.frame.size.width/2.0), self.numberOfPlayersLabel.center.y);
    [numberOfPlayersStepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:numberOfPlayersStepper];
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

- (void)stepperValueChanged:(UIStepper *)stepper
{
    self.numberOfPlayersLabel.text = [NSString stringWithFormat:@"Number of Players: %.0lF", stepper.value];
}

- (void)createGame
{
    NSInteger numberOfPlayers = [[self.numberOfPlayersLabel.text componentsSeparatedByString:@":"][1] integerValue];
    NSString *name = ([[GKLocalPlayer localPlayer] isAuthenticated]) ? [[GKLocalPlayer localPlayer] alias] : [[UIDevice currentDevice] name];
    ACPlayer *localPlayer = [[ACPlayer alloc] initWithName:name];
    localPlayer.player1 = YES;
    localPlayer.color = [UIColor blueColor];
    
    NSMutableArray *colorsArray = [self colorsArray];
    NSMutableArray *playersArray = @[localPlayer].mutableCopy;
    for (NSInteger i = 1; i < numberOfPlayers; i++)
    {
        NSString *playerName = [NSString stringWithFormat:@"Player%ld", i];
        ACAIPlayer *player = [[ACAIPlayer alloc] initWithName:playerName];
        NSInteger randomNumber = (NSInteger)arc4random_uniform((uint32_t)colorsArray.count);
        player.color = colorsArray[randomNumber];
        [playersArray addObject:player];
        
        [colorsArray removeObjectAtIndex:randomNumber];
    }
    
    ACGame *game = [[ACGame alloc] initWithName:self.gameNameTextField.text players:[NSArray arrayWithArray:playersArray]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCurrentGame" object:game];

    ACGalaxyScene *galaxyScene = [[ACGalaxyScene alloc] initWithGalaxy:game.galaxy size:self.size];
    [self.view presentScene:galaxyScene transition:[SKTransition fadeWithDuration:0.5]];
    [game startGame];
    
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
    [game startGame];
    
    [self removeViews];
}

@end
