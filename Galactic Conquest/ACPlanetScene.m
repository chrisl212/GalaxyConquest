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
        
        NSArray *planetInfoStrings = @[planet.name, [NSString stringWithFormat:@"Mineral value: %ld", planet.mineralValue], [NSString stringWithFormat:@"Fuel value: %ld", planet.fuelValue], [NSString stringWithFormat:@"Owner: %@", planet.owner.name], [NSString stringWithFormat:@"Fleets: %ld", planet.fleets.count]];

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

- (BOOL)userCanAffordCost:(ACBuildCost)cost
{
    if ([self currentPlayer].fuel < cost.fuelCost || [self currentPlayer].minerals < cost.mineralsCost)
        return NO;
    return YES;
}

- (void)userDidBuildShips:(NSArray *)ships cost:(ACBuildCost)cost
{
    for (UIView *subview in self.view.subviews)
    {
        [subview removeFromSuperview];
        for (SKNode *node in self.children)
        {
            node.userInteractionEnabled = YES;
        }
    }
    
    if (!self.planet.fleets || self.planet.fleets.count  < 1)
    {
        ACFleet *newFleet = [[ACFleet alloc] initWithOwner:[self currentPlayer]];
        newFleet.name = @"Fleet1";
        newFleet.location = self.planet;
        [newFleet.ships addObjectsFromArray:ships];
        self.planet.fleets = @[newFleet];
    }
    else
    {
        ACFleet *fleet = self.planet.fleets[0];
        [fleet.ships addObjectsFromArray:ships];
    }
    ACPlayer *currentPlayer = [self currentPlayer];
    currentPlayer.fuel -= cost.fuelCost;
    currentPlayer.minerals -= cost.mineralsCost;
    NSLog(@"Built %ld ships for %ld fuel and %ld minerals", ships.count, cost.fuelCost, cost.mineralsCost);
}

- (void)openBuildMenu
{
    buildDataSource = [[ACBuildTableViewDataSource alloc] initWithDelegate:self];
    
    UITableView *buildTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 300.0) style:UITableViewStyleGrouped];
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
    [UIView animateWithDuration:0.5 animations:^{
        buildTableView.alpha = 1.0;
        backgroundView.alpha = 0.6;
    }];
}

- (void)openFleetsMenu
{
    fleetsDataSource = [[ACFleetsTableViewDataSource alloc] initWithPlanet:self.planet delegate:self];
    
    UITableView *buildTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300.0, 300.0) style:UITableViewStyleGrouped];
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
    [UIView animateWithDuration:0.5 animations:^{
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
        [subview removeFromSuperview];
        
    }
    for (SKNode *node in self.children)
    {
        node.userInteractionEnabled = YES;
    }
}

@end
