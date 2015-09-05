//
//  ACStar.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ACStarKeyName;
extern NSString *const ACStarKeyPlanets;
extern NSString *const ACStarKeyParentGalaxy;

@class ACGalaxy;

@interface ACStar : NSObject <NSCoding>

@property (strong, nonatomic) ACGalaxy *parentGalaxy;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *planets;

@end
