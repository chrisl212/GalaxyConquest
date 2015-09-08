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

@interface ACGalaxy : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *stars;
@property (strong, nonatomic) UIImage *textureImage;
@property (nonatomic) CGFloat galacticRadius;

- (id)initWithName:(NSString *)name image:(UIImage *)textureImage;
- (id)initWithFile:(NSString *)filePath;

@end
