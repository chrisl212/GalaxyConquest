//
//  ACPlanetScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlanetScene.h"
#import "ACButtonNode.h"
#import "ACPlanetNode.h"
#import "ACPlanet.h"
#import "ACStar.h"
#import "ACPlayer.h"
#import "ACMainMenuScene.h"
#import "ACGame.h"
#import "AppDelegate.h"
#import "ACStarSystemScene.h"
#import "ACPauseMenuScene.h"
#import "ACFleet.h"

#define BUTTON_PADDING 2.0
#define ANIMATION_DURATION 0.5

@implementation ACPlanetScene
{
    ACBuildTableViewDataSource *buildDataSource;
    ACFleetsTableViewDataSource *fleetsDataSource;
}

- (ACPlayer *)currentPlayer
{
    return [(AppDelegate *)[UIApplication sharedApplication].delegate currentGame].currentPlayer;
}

- (id)initWithPlanet:(ACPlanet *)planet size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.planet = planet;
        self.backgroundColor = [SKColor blackColor];
        
        CGFloat planetHeight = self.size.height - 40.0;
        CGFloat planetWidth = planetHeight;
        CGFloat x = planetWidth/2.0;
        CGFloat y = CGRectGetMidY(self.frame);
        
        ACPlanetNode *planetNode = [[ACPlanetNode alloc] initWithPlanet:planet size:CGSizeMake(planetWidth, planetHeight) lightAngle:120.0];
        planetNode.position = CGPointMake(x, y);
        [self addChild:planetNode];
        
        ACButtonNode *menuButton = [[ACButtonNode alloc] initWithTitle:@"Menu" font:[UIFont systemFontOfSize:14.0]];
        menuButton.position = CGPointMake(menuButton.frame.size.width/2.0, self.frame.size.height - menuButton.frame.size.height/2.0);
        [menuButton addTarget:self action:@selector(pauseMenu)];
        [self addChild:menuButton];
        
        ACButtonNode *starButton = [[ACButtonNode alloc] initWithTitle:planet.parentStar.name font:[UIFont systemFontOfSize:14.0]];
        starButton.position = CGPointMake(self.frame.size.width - starButton.frame.size.width/2.0, self.frame.size.height - starButton.frame.size.height/2.0);
        [starButton addTarget:self action:@selector(displayStar)];
        [self addChild:starButton];
        
        ACButtonNode *fleetsButton = [[ACButtonNode alloc] initWithTitle:@"Fleets" font:[UIFont systemFontOfSize:14.0]];
        [fleetsButton addTarget:self action:@selector(openFleetsMenu)];
        fleetsButton.position = CGPointMake(fleetsButton.size.width/2.0, fleetsButton.size.height/2.0);
        [self addChild:fleetsButton];
        
        NSArray *planetInfoStrings = @[[NSString stringWithFormat:@"Mineral value: %ld", planet.mineralValue], [NSString stringWithFormat:@"Fuel value: %ld", planet.fuelValue], [NSString stringWithFormat:@"Owner: %@", planet.owner.name], [NSString stringWithFormat:@"Fleets: %ld", planet.fleets.count]];

        UIFont *font = [UIFont systemFontOfSize:22.0];
        for (NSInteger i = 0; i < planetInfoStrings.count; i++)
        {
            SKLabelNode *labelNode = [[SKLabelNode alloc] initWithFontNamed:font.fontName];
            labelNode.fontSize = font.pointSize;
            labelNode.text = planetInfoStrings[i];
            labelNode.fontColor = [UIColor whiteColor];
            labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            labelNode.position = CGPointMake(size.width/2.0, (size.height - starButton.size.height) - (((size.height - starButton.size.height)/(planetInfoStrings.count + 1)) * (i + 1)));
            [self addChild:labelNode];
        }
        
        SKLabelNode *planetNameLabelNode = [[SKLabelNode alloc] initWithFontNamed:font.fontName];
        planetNameLabelNode.fontSize = font.pointSize;
        planetNameLabelNode.text = planet.name;
        planetNameLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        planetNameLabelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        planetNameLabelNode.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - planetNameLabelNode.frame.size.height/2.0);
        [self addChild:planetNameLabelNode];
        
        if (self.planet.owner.isPlayer1)
        {
            ACButtonNode *buildFleetButton = [[ACButtonNode alloc] initWithTitle:@"Build..." font:[UIFont systemFontOfSize:14.0]];
            buildFleetButton.position = CGPointMake(buildFleetButton.size.width/2.0 + fleetsButton.size.width + BUTTON_PADDING, buildFleetButton.size.height/2.0);
            [buildFleetButton addTarget:self action:@selector(openBuildMenu)];
            [self addChild:buildFleetButton];
        }
    }
    return self;
}

