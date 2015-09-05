//
//  ACPlanet.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ACPlanetKeyName;
extern NSString *const ACPlanetKeyParentStar;

@class ACStar;

@interface ACPlanet : NSObject <NSCoding>

@property (strong, nonatomic) ACStar *parentStar;
@property (strong, nonatomic) NSString *name;

@end
