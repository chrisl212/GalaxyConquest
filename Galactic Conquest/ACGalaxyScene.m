//
//  ACGalaxyScene.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACGalaxyScene.h"
#import "ACGalaxyNode.h"
#import "ACButtonNode.h"
#import "ACStar.h"
#import "ACGalaxy.h"
#import "ACMainMenuScene.h"
#import "ACStarMapNode.h"
#import "ACStarSystemScene.h"
#import "ACInfoNode.h"

@interface ACGalaxyScene ()

@property (strong, nonatomic) ACGalaxyNode *galaxyNode;

@end

@implementation ACGalaxyScene

- (id)initWithGalaxy:(ACGalaxy *)galaxy size:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.galaxy = galaxy;
        self.backgroundColor = [UIColor blackColor];
        
        self.galaxyNode = [[ACGalaxyNode alloc] initWithGalaxy:self.galaxy];
        
        CGFloat oldHeight = self.galaxyNode.size.height;
        CGFloat scaleFactor = size.height/oldHeight;
        
        CGFloat newHeight = oldHeight * scaleFactor;
        CGFloat newWidth = self.galaxyNode.size.width * scaleFactor;
        
        self.galaxyNode.size = CGSizeMake(newWidth, newHeight);
        self.galaxyNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        [self addChild:self.galaxyNode];
        
        ACButtonNode *menuButton = [[ACButtonNode alloc] initWithTitle:@"Menu" font:[UIFont systemFontOfSize:14.0]];
        menuButton.position = CGPointMake(menuButton.frame.size.width/2.0, self.frame.size.height - menuButton.frame.size.height/2.0);
        [menuButton addTarget:self action:@selector(pauseMenu)];
        [self addChild:menuButton];
        
        for (ACStar *star in self.galaxy.stars)
        {
            ACStarMapNode *starMapNode = [[ACStarMapNode alloc] initWithStar:star];
            starMapNode.position = CGPointMake(arc4random_uniform(newWidth) - newWidth/2.0, arc4random_uniform(newHeight) - newHeight/2.0);
            [starMapNode addTarget:self action:@selector(starSelected:)];
            
            ACInfoNode *infoNode = [[ACInfoNode alloc] initWithStrings:@[star.name, [NSString stringWithFormat:@"%lu planets", (unsigned long)star.planets.count]] size:CGSizeMake(80.0, 40.0)];
            infoNode.anchorPoint = CGPointMake(0.0, 1.0);
            infoNode.position = starMapNode.position;
            
            [self.galaxyNode addChild:infoNode];
            [self.galaxyNode addChild:starMapNode];
        }
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
}

- (void)update:(NSTimeInterval)currentTime
{
    [self.galaxyNode runAction:[SKAction rotateByAngle:-0.0005 duration:0.0]];
}

- (void)pauseMenu
{
    ACMainMenuScene *mainMenuScene = [[ACMainMenuScene alloc] initWithSize:self.size];
    [self.view presentScene:mainMenuScene transition:[SKTransition fadeWithDuration:0.5]];
}

- (void)starSelected:(ACStarMapNode *)starMapNode
{
    ACStarSystemScene *starSystemScene = [[ACStarSystemScene alloc] initWithStar:starMapNode.star size:self.size];
    [self.view presentScene:starSystemScene transition:[SKTransition fadeWithDuration:0.5]];
}

@end
