//
//  ACShip.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ACShipKeyName;
extern NSString *const ACShipKeyFuelCost;
extern NSString *const ACShipKeyMineralsCost;
extern NSString *const ACShipKeyHP;
extern NSString *const ACShipKeyImageFileName;
extern NSString *const ACShipKeySceneFileName;
extern NSString *const ACShipKeyEnginePositions;

@interface ACShip : NSObject <NSCoding, NSCopying>

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger fuelCost;
@property (nonatomic) NSInteger mineralsCost;
@property (nonatomic) NSInteger hp;
@property (strong, nonatomic) NSString *imageFileName;
@property (strong, nonatomic) NSString *sceneFileName;
@property (nonatomic) CGPoint *enginePositions;

- (NSString *)sceneFilePath;
- (NSString *)imageFilePath;
- (NSString *)scenePath;
- (id)initWithFile:(NSString *)file;

@end
