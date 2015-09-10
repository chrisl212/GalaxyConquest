//
//  ACGalaxy.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/4/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ACGalaxyKeyName;
extern NSString *const ACGalaxyKeyStars;
extern NSString *const ACGalaxyKeyTextureImage;
extern NSString *const ACGalaxyKeyGalacticRadius;

@class ACStar;

@interface ACGalaxy : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *stars;
@property (strong, nonatomic) NSString *textureImageName;
@property (nonatomic) CGFloat galacticRadius;

- (id)initWithName:(NSString *)name;
- (id)initWithFile:(NSString *)filePath;
- (NSString *)textureImageFilePath;

@end

@interface ACGalaxy (DistanceCalculations)

- (CGFloat)distanceFromStar:(ACStar *)s1 toStar:(ACStar *)s2;
- (NSInteger)turnNumberFromDistance:(CGFloat)distance;

@end