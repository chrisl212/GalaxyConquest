//
//  ACStarNode.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACStarNode.h"
#import "ACStar.h"

@interface ACStarNode ()

@property (strong, nonatomic) SKEmitterNode *emitterNode;

@end

@implementation ACStarNode

- (id)initWithStar:(ACStar *)star
{
    if (self = [super init])
    {
        self.emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"ACStar" ofType:@"sks"]];
        [self.emitterNode advanceSimulationTime:80.0];
        [self addChild:self.emitterNode];
    }
    return self;
}

@end
