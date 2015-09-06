//
//  ACStarMapNode.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/5/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACStarMapNode.h"

@interface ACStarMapNode ()

@property (strong, nonatomic) NSMutableArray *targets;
@property (strong, nonatomic) NSMutableArray *actions;

@end

@implementation ACStarMapNode

- (id)initWithStar:(ACStar *)star
{
    if (self = [super init])
    {
        self.star = star;
        self.targets = @[].mutableCopy;
        self.actions = @[].mutableCopy;
        self.userInteractionEnabled = YES;
        
        self.emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"ACStarMapParticle" ofType:@"sks"]];
        [self.emitterNode advanceSimulationTime:30.0];
        self.emitterNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:self.emitterNode];
    }
    return self;
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self.targets addObject:target];
    [self.actions addObject:NSStringFromSelector(action)];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    for (NSInteger i = 0; i < self.targets.count; i++)
    {
        [self.targets[i] performSelector:NSSelectorFromString(self.actions[i]) withObject:self];
    }
}

@end
