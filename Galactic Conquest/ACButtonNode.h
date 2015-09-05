//
//  ACButtonNode.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface ACButtonNode : SKSpriteNode

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIFont *font;

- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title font:(UIFont *)font;
- (void)addTarget:(id)target action:(SEL)action;

@end
