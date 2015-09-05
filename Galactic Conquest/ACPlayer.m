//
//  ACPlayer.m
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import "ACPlayer.h"

NSString *const ACPlayerKeyName = @"player-name";
NSString *const ACPlayerKeyColor = @"player-color";
NSString *const ACPlayerKeyImage = @"player-image";

@implementation ACPlayer

- (id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        self.name = name;
    }
    return self;
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:ACPlayerKeyName];
    [aCoder encodeObject:self.image forKey:ACPlayerKeyImage];
    [aCoder encodeObject:self.color forKey:ACPlayerKeyColor];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:ACPlayerKeyName];
        self.image = [aDecoder decodeObjectForKey:ACPlayerKeyImage];
        self.color = [aDecoder decodeObjectForKey:ACPlayerKeyColor];
    }
    return self;
}

@end
