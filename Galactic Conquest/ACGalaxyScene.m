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
        [self addChild:menuButton];
    }
    return self;
}

- (void)didMoveToView:(SKView *)view
{
    [super didMoveToView:view];
}

- (void)update:(NSTimeInterval)currentTime
{
    [self.galaxyNode runAction:[SKAction rotateByAngle:-0.0007 duration:0.0]];
}

@end
