//
//  ACButtonNode.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACButtonNode.h"

#define CENTER_HEIGHT 0.5
#define CENTER_WIDTH 10.0
#define CORNER_HEIGHT 24.75
#define CORNER_WIDTH 20.0
#define TOTAL_HEIGHT 50.0
#define TOTAL_WIDTH 50.0
#define FONT_SIZE 22.0

@interface ACButtonNode ()

@property (strong, nonatomic) NSMutableArray *targets;
@property (strong, nonatomic) NSMutableArray *selectors;
@property (strong, nonatomic) SKLabelNode *labelNode;

@end

@implementation ACButtonNode

- (id)initWithTitle:(NSString *)title
{
    return [self initWithTitle:title font:[UIFont systemFontOfSize:FONT_SIZE]];
}

- (id)initWithTitle:(NSString *)title font:(UIFont *)font
{
    if (self = [super initWithImageNamed:@"button.png"])
    {
        self.targets = [NSMutableArray array];
        self.selectors = [NSMutableArray array];
        
        self.font = font;
        self.userInteractionEnabled = YES;
        
        self.centerRect = CGRectMake(CORNER_WIDTH/TOTAL_WIDTH, CORNER_HEIGHT/TOTAL_HEIGHT, CENTER_WIDTH/TOTAL_WIDTH, CENTER_HEIGHT/TOTAL_HEIGHT);
        CGSize size = [title boundingRectWithSize:CGSizeMake(500.0, 500.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.font} context:nil].size;
        size = CGSizeMake(size.width + 30.0, size.height + 15.0);
        
        self.xScale = size.width/self.size.width;
        self.yScale = size.height/self.size.height;
        
        self.labelNode = [[SKLabelNode alloc] initWithFontNamed:self.font.fontName];
        self.labelNode.fontSize = font.pointSize;
        self.labelNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        [self addObserver:self forKeyPath:@"parent" options:kNilOptions context:NULL];
        
        self.title = title;
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (self.parent)
        [self.parent addChild:self.labelNode], self.labelNode.position = self.position, [self removeObserver:self forKeyPath:keyPath];
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.labelNode.text = title;
}

#pragma mark - Targets/selectors

- (void)addTarget:(id)target action:(SEL)action
{
    [self.targets addObject:target];
    [self.selectors addObject:NSStringFromSelector(action)];
}

#pragma mark - Touch delegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.color = [UIColor grayColor];
    self.colorBlendFactor = 0.7;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    self.colorBlendFactor = 0.0;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    self.colorBlendFactor = 0.0;
    for (NSInteger i = 0; i < self.targets.count; i++) {
        SEL action = NSSelectorFromString(self.selectors[i]);
        [self.targets[i] performSelector:action];
    }
}

@end
