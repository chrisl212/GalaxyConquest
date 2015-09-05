//
//  ACGalaxy.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACGalaxy.h"

NSString *const ACGalaxyKeyName = @"galaxy-name";
NSString *const ACGalaxyKeyStars = @"galaxy-stars";
NSString *const ACGalaxyKeyTextureImage = @"galaxy-texture";

@implementation ACGalaxy

- (id)initWithName:(NSString *)name image:(UIImage *)textureImage
{
    if (self = [super init])
    {
        self.name = name;
        self.textureImage = textureImage;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACGalaxyKeyName];
    [aCoder encodeObject:self.stars forKey:ACGalaxyKeyStars];
    [aCoder encodeObject:self.textureImage forKey:ACGalaxyKeyTextureImage];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACGalaxyKeyName];
        self.stars = [aDecoder decodeObjectForKey:ACGalaxyKeyStars];
        self.textureImage = [aDecoder decodeObjectForKey:ACGalaxyKeyTextureImage];
    }
    return self;
}

@end
