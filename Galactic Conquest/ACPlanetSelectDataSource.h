//
//  ACPlanetSelectDataSource.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/9/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACPlanet, ACFleet;

@protocol ACPlanetSelectDelegate <NSObject>

- (void)planetWasSelected:(ACPlanet *)planet;

@end

@interface ACPlanetSelectDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) ACFleet *fleet;
@property (weak, nonatomic) id<ACPlanetSelectDelegate> delegate;

- (id)initWithFleet:(ACFleet *)fleet delegate:(id<ACPlanetSelectDelegate>)delegate;

@end