- (BOOL)userCanAffordCost:(struct ACBuildCost)cost
{
    return [[self currentPlayer] playerCanAffordCost:cost];
}

- (void)userDidBuildShips:(NSArray *)ships cost:(ACBuildCost)cost
{
    [self dismissFleetsTable];
    if (ships.count > 0)
        [[self currentPlayer] buildShips:ships atPlanet:self.planet forCost:cost];
}

- (void)openBuildMenu
{
    buildDataSource = [[ACBuildTableViewDataSource alloc] initWithDelegate:self];
    
    UITableView *buildTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300.0, self.view.frame.size.height) style:UITableViewStyleGrouped];
    buildTableView.dataSource = buildDataSource;
    buildTableView.delegate = buildDataSource;
    [buildTableView registerNib:[UINib nibWithNibName:@"ACBuildCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    buildTableView.center = self.view.center;
    buildTableView.backgroundColor = [UIColor blackColor];
    buildTableView.alpha = 0.0;
    [self.view addSubview:buildTableView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0;
    [self.view insertSubview:backgroundView belowSubview:buildTableView];
    
    for (SKNode *node in self.children)
    {
        node.userInteractionEnabled = NO;
    }
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        buildTableView.alpha = 1.0;
        backgroundView.alpha = 0.6;
    }];
}

- (void)openFleetsMenu
{
    fleetsDataSource = [[ACFleetsTableViewDataSource alloc] initWithPlanet:self.planet delegate:self];
    
    UITableView *buildTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300.0, self.view.frame.size.height) style:UITableViewStyleGrouped];
    buildTableView.dataSource = fleetsDataSource;
    buildTableView.delegate = fleetsDataSource;
    buildTableView.center = self.view.center;
    buildTableView.backgroundColor = [UIColor blackColor];
    buildTableView.alpha = 0.0;
    [self.view addSubview:buildTableView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0.0;
    [self.view insertSubview:backgroundView belowSubview:buildTableView];
    
    for (SKNode *node in self.children)
    {
        node.userInteractionEnabled = NO;
    }
    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        buildTableView.alpha = 1.0;
        backgroundView.alpha = 0.6;
    }];
}

- (void)pauseMenu
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 2.0);
    [self.view drawViewHierarchyInRect:self.frame afterScreenUpdates:NO];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    ACPauseMenuScene *pauseMenuScene = [[ACPauseMenuScene alloc] initWithPreviousScene:self snapshot:viewImage];
    [self.view presentScene:pauseMenuScene];
}

- (void)displayStar
{
    ACStarSystemScene *starSystemScene = [[ACStarSystemScene alloc] initWithStar:self.planet.parentStar size:self.size];
    [self.view presentScene:starSystemScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)dismissFleetsTable
{
    for (UIView *subview in self.view.subviews)
    {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            subview.alpha = 0.0;
        } completion:^(BOOL fi){
            if (fi)
                [subview removeFromSuperview];
        }];
    }
    for (SKNode *node in self.children)
    {
        node.userInteractionEnabled = YES;
    }
}

@end
