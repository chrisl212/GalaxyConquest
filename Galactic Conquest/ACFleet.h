//
//  ACFleet.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/7/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ACPlayer;

extern NSString *const ACFleetKeyOwner;
extern NSString *const ACFleetKeyShips;

@interface ACFleet : NSObject <NSCoding>

@property (strong, nonatomic) ACPlayer *owner;
@property (strong, nonatomic) NSMutableArray *ships;

- (id)initWithOwner:(ACPlayer *)owner;

@end
