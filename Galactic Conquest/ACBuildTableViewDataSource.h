//
//  ACBuildTableViewDataSource.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/8/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACPlanet;

typedef struct
{
    NSInteger fuelCost;
    NSInteger mineralsCost;
} ACBuildCost;

@protocol ACBuildDelegate <NSObject>

- (BOOL)userCanAffordCost:(ACBuildCost)cost;

@optional
- (void)userDidBuildShips:(NSArray *)ships cost:(ACBuildCost)cost;

@end

@interface ACBuildTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<ACBuildDelegate> delegate;

- (id)initWithDelegate:(id<ACBuildDelegate>)delegate;

@end
