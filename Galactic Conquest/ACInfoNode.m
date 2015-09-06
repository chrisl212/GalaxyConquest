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
        CGFloat partSize = size.height/(strings.count+1);
        NSInteger counter = 0;
        
        for (NSString *titleString in strings)
        {
            UIFont *systemFont = [UIFont systemFontOfSize:10.0];
            SKLabelNode *labelNode = [[SKLabelNode alloc] init];
            labelNode.fontName = systemFont.fontName;
            labelNode.fontSize = systemFont.pointSize;
            labelNode.fontColor = [UIColor whiteColor];
            labelNode.text = titleString;
            labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            labelNode.position = CGPointMake(0.0, CGRectGetMidY(self.frame) - (partSize * (counter+1)));
            [self addChild:labelNode];
            
            counter++;
        }
    }
    return self;
}

@end
