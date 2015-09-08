//
//  ACInfoNode.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/6/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACInfoNode.h"

@implementation ACInfoNode

- (id)initWithStrings:(NSArray *)strings size:(CGSize)size
{
    if (self = [super initWithColor:[UIColor grayColor] size:size])
    {
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        self.anchorPoint = CGPointMake(0.0, 1.0);
        
        for (NSString *titleString in strings)
        {
            UIFont *systemFont = [UIFont systemFontOfSize:10.0];
            
            CGSize textSize = [titleString boundingRectWithSize:size options:kNilOptions attributes:@{NSFontAttributeName: systemFont} context:nil].size;
            if (textSize.width > width)
                width = textSize.width;
            height += textSize.height + 2.0;
            
            SKLabelNode *labelNode = [[SKLabelNode alloc] init];
            labelNode.fontName = systemFont.fontName;
            labelNode.fontSize = systemFont.pointSize;
            labelNode.fontColor = [UIColor whiteColor];
            labelNode.text = titleString;
            labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeBottom;
            [self addChild:labelNode];
        }
        self.size = CGSizeMake(width, height);

        CGFloat partSize = self.size.height/(strings.count+1) + 2.0;
        self.alpha = 0.7;
        self.userInteractionEnabled = YES;
        for (int i = 0; i < self.children.count; i++)
        {
            SKLabelNode *labelNode = (SKLabelNode *)self.children[i];
            labelNode.position = CGPointMake(0.0, CGRectGetMaxY(self.frame) - (partSize * (i+1)));
        }
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.parent touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.parent touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.parent touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.parent touchesMoved:touches withEvent:event];
}

@end
