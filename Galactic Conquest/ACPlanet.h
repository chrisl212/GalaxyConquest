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
extern NSString *const ACPlanetKeyOwner;
extern NSString *const ACPlanetKeyMineralValue;
extern NSString *const ACPlanetKeyFuelValue;
extern NSString *const ACPlanetKeyFleets;
extern NSString *const ACPlanetKeyType;
extern NSString *const ACPlanetKeyInhabited;
extern NSString *const ACPlanetKeyAtmosphere;
extern NSString *const ACPlanetKeyBuildQueue;

extern NSString *const ACPlanetTypeGas; //only space battles
extern NSString *const ACPlanetTypeRocky; //space/land battles

@class ACStar, ACPlayer;

@interface ACPlanet : NSObject <NSCoding>

@property (strong, nonatomic) ACStar *parentStar;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) UIImage *textureImage;
@property (strong, nonatomic) NSString *textureImageName;
@property (strong, nonatomic) ACPlayer *owner;
@property (nonatomic) NSInteger mineralValue;
@property (nonatomic) NSInteger fuelValue;
@property (nonatomic) CGFloat orbitalDistance; //measured in 'AU', 1.0 being the furthest
@property (nonatomic) BOOL inhabited; //if inhabited, must fight for it if unowned
@property (nonatomic) BOOL atmosphere;
@property (strong, nonatomic) NSArray *fleets;
@property (strong, nonatomic) NSMutableArray *buildQueue;

- (NSString *)textureImageFilePath;
- (id)initWithName:(NSString *)name parentStar:(ACStar *)parentStar textureImage:(NSString *)textureImageName orbitalDistance:(CGFloat)distance;

@end
