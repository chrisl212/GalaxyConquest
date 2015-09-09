//
//  ACBuildTableViewDataSource.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/8/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACPlanet;

@interface ACBuildTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

- (id)initWithPlanet:(ACPlanet *)planet;

@end
