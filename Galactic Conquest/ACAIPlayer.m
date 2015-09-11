//
//  ACAIPlayer.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/8/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACAIPlayer.h"

@implementation ACAIPlayer

- (void)beginTurn
{
    NSLog(@"AI turn has started for player %@", self.name);
    dispatch_async(dispatch_queue_create("com.a-cstudios.ai", NULL), ^{
        //sleep(1);
        [self.delegate playerDidFinishTurn:self];
    });
}

@end
