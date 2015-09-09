//
//  ACPauseMenuScene.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/8/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ACPauseMenuScene : SKScene

@property (strong, nonatomic) SKScene *previousScene;

- (id)initWithPreviousScene:(SKScene *)scene snapshot:(UIImage *)snap;

@end
