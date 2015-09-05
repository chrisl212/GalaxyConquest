//
//  ACGalaxyNode.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACGalaxyNode.h"
#import "ACGalaxy.h"

@implementation ACGalaxyNode

- (id)initWithGalaxy:(ACGalaxy *)galaxy
{
    return [self initWithTexture:[SKTexture textureWithImage:galaxy.textureImage]];
}

@end
