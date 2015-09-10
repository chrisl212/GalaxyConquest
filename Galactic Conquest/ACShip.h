//
//  ACShip.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const ACShipKeyName;
extern NSString *const ACShipKeyFuelCost;
extern NSString *const ACShipKeyMineralsCost;
extern NSString *const ACShipKeyHP;
extern NSString *const ACShipKeySceneName;

@interface ACShip : NSObject <NSCoding, NSCopying>

@property (strong, nonatomic) NSString *name;
@property (nonatomic) NSInteger fuelCost;
@property (nonatomic) NSInteger mineralsCost;
@property (nonatomic) NSInteger hp;

- (NSString *)scenePath;
- (id)initWithFile:(NSString *)file;

@end
