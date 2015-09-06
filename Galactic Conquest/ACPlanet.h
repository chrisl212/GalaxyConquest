//
//  ACPlanet.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ACPlanetKeyName;
extern NSString *const ACPlanetKeyParentStar;
extern NSString *const ACPlanetKeyTextureImage;
extern NSString *const ACPlanetKeyOrbitalDistance;

@class ACStar;

@interface ACPlanet : NSObject <NSCoding>

@property (strong, nonatomic) ACStar *parentStar;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) UIImage *textureImage;
@property (nonatomic) CGFloat orbitalDistance; //measured in 'AU', 1.0 being the furthest

- (id)initWithName:(NSString *)name parentStar:(ACStar *)parentStar textureImage:(UIImage *)textureImage orbitalDistance:(CGFloat)distance;

@end
