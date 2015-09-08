//
//  ACStar.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ACStarKeyName;
extern NSString *const ACStarKeyPlanets;
extern NSString *const ACStarKeyParentGalaxy;
extern NSString *const ACStarKeyOrbitalDistance;
extern NSString *const ACStarKeyOrbitalAngle;

@class ACGalaxy;

@interface ACStar : NSObject <NSCoding>

@property (strong, nonatomic) ACGalaxy *parentGalaxy;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *planets;
@property (nonatomic) CGFloat orbitalDistance;
@property (nonatomic) CGFloat orbitalAngle;

- (id)initWithName:(NSString *)name parentGalaxy:(ACGalaxy *)parent;
- (id)initWithFile:(NSString *)path parentGalaxy:(ACGalaxy *)parent;

@end
