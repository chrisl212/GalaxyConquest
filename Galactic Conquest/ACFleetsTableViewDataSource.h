//
//  ACFleetsTableViewDataSource.h
//  Galactic Conquest
//
//  Created by Christopher Loonam on 9/9/15.
//  Copyright (c) 2015 Christopher Loonam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ACPlanet;

@protocol ACFleetsTableDelegate <NSObject>

- (void)dismissFleetsTable;

@end

@interface ACFleetsTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<ACFleetsTableDelegate> delegate;

- (id)initWithPlanet:(ACPlanet *)planet delegate:(id<ACFleetsTableDelegate>)delegate;

@end
